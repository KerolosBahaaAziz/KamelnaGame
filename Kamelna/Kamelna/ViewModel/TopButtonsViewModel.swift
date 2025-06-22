//
//  TopButtonsViewModel.swift
//  Kamelna
//
//  Created by Kerlos on 21/06/2025.
//

import Foundation
import FirebaseFirestore

class TopButtonsViewModel: ObservableObject {
    @Published var usScore: Int = 0
    @Published var themScore: Int = 0
    @Published var userTeam: Int?
    
    private var listener: ListenerRegistration?
    
    func listenToScores(roomId: String, userId: String) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomId).addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data() else {
                print("⚠️ Failed to fetch room data")
                return
            }
            
            // Get team scores
            let teamScores = data["teamScores"] as? [String: Int] ?? [:]
            
            // Get player's team from players map
            if let players = data["players"] as? [String: [String: Any]],
               let player = players[userId],
               let team = player["team"] as? Int {
                
                DispatchQueue.main.async {
                    self.userTeam = team
                    
                    if team == 1 {
                        self.usScore = teamScores["team1"] ?? 0
                        self.themScore = teamScores["team2"] ?? 0
                    } else {
                        self.usScore = teamScores["team2"] ?? 0
                        self.themScore = teamScores["team1"] ?? 0
                    }
                }
            }
        }
    }
    
    deinit {
        listener?.remove()
        print("🧹 TopButtonsViewModel deinitialized and Firestore listener removed.")
    }
}

