//
//  JoinPublicCupView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 26/05/2025.
//

import SwiftUI

struct JoinPublicCupView: View {
    
    @State var cup: Cup
    @ObservedObject var cupViewModel = CupViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Top Labels
            HStack {
                textFormater("الجائزه")
                Spacer()
                textFormater(cup.name)
                Spacer()
                textFormater("الخصائص")
            }

            // Middle Section with 3 equal parts
            HStack {
                // Left: Prize
                // Left: Prize
                VStack(spacing: 8) {
                    Image("winnertrophy")
                        .resizable()
                        .frame(width: 80, height: 80)

                    Text("\(cup.prize.firstPlace) نقطة")
                        .font(.headline)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                }
                .frame(maxWidth: .infinity)
                .offset(x : -20)


                // Center: Creator Avatar
                VStack(spacing: 0) {
                    ZStack {
//                        LogoView(width: 100, height: 100)
                        VStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            Text(cup.creatorName)
                                .font(.title)
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .offset(y: -5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                // Right: Properties
                VStack {
                    HStack {
                        Image(checkGameType(cup.gameSettings.gameType))
                            .resizable()
                            .frame(width: 40, height: 40)
                        Image(checkTime(cup.gameSettings.innerGameTimerSeconds))
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    HStack {
                        Image(checkNumberOfPlayers(cup.settings.numberOfPlayers))
                            .resizable()
                            .frame(width: 40, height: 40)
                        Image("card")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .frame(maxWidth: .infinity)
            }

            // Bottom Buttons
            HStack {
                textFormater("شارك")
                Spacer()
                textFormater("نشط الآن")
                Spacer()
                Button(action: {
                    print("join the cup")
                }) {
                    textFormater("دخول")
                }
            }
        }
        .padding()
        .background(SecondaryBackgroundGradient.backgroundGradient)
        .cornerRadius(15)
        .shadow(radius: 5)
        .environment(\.layoutDirection, .rightToLeft)
    }

    
    private func textFormater(_ text : String) -> some View {
        Text("\(text)")
            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            .padding(5)
            .background(ButtonBackGroundColor.backgroundGradient)
            .cornerRadius(10)
    }
    
    private func checkTime(_ time : Int) -> String{
        if time == 5 {
            return "rocket"
        }else if time == 10 {
            return "rabit"
        } else {
            return "turtle"
        }
    }
    
    private func checkGameType(_ type : String) ->String{
        if type == "لعب حر"{
            return "arrow"
        } else {
            return "leftarrow"
        }
    }
    private func checkNumberOfPlayers(_ number : Int) ->String{
        if number == 16 {
            return "16"
        } else if number == 32{
            return "32"
        } else {
            return "64"
        }
    }
    private func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    let previewCup = Cup(
        name: "كأس رمضان",
        creatorName: "ياسر يوسف",
        settings: CupSettings(
            startImmediately: false,
            startDelay: Date().addingTimeInterval(3600),
            numberOfPlayers: 16,
            matchType: "قهوة واحدة"
        ),
        gameSettings: GameSettings(
            gameType: "كوتشينة",
            innerGameTimerSeconds: 60,
            minLevelRequired: 3
        ),
        prize: CupPrize(
            firstPlace: 1000,
            secondPlace: 500,
            thirdPlace: 250
        ),
        createdAt: Date(),
        creatorID: "user_123"
    )
    
    JoinPublicCupView(cup: previewCup)
}
