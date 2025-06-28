//
//  ProjectViewModel.swift
//  Kamelna
//
//  Created by Kerlos on 20/06/2025.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

class ProjectViewModel: ObservableObject{
    static let shared = ProjectViewModel()
    
    let roomId = UserDefaults.standard.string(forKey: "roomId")
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    private init()  {}
    
    func canChooseProject(hand: [String], roundType: String, projectType: ProjectTypes) -> Bool {
        let ranksOrder = ["7", "8", "9", "10", "J", "Q", "K", "A"]

        // Extract only rank from card
        let ranks = hand.map { card in
            return String(card.prefix { $0.isLetter || $0.isNumber })
        }

        // Remove duplicate ranks for sequence logic
        let uniqueRanks = Array(Set(ranks))

        func hasConsecutive(_ count: Int) -> Bool {
            let combos = uniqueRanks.combinations(ofCount: count)
            
            for combo in combos {
                let indices = combo.compactMap { ranksOrder.firstIndex(of: $0) }.sorted()
                guard indices.count == count else { continue }

                var isSequential = true
                for i in 1..<count {
                    if indices[i] != indices[i - 1] + 1 {
                        isSequential = false
                        break
                    }
                }
                if isSequential { return true }
            }
            return false
        }

        func faceCardCount() -> Int {
            return ranks.filter { ["J", "Q", "K"].contains($0) }.count
        }

        let rankCounts = Dictionary(grouping: ranks, by: { $0 }).mapValues { $0.count }

        switch projectType {
        case .fourHundred:
            return roundType == "صن" && rankCounts["A"] == 4
        case .hundred:
            return hasConsecutive(5) || faceCardCount() >= 4
        case .fifty:
            return hasConsecutive(4)
        case .sra:
            return hasConsecutive(3)
        }
    }
    
    func addProjectToRoom(
            team: String,
            projectType: ProjectTypes,
            completion: ((Error?) -> Void)? = nil
    ) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId ?? "")
        
        let projectEntry: [String: Any] = [
            "type": projectType.rawValue,
            "playerId": userId ?? "",
            "team": team,
            //"id": UUID().uuidString
            //"timestamp": FieldValue.serverTimestamp()
        ]
        
        roomRef.updateData([
            "projects": FieldValue.arrayUnion([projectEntry])
        ]) { error in
            if let error = error {
                print("❌ Error adding project: \(error)")
            } else {
                print("✅ Project '\(projectType.rawValue)' added for player \(self.userId), team \(team)")
            }
            completion?(error)
        }
    }
    
    func fetchDataForProjectChecking(roomId: String, userId: String, completion: @escaping (_ hand: [String], _ team: String, _ roundType: String) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        roomRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let roundType = data["roundType"] as? String,
                  let players = data["players"] as? [String: Any],
                  let currentPlayer = players[userId] as? [String: Any],
                  let hand = currentPlayer["hand"] as? [String],
                  let teamNumber = currentPlayer["team"] else {
                print("❌ Could not get player data.")
                completion([], "", "")
                return
            }

            completion(hand, "\(teamNumber)", roundType)
        }
    }
    
}

extension Array {
    func combinations(ofCount k: Int) -> [[Element]] {
        guard k > 0 else { return [[]] }
        guard count >= k else { return [] }
        if k == 1 { return self.map { [$0] } }
        
        var result: [[Element]] = []
        for (i, value) in self.enumerated() {
            let rest = Array(self[(i+1)...])
            let subCombos = rest.combinations(ofCount: k - 1)
            result += subCombos.map { [value] + $0 }
        }
        return result
    }
    
    func combinations2(ofCount k: Int) -> [[Element]] {
        guard k > 0 else { return [[]] }
        guard let first = self.first else { return [] }
        
        let subcombos = Array(self.dropFirst()).combinations(ofCount: k - 1)
        let withFirst = subcombos.map { [first] + $0 }
        let withoutFirst = Array(self.dropFirst()).combinations(ofCount: k)
        
        return withFirst + withoutFirst
    }
}
