//
//  AwardsCardView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//

import SwiftUI

struct AwardsCardView: View {
    @Binding var selectedTab: String
    let awardsTabs = ["الجوائز", "الإنجازات", "الألقاب"]

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(awardsTabs, id: \.self) { tab in
                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                        selectedTab = tab
                    }) {
                        Text(tab)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(tab == selectedTab ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient)
                            )
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    }
                }
            }
            .padding(.horizontal)

            VStack(spacing: 16) {
                ZStack {
                    Image("cupBoard")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.3)

                    Text("خزانة الجوائز فارغة")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .padding(.horizontal)
                }

                Text("لم تحصل على أي جوائز بعد.")
                    .font(.footnote)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
}
