//
//  GameView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI

struct GameView: View {
    @StateObject private var gameEngine = GameEngine()
    @State private var playedCardID: UUID? = nil // New: track the played card
    
    
    var body: some View {
        VStack {
            Text("Current Player: \(gameEngine.players.isEmpty ? "" : gameEngine.players[gameEngine.currentPlayerIndex].name)")
                .font(.title)
                .padding()

            VStack {
                Text("Table")
                    .font(.headline)
                HStack {
                    ForEach(gameEngine.tableCards) { playedCard in
                        VStack {
                            CardView(card: playedCard.card)
                            Text(playedCard.playerName)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()

            Divider()
                .padding()

            if !gameEngine.players.isEmpty {
                VStack {
                    Text("Your Hand")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(gameEngine.players[gameEngine.currentPlayerIndex].hand) { card in
                                AnimatedCardView(card: card, isPlayed: playedCardID == card.id)
                                    .onTapGesture {
                                        withAnimation {
                                            playedCardID = card.id // Animate this card
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            gameEngine.playCard(card)
                                            playedCardID = nil // Reset after play
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }

            Spacer()
            
            if gameEngine.roundEnded {
                Button("Start New Round") {
                    gameEngine.resetRound()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .onAppear {
            gameEngine.setupGame(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
        }
        .padding()
    }
}

#Preview {
    GameView()
}
