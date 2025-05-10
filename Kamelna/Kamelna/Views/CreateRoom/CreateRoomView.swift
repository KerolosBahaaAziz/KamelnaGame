//
//  CreateSessionView.swift
//  Kamelna
//
//  Created by Kerlos on 03/05/2025.
//

import SwiftUI

struct CreateRoomView: View {
    @State private var sessionName: String = ""
    @State private var gameSpeed: Int = 0 // 0: Infinite, 1: 30s, 2: 10s, 3: 5s
    @State private var minLevel: String = "مبتدئ"

    var body: some View {
        ZStack {
//            Color(red: 248/255, green: 241/255, blue: 221/255)
//                .ignoresSafeArea()

            BackgroundGradient.backgroundGradient
            VStack(spacing: 16) {
                // Header
                LogoView()
                HStack {
                    Text("إنشاء جلسة")
                        .font(.title2).bold()
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    Spacer()
                    Text("0")
                        .padding(6)
                        .background(SecondaryBackgroundGradient.backgroundGradient)
                        .cornerRadius(8)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                }
                .padding()
                .background(SecondaryBackgroundGradient.backgroundGradient)

                VStack(alignment: .trailing, spacing: 20) {
                    // Session name
                    VStack(alignment: .trailing, spacing: 9) {
                        Text("اسم الجلسة")
                            .foregroundColor(.brown)
                        HStack {
                            Image(systemName: "lock.open")
                                .foregroundColor(.gray)
                            TextField("اسم الجلسة", text: $sessionName)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 1)
                    }

                    // Game speed
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("سرعة اللعب")
                            .foregroundColor(.brown)
                        HStack(spacing: 12) {
                            ForEach(0..<4) { index in
                                VStack {
                                    Text(speedLabel(for: index))
                                    Image(systemName: speedIcon(for: index))
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                                .padding(6)
                                .frame(maxWidth: .infinity)
                                .background(gameSpeed == index ?
                                            SelectedButtonBackGroundColor.backgroundGradient : // Selected
                                            UnSelectedButtonBackGroundColor.backgroundGradient // Default
                                )
                                .cornerRadius(10)
                                .onTapGesture {
                                    SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                                    gameSpeed = index
                                }
                            }
                        }
                    }
                    // Background
                    VStack(alignment: .trailing) {
                        Text("خلفيات الجلسة")
                            .foregroundColor(.brown)
                        Image("carpet")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(10)
                            .overlay(Text("كملت")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(BackgroundGradient.backgroundGradient)
                                .cornerRadius(6), alignment: .bottom)
                    }
                }
                .padding()
                .background(SecondaryBackgroundGradient.backgroundGradient)
                .cornerRadius(20)
                .shadow(radius: 5)
                Spacer()

                Button(action: {
                    // Create session
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                }) {
                    HStack {
                        Image(systemName: "diamond.fill")
                        Text("إنشاء الجلسة")
                    }
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ButtonBackGroundColor.backgroundGradient)
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(BackgroundGradient.backgroundGradient)
        }
        .environment( \.layoutDirection, .rightToLeft)
    }

    func speedLabel(for index: Int) -> String {
        switch index {
        case 0: return "لا نهائي"
        case 1: return "30 ث"
        case 2: return "10 ث"
        case 3: return "5 ثوان"
        default: return ""
        }
    }

    func speedIcon(for index: Int) -> String {
        switch index {
        case 0: return "infinity"
        case 1: return "tortoise"
        case 2: return "hare"
        case 3: return "paperplane"
        default: return "circle"
        }
    }
}

#Preview {
    CreateRoomView()
}

extension Color {
    static let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
}
