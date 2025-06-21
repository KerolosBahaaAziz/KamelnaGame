//
//  RoundTypeViewModel.swift
//  Kamelna
//
//  Created by Kerlos on 20/06/2025.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Combine

class RoundTypeViewModel: ObservableObject{
    static let shared = RoundTypeViewModel()
    
    @Published var currentSelector: String? = nil
    @Published var roundTypeChosen = false
    @Published var timeLeft: Int = 10
    @Published var timer: Timer? = nil
    
    private var cancellables = Set<AnyCancellable>()
    let roomId = UserDefaults.standard.string(forKey: "roomId")
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    private init() {
        startPollingForRoundSelection()
    }
    
    func startPollingForRoundSelection() {
        if roomId == nil {
            print("no room id available")
            return
        }
        
        let roomRef = Firestore.firestore().collection("rooms").document(roomId ?? "")

        roomRef.addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(),
                  let selection = data["roundSelection"] as? [String: Any],
                  let selector = selection["currentSelector"] as? String,
                  let startTimestamp = selection["startTime"] as? Timestamp else {
                return
            }

            self.currentSelector = selector

            let elapsed = Int(Date().timeIntervalSince1970 - startTimestamp.dateValue().timeIntervalSince1970)
            self.timeLeft = max(0, 10 - elapsed)

            if self.timeLeft == 0 && !self.roundTypeChosen {
                self.advanceToNextSelector()
            }
        }
    }
    
    func chooseRoundType(_ type: String) {
        //guard let roomId = roomId, !roundTypeChosen else { return }

        roundTypeChosen = true

        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId ?? "")

        // Get current user ID
        guard let userId = userId else { return }

        if type == "بس" {
            // Mark that this user chose بس
            roomRef.updateData([
                "roundType": type,
                "roundSelection.basCandidate": userId
            ]) { error in
                if let error = error {
                    print("Error recording بس candidate: \(error)")
                } else {
                    print("\(userId) chose بس — deferring decision.")
                }
            }
            return
        }

        // If another round type is chosen, remove any بس candidate
        var updates: [String: Any] = [
            "roundType": type,
            "roundSelection.basCandidate": NSNull()
        ]

        if type == "حكم" {
            roomRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      let currentTrick = data["currentTrick"] as? [String: Any],
                      let cards = currentTrick["cards"] as? [[String: Any]],
                      let firstCard = cards.first?["card"] as? String else {
                    print("Error: Could not extract card to determine trump suit")
                    return
                }

                if let suit = Suit.allCases.first(where: { firstCard.contains($0.rawValue) }) {
                    updates["trumpSuit"] = suit.rawValue
                } else {
                    updates["trumpSuit"] = ""
                }

                roomRef.updateData(updates) { error in
                    if let error = error {
                        print("Error setting حكم roundType: \(error)")
                    } else {
                        print("حكم selected with trump suit: \(updates["trumpSuit"] ?? "")")
                    }
                }
            }
        } else {
            updates["trumpSuit"] = ""

            roomRef.updateData(updates) { error in
                if let error = error {
                    print("Error setting roundType: \(error)")
                } else {
                    print("Round type '\(type)' set with no trump suit")
                }
            }
        }
    }

    func advanceToNextSelector() {
        if roomId == nil {
            print("no room id available")
            return
        }
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId ?? "")

        roomRef.getDocument { snapshot, _ in
            guard let data = snapshot?.data(),
                  let order = data["playerOrder"] as? [String],
                  let current = data["roundSelection"] as? [String: Any],
                  let currentSelector = current["currentSelector"] as? String,
                  let currentIndex = order.firstIndex(of: currentSelector),
                  currentIndex < 3 else {
                print("No next player")
                return
            }

            let nextSelector = order[currentIndex + 1]

            roomRef.updateData([
                "roundSelection.currentSelector": nextSelector,
                "roundSelection.startTime": FieldValue.serverTimestamp()
            ])
        }
    }
    
}
