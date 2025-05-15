//
//  CardView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        VStack {
            Text(card.value.rawValue)
                .font(.largeTitle)
            Text(card.suit.rawValue)
                .font(.title)
        }
        .frame(width: 60, height: 90)
        .background(SecondaryBackgroundGradient.backgroundGradient)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

#Preview {
    CardView(card: Card(suit: .clubs, value: .jack))
}

struct PlayerInfoBadge: View {
    let name: String
    let number: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("لاعب \(number)")
                .font(.caption)
                .bold()
            Text(name)
                .font(.footnote)
        }
        .padding(8)
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(12)
        .foregroundColor(.white)
        .shadow(radius: 3)
    }
}

struct StackedCardBacks: View {
    let count: Int

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                CardBackView()
                    .offset(y: CGFloat(i) * 10) // Stack vertically
            }
        }
    }
}
