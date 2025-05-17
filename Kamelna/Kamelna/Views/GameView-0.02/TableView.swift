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
        ZStack{
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            VStack {
                // Top Player
                if let top = otherPlayers.first(where: { $0.seat == 0 }) {
                    OtherPlayerView(player: top, cardCount: top.hand.count)
                }
                HStack {
                    // Left Player
                    if let left = otherPlayers.first(where: { $0.seat == 1 }) {
                        OtherPlayerView(player: left, cardCount: left.hand.count)
                            .rotationEffect(.degrees(90))
                            .frame(width: 90)
//                            .padding(.top,250)
                    }
                    
                    Spacer()
                    
                    // Center Played Cards
                    ZStack{
                        LogoView(width: 160,height: 160)
                            .padding(.top,180)
                        VStack {
                            Text("الأوراق الملعوبة")
                                .font(.caption)
                            HStack {
                                ForEach(playedCards.sorted(by: { $0.key < $1.key }), id: \.key) { playerId, card in
                                    VStack {
                                        CardView(card: card)
                                        Text(playerName(for: playerId))
                                            .font(.caption2)
                                    }
                                }
                            }
                        }
                        .padding(.top, -170)
                    }
                    Spacer()
                    
                    // Right Player
                    if let right = otherPlayers.first(where: { $0.seat == 2 }) {
                        OtherPlayerView(player: right, cardCount: right.hand.count)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 90)
//                            .padding(.top,250)
                    }
                }
                
                // Bottom Player (You)
                CurrentPlayerGameView(player: currentPlayer, playCard: playCard)
            }
            .padding([.leading , .trailing])
        }
    }

    private func playerName(for id: String) -> String {
        if currentPlayer.id == id { return currentPlayer.name ?? "no name" }
        return otherPlayers.first(where: { $0.id == id })?.name ?? "?"
    }
}



#Preview {
    let currentPlayer = Player(
        id: "1", name: "ياسر", seat: 3,
        hand: ["A♠️", "10♥️", "J♦️", "3♣️", "Q♠️"],
        team: 1, score: 30, isReady: true
    )
    let otherPlayers = [
        Player(id: "2", name: "أحمد", seat: 0, hand: ["K♠️", "Q♥️"], team: 2, score: 10, isReady: true),
        Player(id: "3", name: "ليلى", seat: 1, hand: ["A♦️", "7♣️"], team: 2, score: 20, isReady: true),
        Player(id: "4", name: "كريم", seat: 2, hand: ["J♠️", "9♥️"], team: 1, score: 15, isReady: true)
    ]
    let played: [String: Card] = [
        "2": Card(suit: .clubs, value: .ten),
        "3": Card(suit: .hearts, value: .king)
    ]
    return TableView(
        currentPlayer: currentPlayer,
        otherPlayers: otherPlayers,
        playedCards: played,
        playCard: { card in print("Played: \(card.toString())") }
    )
}

