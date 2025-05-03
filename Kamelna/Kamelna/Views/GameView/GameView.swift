//
//  GameView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

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
                        .position(x: geometry.size.width / 2, y: 120)
                }
                
                // Left Player (Player 2)
                if let player = gameEngine.players[safe: 1] {
                    PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 1)
                        .rotationEffect(.degrees(-90))
                        .position(x: 50, y: geometry.size.height / 2.5)
                }
                
                // Right Player (Player 3)
                if let player = gameEngine.players[safe: 2] {
                    PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 2)
                        .rotationEffect(.degrees(90))
                        .position(x: geometry.size.width - 50, y: geometry.size.height / 2.5)
                }
                
                // Bottom Player (Player 4 - You)
                if let player = gameEngine.players[safe: 3] {
                    VStack {
                        Text("Your Hand")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        let columns = [GridItem(.adaptive(minimum: 50), spacing: 0)]
                        
                        LazyVGrid(columns: columns, spacing: 10) {
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
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 130)
                    
                }
                
                // Center Table Cards
                // Instead of using .position, just let the VStack/ZStack lay them out
                VStack(spacing: 10) {
                    //                    Text("Current Player: \(gameEngine.players[safe: gameEngine.currentPlayerIndex]?.name ?? "")")
                    //                        .font(.subheadline)
                    //                        .foregroundColor(.white)
                    //
                    //                    Text("Time Left: \(gameEngine.timeRemaning)s")
                    //                        .font(.subheadline)
                    //                        .foregroundColor(gameEngine.timeRemaning <= 3 ? .red : .white)
                    
                    ZStack {
                        if let card = gameEngine.cardPlayedByPlayer(index: 0) {
                            CardView(card: card)
                                .offset(y: -160)
                        }
                        
                        if let card = gameEngine.cardPlayedByPlayer(index: 1) {
                            CardView(card: card)
                                .rotationEffect(.degrees(-90))
                                .offset(x: -100)
                        }
                        
                        if let card = gameEngine.cardPlayedByPlayer(index: 2) {
                            CardView(card: card)
                                .rotationEffect(.degrees(90))
                                .offset(x: 100)
                        }
                        
                        if let card = gameEngine.cardPlayedByPlayer(index: 3) {
                            CardView(card: card)
                                .offset(y: 50)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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
