//
//  HeaderView.swift
//  Kamelna
//
//  Created by Kerlos on 16/05/2025.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.white)
            }
            Spacer()
            Text("Party Time!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    HeaderView()
}
