//
//  AnimatedCardView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI

import SwiftUI

struct AnimatedCardView: View {
    let card: Card
    var isPlayed: Bool // New: whether the card has been played
    
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
        .opacity(isPlayed ? 0 : 1) // Fade out if played
        .offset(y: isPlayed ? -100 : 0) // Move up if played
        .animation(.easeInOut(duration: 0.5), value: isPlayed) // Animate change
    }
}


#Preview {
    AnimatedCardView(card: Card(suit: .clubs, value: .ace), isPlayed: true)
}
