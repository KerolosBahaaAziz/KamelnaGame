//
//  ParticipantsView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 30/05/2025.
//

import SwiftUI

struct ParticipantsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let participants: [Participants] = [
        Participants(participantID: "1", name: "Alice", teamNumber: 1),
        Participants(participantID: "2", name: "Bob", teamNumber: 2),
        Participants(participantID: "3", name: "Charlie", teamNumber: 1),
        Participants(participantID: "4", name: "Diana", teamNumber: 2),
        Participants(participantID: "5", name: "Eli", teamNumber: 1),
        Participants(participantID: "6", name: "Fay", teamNumber: 2)
    ]
    let cup : Cup
    var body: some View {
        ZStack{
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            VStack{
                HStack{
                    TextManager.textFormater("نشط الان")
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
                    Text(cup.name)
                }
                .padding()
                .background(SecondaryBackgroundGradient.backgroundGradient)
                .cornerRadius(20)
                VStack{
                    VStack{
                        HStack{
                            Spacer()
                            VStack{
                                Image(CupManager.checkGameType(cup.gameSettings.gameType))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text(cup.gameSettings.gameType)
                            }
                            .padding(.horizontal,4)
                            
                            VStack{
                                Image(CupManager.checkTime(cup.gameSettings.innerGameTimerSeconds))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("سرعه اللعب")
                            }
                            .padding(.horizontal,4)
                            
                            VStack{
                                Image(CupManager.checkNumberOfPlayers(cup.settings.numberOfPlayers))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("عدد المقاعد")
                            }
                            .padding(.horizontal,4)
                            
                            VStack{
                                Image("card")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text(cup.settings.matchType)
                            }
                            .padding(.horizontal,4)
                            
                            Spacer()
                        }
                        HStack{
                            TextManager.textFormater(" عدد المشاركين : \(cup.participants.count)")
                            Spacer()
                            
                            TextManager.textFormater(CupManager.levelMapping(cup.gameSettings.minLevelRequired))
                            Text("مستوى اللعب")
                        }
                        .padding()
                    }
                    .padding()
                    .background(SecondaryBackgroundGradient.backgroundGradient)
                    .cornerRadius(20)
                }
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 24) {
                        ForEach(participants, id: \.participantID) { participant in
                            VStack(spacing: 8) {
                                // Placeholder image
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                // Level (mocked, since `Participants` has no `level` yet)
                                Text("Level \(participant.teamNumber)") // Replace with actual level property
                                    .font(.subheadline)
                                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                
                                // Name
                                Text(participant.name)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(SecondaryBackgroundGradient.backgroundGradient)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
        .navigationTitle("") // Hide default title
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                LogoView(width: 70, height: 70)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    print("Enter")
                },label: {
                    TextManager.textFormater("دخول")
                })
                .disabled(cup.participants.count >= cup.settings.numberOfPlayers)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                },label: {
                    TextManager.textFormater("عوده")
                })
            }
        }
        .navigationBarBackButtonHidden(true)
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
            gameType: "لعب حر",
            innerGameTimerSeconds: 60,
            minLevelRequired: 3
        ),
        prize: CupPrize(
            firstPlace: 1000,
            secondPlace: 500,
            thirdPlace: 250
        )
    )
    ParticipantsView(cup : previewCup)
}
