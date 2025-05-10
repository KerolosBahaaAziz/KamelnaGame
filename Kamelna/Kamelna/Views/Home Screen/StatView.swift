//
//  StatView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 09/05/2025.
//

import SwiftUI

struct StatView: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(.caption)
        }
    }
}

#Preview {
    StatView(icon: "", value: "", color: .blue)
}
