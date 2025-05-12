//
//  test2.swift
//  Kamelna
//
//  Created by Kerlos on 07/05/2025.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @State private var animatedCard: Card?
    @State private var animateCard = false

    var body: some View {
        ZStack {
            VStack {
                // Top Bar
                HStack {
                    Spacer()
                    Text("جلسة \(viewModel.roomId.prefix(4))")
                    Spacer()
                    HStack {
                        Button("المزيد") {}
                        Button("الصوت") {}
                        Button("مشاركة") {}
                        Button("تعابير") {}
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))

                // Top Player (Dealer)
                VStack {
                    Text("متوسط")
                    ForEach(0..<5) { _ in
                        CardBackView()
                            .rotationEffect(.degrees(90)) // horizontal
                    }
                    Text("لاعب 1")
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.yellow))
                    Text("الموزع")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // Middle Section: Left Player - Ground Cards - Right Player
                HStack {
                    VStack {
                        ForEach(0..<5) { _ in
                            CardBackView()
                                .rotationEffect(.degrees(90)) // horizontal
                        }
                        Text("لاعب A")
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.3)))
                    }

                    Spacer()

                    // Ground Cards (all played cards)
                    HStack {
                        ForEach(viewModel.playedCards) { card in
                            CardView(card: card)
                                .transition(.scale)
                        }
                    }
                    .frame(height: 100)

                    Spacer()

                    VStack {
                        ForEach(0..<5) { _ in
                            CardBackView()
                                .rotationEffect(.degrees(90)) // horizontal
                        }
                        Text("لاعب B")
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.3)))
                    }
                }
                .padding()

                // Bottom Hand (You)
                VStack {
                    Text("أنت")
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue.opacity(0.3)))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.hand) { card in
                                Button(action: {
                                    animatedCard = card
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        animateCard = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        viewModel.playCard(card: card)
                                        animateCard = false
                                        animatedCard = nil
                                    }
                                }) {
                                    CardView(card: card)
                                }
                                .disabled(!viewModel.isMyTurn)
                                .opacity(viewModel.isMyTurn ? 1.0 : 0.5)
                            }
                        }
                    }

                    HStack {
                        Button("صن") {}
                        Button("حكم") {}
                        Button("بس") {}
                    }
                    .padding()
                }
            }
            .padding()

            // Animated Card Swipe
            if animateCard, let card = animatedCard {
                CardView(card: card)
                    .frame(width: 80, height: 120)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
    }
}
