//
//  SettingsSection.swift
//  Kamelna
//
//  Created by Yasser Yasser on 23/05/2025.
//

import SwiftUI

struct SettingsSection: View {
    @Binding var showSessionSettingsPopup: Bool
    @Binding var showCupSettingsPopup: Bool
    @Binding var startImmediately : Bool
    
    @Binding var gameType: String
    @Binding var gameTimer: String
    @Binding var minimumLevel: String
    
    @Binding var teamNumber: String
    
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text("إعدادات الجلسه")
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                HStack {
                    Image(gameType == "لعب حر" ? "arrow" : "leftarrow")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image(gameTimer == "5 ثوان" ? "rocket" : gameTimer == "10 ثوان" ? "rabit" : "turtle")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image(systemName: minimumLevelIcon(for: minimumLevel))
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(5)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(20)
                .onTapGesture { showSessionSettingsPopup = true }
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("إعدادات الدوري")
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                HStack {
                    Image(startImmediately == true ? "time" : "schedule")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image(armchairImage(for: teamNumber))
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image("card")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(5)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(20)
                .onTapGesture { showCupSettingsPopup = true }
            }
        }
    }
    private func minimumLevelIcon(for level: String) -> String {
        switch level {
        case "مبتدئ": return "1.circle"
        case "متوسط": return "2.circle"
        case "متقدم": return "3.circle"
        case "محترف": return "4.circle"
        case "خبير": return "5.circle"
        case "نابغه": return "star.fill"
        default: return "questionmark.circle"
        }
    }
    private func armchairImage(for teamNumber: String) -> String {
        switch teamNumber {
        case "8 فريق/16 عضو": return "16"
        case "16 فريق/32 عضو": return "32"
        case "32 فريق/64 عضو": return "64"
        default: return "armchair"
        }
    }
}

#Preview {
    @Previewable @State var show = false
    @Previewable @State var show2 = false
    @Previewable @State var startImmediately = false
    @Previewable @State var gameType = "لعب حر"
    @Previewable @State var gameTimer = "5 ثوان"
    @Previewable @State var minimumLevel = "مبتدئ"
    @Previewable @State var teamNumber: String = "8 فريق/16 عضو"
    
    SettingsSection(showSessionSettingsPopup: $show, showCupSettingsPopup: $show2, startImmediately: $startImmediately ,gameType: $gameType,gameTimer: $gameTimer ,minimumLevel: $minimumLevel, teamNumber: $teamNumber)
}
