//
//  PlayersListView.swift
//  Kamelna
//
//  Created by Kerlos on 16/05/2025.
//

import SwiftUI

struct PlayersListView: View {
    var players: [Player] 

    var body: some View {
        VStack(alignment: .leading) {
            Text("Waiting for Players...")
                .font(.headline)
                .foregroundColor(.brown)
            
            ForEach(players) { player in
                HStack {
                    Text( "👑 \(player.name ?? "الاسم غير معروف")")
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.purple)
                }
                .padding()
                .background(Color.yellow.opacity(0.7))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(SecondaryBackgroundGradient.backgroundGradient)
        .cornerRadius(12)
    }
}
