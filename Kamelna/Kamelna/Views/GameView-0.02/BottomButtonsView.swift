//
//  BottomButtonsView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 17/05/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct BottomButtonsView: View {
    let userName: String
    let status: String

    @State private var currentSelector: String? = nil
    @State private var roundTypeChosen = false
    @State private var timeLeft: Int = 10
    @State private var timer: Timer? = nil

    let roomId = UserDefaults.standard.string(forKey: "roomId")
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    var body: some View {
        VStack(spacing: 10) {
            // User info and icons
            HStack(spacing: 10) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(userName)
                        .font(.body)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(SelectedButtonBackGroundColor.backgroundGradient)
                        .cornerRadius(10)
                    
                    Text(status)
                        .font(.caption)
                        .padding(6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)

                HStack(spacing: 10) {
                    iconButton(systemName: "gift.fill", label: "Send gift", action: {
                        print("gift clicked")
                    })
                    iconButton(systemName: "flame", label: "Fire action", action: {
                        print("fire clicked")
                    })
                }
            }
            .padding()
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(15)

            // Action buttons row
            HStack {
                let isMyTurn = currentSelector == userId && !roundTypeChosen
                actionButton(title: "بس", action: {
                    print("بس clicked")
                    chooseRoundType("بس")
                })
                .disabled(!isMyTurn)
                
                Spacer()
                
                actionButton(title: "حكم", action: {
                    print("حكم clicked")
                    chooseRoundType("حكم")
                }).disabled(!isMyTurn)
                
                Spacer()
                
                actionButton(title: "صن", action: {
                    print("صن clicked")
                    chooseRoundType("صن")
                }).disabled(!isMyTurn)
            }
            .padding()
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -3)
            .offset(y :-20)
        }
//        .padding(.horizontal)
        .onAppear {
            startPollingForRoundSelection()
        }
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

            if self.timeLeft == 0 && !roundTypeChosen {
                advanceToNextSelector()
            }
        }
    }

    func chooseRoundType(_ type: String) {
        guard let roomId = roomId, !roundTypeChosen else { return }

        roundTypeChosen = true

        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        // Default to empty trumpSuit
        var updates: [String: Any] = [
            "roundType": type,
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
                    updates["trumpSuit"] = "" // fallback in case suit isn't found
                }

                roomRef.updateData(updates) { error in
                    if let error = error {
                        print("Error setting roundType with trumpSuit: \(error)")
                    } else {
                        print("Round type '\(type)' set with trump suit \(updates["trumpSuit"] ?? "")")
                    }
                }
            }
        } else {
            // "صن" or other: no trump
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

    // MARK: - Reusable Button Views

    func iconButton(systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding()
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
        }
        .accessibilityLabel(label)
        .background(ButtonBackGroundColor.backgroundGradient)
        .cornerRadius(20)
    }

    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .frame(minWidth: 110)
                .padding(.vertical, 10)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(10)
        }
    }
}

#Preview {
    BottomButtonsView(userName: "Youssab", status: "جديد")
}
