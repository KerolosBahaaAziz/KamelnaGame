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

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // Arc of cards above the avatar
                ForEach(0..<cardCount, id: \.self) { index in
                    let angle = Double(index - cardCount / 2) * 12
                    Image("card_back")
                        .resizable()
                        .frame(width: 40, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .rotationEffect(.degrees(angle))
                        .offset(x: CGFloat(angle) * 1.2, y: -abs(CGFloat(angle)) * 0.6)
                        .shadow(radius: 2)
                }
                .offset(y : -10)
                
                // Avatar
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .zIndex(1)
            }

            Text(player.name)
                .font(.headline)

            Text("فريق: \(player.team) | نقاط: \(player.score)")
                .font(.caption)
                .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                .lineLimit(1)
        }
        .padding(.top , 30)
    }
}




#Preview {
    OtherPlayerView(
        player: Player(
            id: "2",
            name: "أحمد",
            seat: 1,
            hand: Array(repeating: "K", count: 5), // not used directly
            team: 2,
            score: 10,
            isReady: true
        ),
        cardCount: 5
    )
}
