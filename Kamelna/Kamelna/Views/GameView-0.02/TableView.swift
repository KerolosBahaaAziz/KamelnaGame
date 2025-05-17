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
    let currentTurnPlayerId: String

    var body: some View {
        GeometryReader { geo in
            ZStack {
                BackgroundGradient.backgroundGradient.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top Player
                    playerViewAt(seatOffset: 2)
                        .frame(height: geo.size.height * 0.08)
                        .padding(.top, geo.safeAreaInsets.top) // Respect safe area insets

                    Spacer()

                    HStack {
                        // Left Player
                        playerViewAt(seatOffset: 1)
                            .frame(width: geo.size.width * 0.2)

                        Spacer()

                        // Center Table
                        ZStack {
                            LogoView(width: geo.size.width * 0.25, height: geo.size.width * 0.25)

                            ForEach(playedCards.sorted(by: { $0.key < $1.key }), id: \.key) { playerId, card in
                                if let seat = seatForPlayerId(playerId) {
                                    let offset = cardOffset(for: seat, in: geo.size)
                                    let angle = angleForSeat(seat)
                                    CardView(card: card)
                                        .rotationEffect(.degrees(angle))
                                        .offset(offset)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.3)
                        .offset(y: geo.size.height * 0.05) // 👈 Push cards down

                        Spacer()

                        // Right Player
                        playerViewAt(seatOffset: 3)
                            .frame(width: geo.size.width * 0.2)
                    }

                    Spacer()

                    // Current Player
                    CurrentPlayerGameView(player: currentPlayer, playCard: playCard)
                }
                .padding(.top, 20)
            }
        }
    }

    // MARK: - Reusable Components

    private func playerViewAt(seatOffset: Int) -> some View {
        Group {
            if let player = playerForRelativeSeat(seatOffset) {
                let relativeSeat = (player.seat! - (currentPlayer.seat ?? 0) + 4) % 4
                let position: PlayerSeatPosition = {
                    switch relativeSeat {
                    case 1: return .left
                    case 2: return .top
                    case 3: return .right
                    default: return .top
                    }
                }()
                OtherPlayerView(player: player, cardCount: player.hand.count, seatPosition: position)
                    .frame(maxWidth: .infinity)
            } else {
                Spacer().frame(maxWidth: .infinity)
            }
        }
    }


    private func playerForRelativeSeat(_ relativeSeat: Int) -> Player? {
        let absoluteSeat = ((currentPlayer.seat ?? 0) + relativeSeat) % 4
        return otherPlayers.first(where: { $0.seat == absoluteSeat })
    }

    private func playerName(for id: String) -> String {
        if currentPlayer.id == id { return currentPlayer.name ?? "Me" }
        return otherPlayers.first(where: { $0.id == id })?.name ?? "?"
    }

    private func seatForPlayerId(_ playerId: String) -> Int? {
        if playerId == currentPlayer.id { return currentPlayer.seat }
        return otherPlayers.first(where: { $0.id == playerId })?.seat
    }

    private func cardOffset(for seat: Int, in size: CGSize) -> CGSize {
        let relativeSeat = (seat - (currentPlayer.seat ?? 0) + 4) % 4
        let offsetValue: CGFloat = size.width * 0.15

        switch relativeSeat {
        case 0: return CGSize(width: 0, height: offsetValue)   // Bottom
        case 1: return CGSize(width: -offsetValue, height: 0)  // Left
        case 2: return CGSize(width: 0, height: -offsetValue)  // Top
        case 3: return CGSize(width: offsetValue, height: 0)   // Right
        default: return .zero
        }
    }

    private func angleForSeat(_ seat: Int) -> Double {
        let relativeSeat = (seat - (currentPlayer.seat ?? 0) + 4) % 4
        switch relativeSeat {
        case 0: return 0    // Bottom
        case 1: return -90  // Left
        case 2: return 180  // Top
        case 3: return 90   // Right
        default: return 0
        }
    }
}


#Preview {
    let currentPlayer = Player(
        id: "1", name: "ياسر", seat: 0, // Changed to test a different seat
        hand: ["A♠️", "10♥️", "J♦️", "3♣️", "Q♠️"],
        team: 1, score: 30, isReady: true
    )
    let otherPlayers = [
        Player(id: "2", name: "أحمد", seat: 1, hand: ["K♠️", "Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️"], team: 2, score: 10, isReady: true),
        Player(id: "3", name: "ليلى", seat: 2, hand: ["A♦️", "7♣️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️"], team: 2, score: 20, isReady: true),
        Player(id: "4", name: "كريم", seat: 3, hand: ["J♠️", "9♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️","Q♥️"], team: 1, score: 15, isReady: true)
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
        playCard: { card in print("Played: \(card.toString())") },
        currentTurnPlayerId: "2" // 👈 simulate it's Ahmed's turn
    )
}
