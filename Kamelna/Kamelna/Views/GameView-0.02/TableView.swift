//
//  TableView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 12/05/2025.
//

import SwiftUI

struct TableView: View {
    let currentPlayer: Player
    let otherPlayers: [Player] // Should contain 3 other players
    let playedCards: [String: Card] // player.id : Card
    let playCard: (Card) -> Void

    var body: some View {
        ZStack {
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            VStack {
                // Top Player (opposite the current player)
                if let topPlayer = playerForRelativeSeat(2) {
                    OtherPlayerView(player: topPlayer, cardCount: topPlayer.hand.count)
                        .frame(width: 90)
                }

                GeometryReader { geometry in
                    HStack {
                        // Left Player
                        if let leftPlayer = playerForRelativeSeat(1) {
                            VStack {
                                Spacer()
                                OtherPlayerView(player: leftPlayer, cardCount: leftPlayer.hand.count)
//                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 90)
                                    .offset(x: 30 ,y: -60)
                                Spacer()
                            }
                        }

                        Spacer()

                        // Center Played Cards and Logo
                        ZStack(alignment: .center) {
                            // Static Logo
                            LogoView(width: 120, height: 120)
                            
                            // Played Cards & Player Names (positioned above the logo)
                            VStack(spacing: 4) {
                                HStack(spacing: 8) {
                                    ForEach(playedCards.sorted(by: { $0.key < $1.key }), id: \.key) { playerId, card in
                                        VStack(spacing: 2) {
                                            CardView(card: card)
                                            Text(playerName(for: playerId))
                                                .font(.caption2)
                                        }
                                    }
                                }
                                Text("الأوراق الملعوبة")
                                    .font(.caption)
                            }
                            .offset(y :100) // Push it above the logo
                        }
                        .frame(width: geometry.size.width * 0.4, height: 150)
                        .offset(y :50)


                        Spacer()

                        // Right Player
                        if let rightPlayer = playerForRelativeSeat(3) {
                            VStack {
                                Spacer()
                                OtherPlayerView(player: rightPlayer, cardCount: rightPlayer.hand.count)
//                                    .rotationEffect(.degrees(90))
                                    .frame(width: 90)
                                    .offset(x: -30 ,y: -60)
                                Spacer()
                            }
                        }
                    }
                }
                .frame(height: 350) // Adjust height as needed
                
                // Bottom Player (Current Player)
                CurrentPlayerGameView(player: currentPlayer, playCard: playCard)
            }
            .padding()
        }
    }

    // Calculate the player for a relative seat position based on currentPlayer's seat
    private func playerForRelativeSeat(_ relativeSeat: Int) -> Player? {
        // Normalize the seat numbers relative to the current player's seat
        let absoluteSeat = (currentPlayer.seat + relativeSeat) % 4
        return otherPlayers.first(where: { $0.seat == absoluteSeat })
    }

    private func playerName(for id: String) -> String {
        if currentPlayer.id == id { return currentPlayer.name }
        return otherPlayers.first(where: { $0.id == id })?.name ?? "?"
    }
}

#Preview {
    let currentPlayer = Player(
        id: "1", name: "ياسر", seat: 1, // Changed to test a different seat
        hand: ["A♠️", "10♥️", "J♦️", "3♣️", "Q♠️"],
        team: 1, score: 30, isReady: true
    )
    let otherPlayers = [
        Player(id: "2", name: "أحمد", seat: 2, hand: ["K♠️", "Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️"], team: 2, score: 10, isReady: true),
        Player(id: "3", name: "ليلى", seat: 3, hand: ["A♦️", "7♣️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️"], team: 2, score: 20, isReady: true),
        Player(id: "4", name: "كريم", seat: 0, hand: ["J♠️", "9♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️"], team: 1, score: 15, isReady: true)
    ]
    let played: [String: Card] = [
        "2": Card(suit: .clubs, value: .ten),
        "3": Card(suit: .hearts, value: .king),
        "10": Card(suit: .diamonds, value: .ten),
        "K": Card(suit: .diamonds, value: .king)
    ]
    return TableView(
        currentPlayer: currentPlayer,
        otherPlayers: otherPlayers,
        playedCards: played,
        playCard: { card in print("Played: \(card.toString())") }
    )
}
