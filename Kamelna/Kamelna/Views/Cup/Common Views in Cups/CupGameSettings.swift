//
//  CupGameSettings.swift
//  Kamelna
//
//  Created by Yasser Yasser on 24/05/2025.
//

import SwiftUI

import SwiftUI

struct CupGameSettings: View {
    @Binding var gameType: String
    @Binding var gameTimer: String
    @Binding var minimumLevel: String
    
    private let gameTypeImages: [String] = ["arrow", "leftarrow"]
    private let gameTypeSettings: [String] = ["لعب حر", "لعب محدود"]
    private let gameTimerSettings: [String] = ["5 ثوان", "10 ثوان", "30 ثانية"]
    private let gameTimerImages : [String] = ["rocket" , "rabit" , "turtle"]
    private let minimumLevelSettings: [String] = ["مبتدئ", "متوسط", "متقدم", "محترف", "خبير", "نابغه"]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Game Type Picker
            VStack(alignment: .leading, spacing: 10) {
                Text("نوع اللعب")
                    .padding(.horizontal)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                CustomHorizontalSegmentedPicker(selected: $gameType, options: [("لعب حر", "arrow"), ("لعب محدود", "leftarrow")])
            }
            
            Text("اللعب الحر يمكنك من القطع و التقييد")
                .padding(.horizontal)
                .font(.caption)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            // Game Timer Picker
            VStack(alignment: .leading, spacing: 10) {
                Text("مدة اللعب")
                    .padding(.horizontal)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                CustomHorizontalSegmentedPicker(
                    selected: $gameTimer,
                    options: Array(zip(gameTimerSettings, gameTimerImages))
                )
            }
            
            // Minimum Level Picker
            VStack(alignment: .leading, spacing: 10) {
                Text("المستوى الأدنى")
                    .padding(.horizontal)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                Picker("المستوى الأدنى", selection: $minimumLevel) {
                    ForEach(minimumLevelSettings, id: \.self) { setting in
                        Text(setting).tag(setting)
                    }
                }
                .pickerStyle(.segmented)
                .tint(ButtonBackGroundColor.backgroundGradient)
                .background(UnSelectedButtonBackGroundColor.backgroundGradient)
            }
        }
        .padding(.horizontal)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    @Previewable @State var gameType: String = "لعب حر"
    @Previewable @State var gameTimer: String = "15"
    @Previewable @State var minimumLevel: String = "مبتدئ"
    CupGameSettings(gameType: $gameType, gameTimer: $gameTimer, minimumLevel: $minimumLevel)
}
