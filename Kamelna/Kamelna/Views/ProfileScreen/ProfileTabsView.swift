//
//  ProfileTabsView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//

import SwiftUI

struct ProfileTabsView: View {
    let tabs: [String]
    @Binding var selectedTab: String

    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Button {
                    SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                    selectedTab = tab
                } label: {
                    Text(tab)
                        .font(.callout)
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedTab == tab ?
                                SelectedButtonBackGroundColor.backgroundGradient :
                                UnSelectedButtonBackGroundColor.backgroundGradient
                        )
                        .cornerRadius(15)
                }
            }
        }
        .background(ButtonBackGroundColor.backgroundGradient)
        .cornerRadius(20)
    }
}
