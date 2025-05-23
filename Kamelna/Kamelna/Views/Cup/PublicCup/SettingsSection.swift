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
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text("إعدادات الجلسه")
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                HStack {
                    Image("PublicCup")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image("PrivateCup")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image("GameCup")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(5)
                .background(.white)
                .cornerRadius(20)
                .onTapGesture { showSessionSettingsPopup = true }
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("إعدادات الدوري")
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                HStack {
                    if startImmediately {
                        Image("time")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }else {
                        Image("schedule")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    Image("armchair")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image("card")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(5)
                .background(.white)
                .cornerRadius(20)
                .onTapGesture { showCupSettingsPopup = true }
            }
        }
    }
}

#Preview {
    @Previewable @State var show = false
    @Previewable @State var show2 = false
    @Previewable @State var startImmediately = false

    SettingsSection(showSessionSettingsPopup: $show, showCupSettingsPopup: $show2, startImmediately: $startImmediately)
}
