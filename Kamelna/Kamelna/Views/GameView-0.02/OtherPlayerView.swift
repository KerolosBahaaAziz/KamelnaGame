//
//  OtherPlayerView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 12/05/2025.
//

import SwiftUI

struct OtherPlayerView: View {
    let player: Player
    let cardCount: Int
    let seatPosition: PlayerSeatPosition
    @ObservedObject var profileViewModel : ProfileViewModel
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // Arc of cards based on position
                ForEach(0..<cardCount, id: \.self) { index in
                    let radius: CGFloat = 60
                    let (startAngle, endAngle) = angleRange(for: seatPosition)
                    let angleStep = (endAngle - startAngle) / Double(max(cardCount - 1, 1))
                    let angle = startAngle + angleStep * Double(index)

                    let radians = Angle(degrees: angle).radians
                    let x = radius * CGFloat(cos(radians))
                    let y = radius * CGFloat(sin(radians))

                    Image("card_back")
                        .resizable()
                        .frame(width: 40, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .rotationEffect(.degrees(angle + 90))
                        .offset(x: x, y: y)
                        .shadow(radius: 2)
                }

                // Avatar in center
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .zIndex(1)
            }

            Text(player.name ?? "الاسم غير معروف")
                .font(.headline)

            let playerTeam = player.team ?? 0
            let playerScore = player.score ?? 0
            Button {
                profileViewModel.updateFriendList(email: player.)
            } label: {
                
            }

            Text("فريق: \(playerTeam) | نقاط: \(playerScore)")
                .font(.caption)
                .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    // MARK: - Angle range depending on seat
    private func angleRange(for position: PlayerSeatPosition) -> (Double, Double) {
        switch position {
        case .top:
            return (-135, -45) // Arc above the avatar
        case .left:
            return (0, -90) // Arc to the left
        case .right:
            return (180, 270) // Arc to the right
        }
    }
}





#Preview {
    OtherPlayerView(
        player: Player(
            id: "2",
            name: "أحمد",
            seat: 1,
            hand: Array(repeating: "K", count: 9), // not used directly
            team: 2,
            score: 10,
            isReady: true
        ),
        cardCount: 5, seatPosition: .top
    )
}
