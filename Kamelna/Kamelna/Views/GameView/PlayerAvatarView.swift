//
//  PlayerAvatarView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 02/05/2025.
//
/*
import SwiftUI

struct PlayerAvatarView: View {
    let player: Player
    let isCurrent: Bool

    var body: some View {
        VStack {
            Text(player.name)
                .font(.caption)
                .foregroundColor(isCurrent ? .yellow : .white)
            
            HStack {
                ForEach(player.hand.prefix(3)) { _ in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray)
                        .frame(width: 25, height: 40)
                }
            }
        }
        .padding(8)
        .background(.black.opacity(0.3))
        .cornerRadius(10)
    }
}


#Preview {
    PlayerAvatarView(player: Player(name: "Youssab", hand: []), isCurrent: true)
}
*/
