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
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

#Preview {
    CardView(card: Card(suit: .clubs, value: .Jack))
}
