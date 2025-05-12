//
//  CardBackView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 02/05/2025.
//

import SwiftUI

struct CardBackView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(LinearGradient(
                gradient: Gradient(colors: [.red, .black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .frame(width: 40, height: 60)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white, lineWidth: 1)
            )
    }
}


#Preview {
    CardBackView()
}
