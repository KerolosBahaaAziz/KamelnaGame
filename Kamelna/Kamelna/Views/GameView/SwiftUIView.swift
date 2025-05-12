//
//  GameView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI
import FirebaseFirestore

struct GameView2: View {
    @State private var hand: [String] = []
    @State private var players: [String: String] = [:] // userId -> name
    @State private var currentTrick: [String: String] = [:] // userId -> card
    @State private var playedCardID: String? = nil
    @State private var trickListener: ListenerRegistration?
    @State private var playersListener: ListenerRegistration?

    @Binding var roomId: String
    var currentUserId: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.green.opacity(0.4).edgesIgnoringSafeArea(.all)

                // === Cards on the ground ===
                ForEach(Array(players.keys.sorted().enumerated()), id: \.1) { index, userId in
                    let angle = Double(index) * (360.0 / Double(players.count))
                    let radius: CGFloat = 120
                    let x = geometry.size.width / 2 + radius * CGFloat(cos(angle * .pi / 180))
                    let y = geometry.size.height / 2 + radius * CGFloat(sin(angle * .pi / 180))

                    VStack {
                        Text(players[userId] ?? "")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        if let cardString = currentTrick[userId],
                           let card = parseCard(from: cardString) {
                            CardView(card: card)
                                .frame(width: 50, height: 70)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .bottom).combined(with: .opacity)
                                    )
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 50, height: 70)
                        }
                    }
                    .position(x: x, y: y)
                }

                // === Your Hand (bottom) ===
                VStack {
                    Text("Your Hand")
                        .font(.headline)
                        .foregroundColor(.white)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(hand, id: \.self) { cardString in
                                if let card = parseCard(from: cardString) {
                                    CardView(card: card)
                                        .frame(width: 60, height: 90)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(playedCardID == cardString ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                        .onTapGesture {
                                            playCard(cardString)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 130)
            }
            .onAppear {
                fetchPlayers()
                fetchHand()
                listenToCurrentTrick()
            }
            .onDisappear {
                trickListener?.remove()
                playersListener?.remove()
            }
        }
    }

    // === Parse card string "10♠️" into Card model ===
    private func parseCard(from string: String) -> Card? {
        let suits = ["♥️": Card.Suit.hearts, "♦️": Card.Suit.diamonds, "♣️": Card.Suit.clubs, "♠️": Card.Suit.spades]
        for (suitSymbol, suitEnum) in suits {
            if string.contains(suitSymbol) {
                let valuePart = string.replacingOccurrences(of: suitSymbol, with: "")
                if let valueEnum = Card.CardValue(rawValue: valuePart) {
                    return Card(suit: suitEnum, value: valueEnum)
                }
            }
        }
        return nil
    }

    // === Firestore fetch players ===
     func fetchPlayers() {
        let db = Firestore.firestore()
        playersListener = db.collection("rooms").document(roomId).addSnapshotListener { docSnapshot, error in
            if let data = docSnapshot?.data(),
               let playersMap = data["players"] as? [String: Any] {
                var temp: [String: String] = [:]
                for (userId, value) in playersMap {
                    if let playerData = value as? [String: Any],
                       let name = playerData["name"] as? String {
                        temp[userId] = name
                    }
                }
                self.players = temp
            }
        }
    }

    private func handleBotsIfNeeded(currentCards: [String: String]) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        roomRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let players = data["players"] as? [String: Any] else { return }

            // If already 4 cards played, do nothing
            if currentCards.count >= 4 { return }

            // Find whose turn is next (players who hasn't played yet)
            for (userId, _) in players {
                if currentCards[userId] == nil {
                    // If it's a bot's turn, make it play
                    if userId.hasPrefix("bot_") {
                        print("go to playBotTurn function")
                        BotsManager.shared.playBotTurn(playerId: userId, roomId: roomId)

                        // Call again after small delay to handle chain reaction
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            listenToCurrentTrick() // Triggers the listener again
                        }
                    }
                    break // Stop after finding the next turn player
                }
            }
        }
    }

    
    // === Fetch current user hand ===
    private func fetchHand() {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomId).getDocument { docSnapshot, error in
            if let data = docSnapshot?.data(),
               let players = data["players"] as? [String: Any],
               let me = players[currentUserId] as? [String: Any],
               let handArray = me["hand"] as? [String] {
                self.hand = handArray
            }
        }
    }

    // === Listen to current trick ===
    private func listenToCurrentTrick() {
        let db = Firestore.firestore()
        trickListener = db.collection("rooms").document(roomId).addSnapshotListener { docSnapshot, error in
            if let data = docSnapshot?.data(),
               let trick = data["currentTrick"] as? [String: Any],
               let cards = trick["cards"] as? [String: String] {
                self.currentTrick = cards

                // When 4 cards played, call end round
                if cards.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        endRound()
                    }
                }else {
                    // Bots logic: Check if it's a bot's turn to play
                    handleBotsIfNeeded(currentCards: cards)
                }
            }
        }
    }

    // === Play card ===
    private func playCard(_ card: String) {
        guard hand.contains(card) else { return }
        playedCardID = card

        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        // Remove card from hand and add to currentTrick
        roomRef.updateData([
            "players.\(currentUserId).hand": FieldValue.arrayRemove([card]),
            "currentTrick.cards.\(currentUserId)": card
        ]) { error in
            if let error = error {
                print("Error playing card: \(error)")
            } else {
                if let index = hand.firstIndex(of: card) {
                    hand.remove(at: index)
                }
                playedCardID = nil
            }
        }
    }

    // === End round (clear table cards) ===
    private func endRound() {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        roomRef.updateData([
            "currentTrick.cards": [:] // Clear table cards
        ]) { error in
            if let error = error {
                print("Error ending round: \(error)")
            } else {
                print("Round ended, table cleared.")
            }
        }
    }
}


struct CardTextView: View {
    let card: String
    var isPlayed: Bool = false
    
    var body: some View {
        Text(card)
            .font(.largeTitle)
            .padding()
            .background(isPlayed ? Color.gray : Color.white)
            .cornerRadius(8)
            .shadow(radius: 5)
    }
}

// Extension for safe array indexing
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


#Preview {
    @Previewable @State var roomId = ""
    GameView2(roomId: $roomId, currentUserId: "0")
}

