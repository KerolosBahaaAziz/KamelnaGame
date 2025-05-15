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
        VStack {
            Text(player.name)
                .font(.headline)

            HStack(spacing: -12) {
                ForEach(0..<cardCount, id: \.self) { _ in
                    Image("card_back")
                        .resizable()
                        .frame(width: 40, height: 60)
                        .shadow(radius: 2)
                }
            }

            Text("فريق: \(player.team) | نقاط: \(player.score)")
                .font(.caption)
                .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                .lineLimit(1)
        }
    }
}



#Preview {
    OtherPlayerView(
        player: Player(
            id: "2",
            name: "أحمد",
            seat: 1,
            hand: Array(repeating: "?", count: 5), // not used directly
            team: 2,
            score: 10,
            isReady: true
        ),
        cardCount: 5
    )
}
