//
//  RankingCardView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//

import SwiftUI

struct RankingCardView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var selectedRankingCardTab: String
    @Binding var selectedRankingArranging: String

    var body: some View {
        VStack(spacing: 16) {
            // Top Tab
            HStack(spacing: 8) {
                ForEach(["arranging", "performace"], id: \.self) { tab in
                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                        selectedRankingArranging = tab
                    }) {
                        Text(tab == "arranging" ? "الترتيب" : "الأداء")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(tab == selectedRankingArranging ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)

            // Rank Details
            VStack(spacing: 20) {
                Text(" \(profileViewModel.user?.rank ?? "مبتدئ") مستواك الحالي  ")
                    .font(.headline)
                    .padding()

                ZStack {
                    Circle()
                        .stroke(SecondaryBackgroundGradient.backgroundGradient, lineWidth: 10)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(BackgroundGradient.backgroundGradient, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 120, height: 120)

                    Text(String(profileViewModel.user?.rankPoints ?? 0))
                        .font(.title)
                        .bold()
                }

                Text("لا توجد تصنيفات متاحة حالياً.")

                // Bottom Tab
                HStack(spacing: 8) {
                    ForEach(["daily", "weekly"], id: \.self) { tab in
                        Button(action: {
                            SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                            selectedRankingCardTab = tab
                        }) {
                            Text(tab == "daily" ? "يوميًا" : "أسبوعيًا")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(tab == selectedRankingCardTab ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient)
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
}
