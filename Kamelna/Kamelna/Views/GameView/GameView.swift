//
//  GameView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//
/*/
import SwiftUI
import Firebase

struct GameView: View {
    @State private var room: Room?
    @State private var roomId: String
    @State private var currentUserId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    init(roomId: String) {
        _roomId = State(initialValue: roomId)
    }

    var body: some View {
        VStack {
            if let room = room {
                VStack(spacing: 12) {
                    Text("🃏 جولة رقم \(room.roundNumber)")
                        .font(.title2)
                        .bold()
                    
                    if let turnId = room.turnPlayerId {
                        Text("الدور على: \(turnId == currentUserId ? "أنت" : playerName(for: turnId))")
                            .foregroundColor(.blue)
                    }
                    
                    Divider()

                    ForEach(room.players.keys.sorted(), id: \.self) { playerId in
                        if let player = room.players[playerId] {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("👤 \(player.name) - فريق \(player.team)")
                                    .fontWeight(.semibold)
                                
                                Text("نقاطه: \(player.score)")

                                if player.id == currentUserId {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(player.hand, id: \.self) { card in
                                                Button(action: {
                                                    playCard(card)
                                                }) {
                                                    Text(card)
                                                        .padding(8)
                                                        .background(Color.orange.opacity(0.3))
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Text("عدد الكروت بيد اللاعب: \(player.hand.count)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }

                    Divider()

                    Text("🃏 الكروت في الجولة الحالية:")
                        .font(.headline)
                    
                    ForEach(room.currentTrick.sorted(by: { $0.key < $1.key }), id: \.key) { playerId, card in
                        Text("\(playerName(for: playerId)): \(card)")
                    }

                    if let winner = room.trickWinner {
                        Text("🥇 الفائز بالجولة: \(playerName(for: winner))")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                .padding()
            } else {
                ProgressView("جاري تحميل اللعبة...")
                    .onAppear {
                        listenToRoom()
                    }
            }
        }
        .navigationBarTitle("لعبة بلوت", displayMode: .inline)
    }

    private func listenToRoom() {
        RoomManager.shared.listenToRoom(roomId: roomId) { updatedRoom in
            DispatchQueue.main.async {
                self.room = updatedRoom
            }
        }
    }

    private func playCard(_ card: String) {
        guard let room = room else { return }
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        roomRef.updateData([
            "currentTrick.\(currentUserId)": card,
            "players.\(currentUserId).playedCard": card,
            "players.\(currentUserId).hand": FieldValue.arrayRemove([card])
        ]) { error in
            if let error = error {
                print("Error playing card: \(error.localizedDescription)")
            }
        }
    }

    private func playerName(for id: String) -> String {
        room?.players.first(where: { $0.id == id })?.name ?? "مجهول"
    }
}

#Preview {
    @Previewable @State var roomId = ""
    GameView(roomId: $roomId)
}
*/

