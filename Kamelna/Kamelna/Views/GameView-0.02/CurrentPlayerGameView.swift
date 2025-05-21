//
//  CurrentPlayerGameView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 12/05/2025.
//

import SwiftUI

struct CurrentPlayerGameView: View {
    var player: Player
    let playCard: (Card) -> Void
    
    var cards: [Card] {
        player.hand.compactMap { Card.from(string: $0) }
    }
    
    var body: some View {
        VStack {
            let playerName = player.name ?? "unknown"
            let playerTeam = player.team ?? 0
            let playerScore = player.score ?? 0
            
            Text("فريق: \(playerTeam) | النقاط: \(playerScore)")
                .font(.subheadline)
                .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
            
//            Spacer()
            
            Text("يدك")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(cards) { card in
                        Button(action: {
                            playCard(card)
                        }) {
                            CardView(card: card)
                                .padding(4)
                        }
                    }
                }
//                .padding()
            }
            BottomButtonsView(userName:playerName, status: "جديد")
        }
        .padding([.leading, .trailing])
    }
}

#Preview {
    CurrentPlayerGameView(player: Player(
        id: "1",
        name: "ياسر",
        seat: 0,
        hand: ["A♠️", "10♥️", "J♦️", "3♣️", "Q♠️"],
        team: 1,
        score: 30,
        isReady: true
    ), playCard: { card in
        print("Played card: \(card.toString())")
    }
    )
}
