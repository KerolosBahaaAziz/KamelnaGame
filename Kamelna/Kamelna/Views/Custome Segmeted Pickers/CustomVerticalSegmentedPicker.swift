//
//  CustomVerticalSegmentedPicker.swift
//  Kamelna
//
//  Created by Yasser Yasser on 24/05/2025.
//

import SwiftUI

struct CustomVerticalSegmentedPicker: View {
    @Binding var selected: String
    let options: [(text: String, image: String)]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.text) { option in
                Button(action: {
                    selected = option.text
                }) {
                    VStack {
                        Text(option.text)
                        Image(option.image)
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .frame(maxWidth : .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(selected == option.text ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.gray.opacity(0.3), lineWidth: selected == option.text ? 0 : 1)
                    )
                }
            }
        }
        .padding(5)
        .background(ButtonBackGroundColor.backgroundGradient)
        .cornerRadius(20)
    }
}

#Preview {
    @Previewable @State var selectedOption = "Option 1"
    CustomVerticalSegmentedPicker(selected: $selectedOption, options: [("لعب حر", "arrow"), ("لعب محدود", "leftarrow")])
}
