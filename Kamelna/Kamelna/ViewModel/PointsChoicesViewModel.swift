//
//  PointsChoices.swift
//  Kamelna
//
//  Created by Kerlos on 21/06/2025.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Combine

class PointsChoicesViewModel: ObservableObject {
    static let shared = PointsChoicesViewModel()

    @Published var availableChoices: [String] = []
    @Published var userTeam: Int = 0

    private var roomId: String = UserDefaults.standard.string(forKey: "roomId") ?? ""
    private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""

    private var listener: ListenerRegistration?

    private init() {
        listenToRoomUpdates()
    }

    private func listenToRoomUpdates() {
        let db = Firestore.firestore()
        listener = db.collection("rooms").document(roomId).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self, let data = snapshot?.data() else { return }

            if let players = data["players"] as? [String: [String: Any]],
               let playerData = players[self.userId],
               let team = playerData["team"] as? Int {
                DispatchQueue.main.async {
                    self.userTeam = team
                    self.updateChoices(data: data)
                }
            }
        }
    }

    private func updateChoices(data: [String: Any]) {
        guard let roundType = data["roundType"] as? String else {
            self.availableChoices = []
            return
        }
        let teamScores = data["teamScores"] as? [String: Int] ?? [:]
        let team1Score = teamScores["team1"] ?? 0
        let team2Score = teamScores["team2"] ?? 0
        let roundStatus = data["status"] as? String ?? ""
        // Read the current button states from Firebase
        let double = (data["double"] as? [String: Any])?["isActive"] as? Bool ?? false
        let three = (data["three"] as? [String: Any])?["isActive"] as? Bool ?? false
        let four = (data["four"] as? [String: Any])?["isActive"] as? Bool ?? false
        
        // Determine choices based on the sequence
        if roundType == "حكم" {
            if !double && !three && !four {
                // Initial stage
                if self.userTeam == 1 {
                    self.availableChoices = ["ثلاثة", "بس"]
                } else {
                    self.availableChoices = ["دبل", "بس"]
                }
            } else if double && !three && !four {
                // Double chosen by opponent team, now your team can choose
                if self.userTeam == 1 {
                    self.availableChoices = ["ثلاثة", "بس"]
                } else {
                    self.availableChoices = ["بس"]
                }
            } else if three && !four {
                // Three chosen, now other team can choose four
                if self.userTeam == 2 {
                    self.availableChoices = ["أربعة", "بس"]
                } else {
                    self.availableChoices = ["بس"]
                }
            } else if four {
                // Four chosen, now your team can choose coffee
                if self.userTeam == 1 {
                    self.availableChoices = ["قهوة", "بس"]
                } else {
                    self.availableChoices = ["بس"]
                }
            } else {
                // All options used, default to بس
                self.availableChoices = ["بس"]
            }
        }
        else if roundType == "صن" {
            // Check if teams are separated by 100 points
            let highTeam = team1Score > 100 ? 1 : (team2Score > 100 ? 2 : nil)
            let lowTeam = team1Score < 100 ? 1 : (team2Score < 100 ? 2 : nil)
            
            // Only if one team is above 100 and the other below
            if let highTeam = highTeam, let lowTeam = lowTeam {
                // If my team is the lower one, I can choose "دبل" or "بس"
                if self.userTeam == lowTeam {
                    self.availableChoices = ["دبل", "بس"]
                } else {
                    // If my team is the higher one, I see buttons but they are disabled
                    self.availableChoices = ["دبل (غير متاح)", "بس (غير متاح)"]
                }
            } else {
                // If no team is above 100, or both are above/below -> No special options
                self.availableChoices = []
            }
        }
        
        /// --------------------------- Other Cases ---------------------------
        else {
            self.availableChoices = []
        }
    }

    func chooseOption(option: String) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        var fieldToUpdate = ""
        if option == "دبل" {
            fieldToUpdate = "double"
        } else if option == "ثلاثة" {
            fieldToUpdate = "three"
        } else if option == "أربعة" {
            fieldToUpdate = "four"
        } else if option == "قهوة" {
            fieldToUpdate = "coffee"
        }

        if fieldToUpdate.isEmpty {
            print("Player chose بس (pass), no Firestore update required.")
            return
        }

        roomRef.updateData([
            "\(fieldToUpdate).isActive": true,
            "\(fieldToUpdate).choicedBy": userId
        ]) { error in
            if let error = error {
                print("❌ Error updating \(fieldToUpdate): \(error.localizedDescription)")
            } else {
                print("✅ \(fieldToUpdate) successfully updated.")
            }
        }
    }

    deinit {
        listener?.remove()
    }
}

