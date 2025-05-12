//
//  SessionButton.swift
//  Kamelna
//
//  Created by Yasser Yasser on 09/05/2025.
//

import SwiftUI

struct SessionButton: View {
    let title: String
    let icon: String
    var action : () -> Void = { }
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
            Text(title)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
        }
        .frame(width: 70)
    }
}
#Preview {
    SessionButton(title: "hello", icon: "")
}
