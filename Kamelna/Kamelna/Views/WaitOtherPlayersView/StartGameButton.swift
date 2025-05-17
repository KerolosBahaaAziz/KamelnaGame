//
//  StartGameButton.swift
//  Kamelna
//
//  Created by Kerlos on 16/05/2025.
//

import SwiftUI

struct StartGameButton: View {
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            Text("ابدأ اللعب")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? Color.orange : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
        .padding(.horizontal)
    }
}
