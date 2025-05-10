//
//  TabBarButton.swift
//  Kamelna
//
//  Created by Yasser Yasser on 09/05/2025.
//

import SwiftUI

struct TabBarButton: View {
    let title: String
    let icon: String
    var isActive: Bool = false
    var badge: Int? = nil
    
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isActive ? BackgroundGradient.backgroundGradient : ButtonForeGroundColor.backgroundGradient)
                if let badge, badge > 0 {
                    Text("\(badge)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
            Text(title)
                .font(.caption2)
                .foregroundStyle(isActive ? BackgroundGradient.backgroundGradient : ButtonForeGroundColor.backgroundGradient)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    TabBarButton(title: "title", icon: "")
}
