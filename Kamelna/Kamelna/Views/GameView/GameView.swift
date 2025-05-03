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
    @Binding var roomId : String
    @State private var showChat = false // Added state for chat navigation

    var body: some View {
        GeometryReader { geometry in
            NavigationStack{
                ZStack {
                    Color.green.opacity(0.4).edgesIgnoringSafeArea(.all)
                    // Player info at the top
                    VStack(spacing: 8) {
                        Text("Current Player: \(gameEngine.players[safe: gameEngine.currentPlayerIndex]?.name ?? "")")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Time Left: \(gameEngine.timeRemaning)s")
                            .font(.subheadline)
                            .foregroundColor(gameEngine.timeRemaning <= 3 ? .red : .white)
                        
                        Spacer()
                    }
                    .padding(.top, 95)
                    
                    // Player avatars positioned around the table
                    // Top Player (Player 1)
                    if let player = gameEngine.players[safe: 0] {
                        PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 0)
                            .position(x: geometry.size.width / 2, y: 200)
                    }
                    
                    // Left Player (Player 2)
                    if let player = gameEngine.players[safe: 1] {
                        PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 1)
                            .rotationEffect(.degrees(-90))
                            .position(x: 45, y: geometry.size.height / 2)
                    }
                    
                    // Right Player (Player 3)
                    if let player = gameEngine.players[safe: 2] {
                        PlayerAvatarView(player: player, isCurrent: gameEngine.currentPlayerIndex == 2)
                            .rotationEffect(.degrees(90))
                            .position(x: geometry.size.width - 45, y: geometry.size.height / 2)
                    }
                    
                    // Center Table Cards with animations
                    ZStack {
                        // Positions for each player's card (N, W, E, S)
                        if let card = gameEngine.cardPlayedByPlayer(index: 0) {
                            CardView(card: card)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                                .offset(y: -70) // North position
                        }
                        
                        if let card = gameEngine.cardPlayedByPlayer(index: 1) {
                            CardView(card: card)
                                .rotationEffect(.degrees(-90))
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                                .offset(x: -45) // West position
                        }
                        
                        if let card = gameEngine.cardPlayedByPlayer(index: 2) {
                            CardView(card: card)
                                .rotationEffect(.degrees(90))
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                                .offset(x: 45) // East position
                        }
                        
                        if let card = gameEngine.cardPlayedByPlayer(index: 3) {
                            CardView(card: card)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .bottom).combined(with: .opacity)
                                ))
                                .offset(y: 70) // South position
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
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
                            
                            NavigationLink(destination: RoomChatView(roomId: $roomId), isActive: $showChat) {
                                Button("Chat") {
                                    showChat = true
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 130)
                    }
                }
                .onAppear {
                    gameEngine.setupGame(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
                }
                .onChange(of: gameEngine.roundEnded) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            gameEngine.resetRound()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var roomId = ""
    GameView(roomId: $roomId)
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
