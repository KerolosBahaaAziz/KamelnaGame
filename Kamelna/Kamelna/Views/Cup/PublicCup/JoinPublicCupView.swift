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
    @State private var navigateToParticipants = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Level requirement text on top
            HStack{
                Text("الحد الأدنى للمستوى: \(CupManager.levelMapping(cup.gameSettings.minLevelRequired))")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.top, 10)
                    .padding(.horizontal ,15)
                Spacer()
                Text("عدد المشاركين: \(cup.participants.count)")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.top, 10)
                    .padding(.horizontal ,15)
            }
            
            // Main content
            VStack(alignment: .center, spacing: 20) {
                // Top Labels
                HStack {
                    TextManager.textFormater("الجائزه")
                    Spacer()
                    TextManager.textFormater(cup.name)
                    Spacer()
                    TextManager.textFormater("الخصائص")
                }
                
                // Middle Section
                HStack {
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
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        Text(cup.creatorName.split(separator: " ").first?.description ?? cup.creatorName)
                            .font(.headline)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .offset(y: -5)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Image(CupManager.checkGameType(cup.gameSettings.gameType))
                                .resizable()
                                .frame(width: 40, height: 40)
                            Image(CupManager.checkTime(cup.gameSettings.innerGameTimerSeconds))
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        HStack {
                            Image(CupManager.checkNumberOfPlayers(cup.settings.numberOfPlayers))
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
                    TextManager.textFormater("شارك")
                    Spacer()
                    TextManager.textFormater("نشط الآن")
                    Spacer()
                    Button(action: {
                        print("join the cup")
                        navigateToParticipants = true
                    }) {
                        TextManager.textFormater("دخول")
                    }
                    NavigationLink(destination: ParticipantsView(cup: cup), isActive: $navigateToParticipants) {
                        EmptyView()
                    }
                    
                }
            }
            .padding()
        }
        .background(
            SecondaryBackgroundGradient.backgroundGradient
        )
        .cornerRadius(15)
        //        .overlay(
        //            RoundedRectangle(cornerRadius: 15)
        //                .stroke(Color.gray, lineWidth: 8)
        //        )
        .shadow(radius: 5)
        //        .padding()
        .environment(\.layoutDirection, .rightToLeft)
    }
}


#Preview {
    let previewCup = Cup(
        name: "كأس رمضان",
        creatorID: "user_123",
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
        )
    )
    
    JoinPublicCupView(cup: previewCup)
}
