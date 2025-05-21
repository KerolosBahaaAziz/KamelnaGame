//
//  MainCardView.swift
//  Kamelna
//
//  Created by Kerlos on 16/05/2025.
//

import SwiftUI

struct MainCardView: View {
    @State private var didCopy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(" 😎")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("By Kerlos")
                .foregroundColor(.purple)
                .fontWeight(.semibold)

        
            Text("👻👻👻")
                .font(.body)

            VStack(spacing: 8) {
                Text("SHARE CODE")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    Button(action: {
                        let roomId = UserDefaults.standard.string(forKey: "roomId") ?? "Failed to create room!"
                        UIPasteboard.general.string = roomId
                        didCopy = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            didCopy = false
                        }
                    }) {
                        Image(systemName: didCopy ? "checkmark.circle.fill" : "square.on.square")
                            .foregroundColor(didCopy ? .green : .primary)
                            .font(.title2)
                    }

                    Text(UserDefaults.standard.string(forKey: "roomId") ?? "Failed to create room!")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.purple, lineWidth: 2))
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
