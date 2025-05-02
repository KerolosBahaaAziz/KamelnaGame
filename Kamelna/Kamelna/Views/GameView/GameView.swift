//
//  GameView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI

import SwiftUI

struct GameView: View {
    @StateObject private var gameEngine = GameEngine()
    @State private var playedCardID: UUID? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.green.opacity(0.4).edgesIgnoringSafeArea(.all)

                // Top Player (Player 1)
                if let player = gameEngine.players[safe: 0] {
                    PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 0)
                        .position(x: geometry.size.width / 2, y: 60)
                }

                // Left Player (Player 2)
                if let player = gameEngine.players[safe: 1] {
                    PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 1)
                        .rotationEffect(.degrees(-90))
                        .position(x: 60, y: geometry.size.height / 2)
                }

                // Right Player (Player 3)
                if let player = gameEngine.players[safe: 2] {
                    PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 2)
                        .rotationEffect(.degrees(90))
                        .position(x: geometry.size.width - 60, y: geometry.size.height / 2)
                }

                // Bottom Player (Player 4 - You)
                if let player = gameEngine.players[safe: 3] {
                    VStack {
                        Text("Your Hand")
                            .font(.headline)
                            .foregroundColor(.white)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(player.hand) { card in
                                    AnimatedCardView(card: card, isPlayed: playedCardID == card.id)
                                        .onTapGesture {
                                            withAnimation {
                                                playedCardID = card.id
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                gameEngine.playCard(card)
                                                playedCardID = nil
                                            }
                                        }
                                }
                            }
                            .padding(.bottom)
                        }
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 100)
                }

                // Center Table Cards
                VStack(spacing: 10) {
                    Text("Current Player: \(gameEngine.players[safe: gameEngine.currentPlayerIndex]?.name ?? "")")
                        .font(.title3)
                        .foregroundColor(.white)

                    Text("Time Left: \(gameEngine.timeRemaning)s")
                        .font(.subheadline)
                        .foregroundColor(gameEngine.timeRemaning <= 3 ? .red : .white)

                    HStack(spacing: 15) {
                        ForEach(gameEngine.tableCards) { playedCard in
                            VStack(spacing: 4) {
                                CardView(card: playedCard.card)
                                Text(playedCard.playerName)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .onAppear {
                gameEngine.setupGame(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
            }
            .onChange(of: gameEngine.roundEnded) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    gameEngine.resetRound()
                }
            }
        }
    }
}

#Preview {
    GameView()
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
