//
//  CreatePublicCup.swift
//  Kamelna
//
//  Created by Yasser Yasser on 21/05/2025.
//

import SwiftUI
import FirebaseAuth
import Combine

struct CreatePublicCup: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = CupViewModel()
    
    // State for form inputs
    @State private var cupName: String = ""
    
    @State private var startImmediately: Bool = true
    @State private var startDelay: Date = Date()
    
    @State private var scheduledHours: Int = 0
    @State private var scheduledMinutes: Int = 15
    
    @State private var numberOfTeams: String = "8 فريق/16 عضو"
    @State private var matchType: String = "قهوه واحده"
    @State private var gameType: String = "لعب حر"
    @State private var innerGameTimerSeconds: String = "5 ثوان"
    @State private var minLevelRequired: String = "مبتدئ"
    @State private var firstPlacePrize: String = "100"
    @State private var secondPlacePrize: String = ""
    @State private var thirdPlacePrize: String = ""
    
    private let creatorID: String = "user123" // Replace with actual user ID
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSessionSettingsPopup = false
    @State private var showCupSettingsPopup = false
    
    @StateObject var userViewModel = UserViewModel()
    
    var body: some View {
        ZStack {
            BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 10) {
                        CupNameSection(cupName: $cupName)
                        SettingsSection(
                            showSessionSettingsPopup: $showSessionSettingsPopup,
                            showCupSettingsPopup: $showCupSettingsPopup,
                            startImmediately: $startImmediately,
                            gameType: $gameType,
                            gameTimer: $innerGameTimerSeconds,
                            minimumLevel: $minLevelRequired,
                            teamNumber: $numberOfTeams
                        )
                        PrizeSection(
                            firstPlacePrize: $firstPlacePrize,
                            secondPlacePrize: $secondPlacePrize,
                            thirdPlacePrize: $thirdPlacePrize
                        )
                        //                        Spacer().frame(height: 80) // Space for the button
                    }
                    .padding()
                    .background(SecondaryBackgroundGradient.backgroundGradient)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .environment(\.layoutDirection, .rightToLeft)
                }
                
                
                Button(action: {
                    createCup()
                }) {
                    Text("إنشاء الدوري")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(ButtonBackGroundColor.backgroundGradient)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
            }
            
            popupOverlays
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    dismiss()
                },label: {
                    TextManager.textFormater("عوده")
                })
            }
//            ToolbarItem(placement: .principal) {
//                Text("إنشاء دوري عام")
//                    .font(.headline)
//                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient) // Change this as needed
//            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("خطأ"), message: Text(errorMessage), dismissButton: .default(Text("حسنًا")))
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if let error = newValue {
                errorMessage = error
                showError = true
            }
        }
        .onChange(of: viewModel.isLoading) { _, isLoading in
            if !isLoading && viewModel.errorMessage == nil {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    private var isFormValid: Bool {
        !cupName.isEmpty &&
        !numberOfTeams.isEmpty && Int(numberOfTeams) != nil &&
        !innerGameTimerSeconds.isEmpty && Int(innerGameTimerSeconds) != nil &&
        !minLevelRequired.isEmpty && Int(minLevelRequired) != nil &&
        !firstPlacePrize.isEmpty && Int(firstPlacePrize) != nil
    }
    
    private func createCup() {
        // Mappings
        let teamsMapping: [String: Int] = [
            "8 فريق/16 عضو": 16 ,
            "16 فريق/32 عضو": 32 ,
            "32 فريق/64 عضو": 64
        ]
        
        let timerMapping: [String: Int] = [
            "5 ثوان": 5,
            "10 ثوان": 10,
            "30 ثانية": 30
        ]
        
        let levelMapping: [String: Int] = [
            "مبتدئ": 1,
            "متوسط": 2,
            "متقدم": 3,
            "محترف": 4,
            "خبير": 5,
            "نابغه": 6
        ]
        
        // Parse values
        guard let parsedTeams = teamsMapping[numberOfTeams],
              let parsedTimer = timerMapping[innerGameTimerSeconds],
              let parsedLevel = levelMapping[minLevelRequired],
              let parsedFirstPrize = Int(firstPlacePrize),
              let userName = Auth.auth().currentUser?.displayName ,
        !cupName.isEmpty else {
            errorMessage = "يرجى التأكد من إدخال الحقول بشكل صحيح."
            showError = true
            return
        }
        
        let parsedSecondPrize = Int(secondPlacePrize)
        let parsedThirdPrize = Int(thirdPlacePrize)
        
        let totalDelayMinutes = scheduledHours*60 + scheduledMinutes
        // Construct settings
        let settings = CupSettings(
            startImmediately: startImmediately,
            startDelay: startImmediately ? Calendar.current.date(byAdding: .minute, value: 15, to: Date()) : Calendar.current.date(byAdding: .minute, value: totalDelayMinutes, to: Date()),
            numberOfPlayers: parsedTeams,
            matchType: matchType
        )
        
        let gameSettings = GameSettings(
            gameType: gameType,
            innerGameTimerSeconds: parsedTimer,
            minLevelRequired: parsedLevel
        )
        
        let prize = CupPrize(
            firstPlace: parsedFirstPrize,
            secondPlace: parsedSecondPrize,
            thirdPlace: parsedThirdPrize
        )
        guard let creator = userViewModel.user else {
            print("could't get user data form firestore")
            return
        }
        
        viewModel.createCup(
            name: cupName,
            creator : creator,
            settings: settings,
            gameSettings: gameSettings,
            prize: prize
        )
    }
    
    
    private var mainFormView: some View {
        ScrollView {
            VStack(spacing: 10) {
                CupNameSection(cupName: $cupName)
                SettingsSection(
                    showSessionSettingsPopup: $showSessionSettingsPopup,
                    showCupSettingsPopup: $showCupSettingsPopup,
                    startImmediately: $startImmediately,
                    gameType: $gameType,
                    gameTimer: $innerGameTimerSeconds,
                    minimumLevel: $minLevelRequired,
                    teamNumber: $numberOfTeams
                )
                PrizeSection(
                    firstPlacePrize: $firstPlacePrize,
                    secondPlacePrize: $secondPlacePrize,
                    thirdPlacePrize: $thirdPlacePrize
                )
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(20)
        }
        .padding(.horizontal, 20)
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    @ViewBuilder
    private var popupOverlays: some View {
        if showSessionSettingsPopup {
            PopupOverlay(
                title: "إعدادات الجلسه",
                content: { CupGameSettings(gameType: $gameType, gameTimer: $innerGameTimerSeconds, minimumLevel: $minLevelRequired)
                },
                onDismiss: { showSessionSettingsPopup = false }
            )
        }
        
        if showCupSettingsPopup {
            PopupOverlay(
                title: "إعدادات الدوري",
                content: {
                    SessionSettings(
                        matchType: $matchType,
                        numberOfTeams: $numberOfTeams,
                        cupType: Binding<String>(
                            get: { startImmediately ? "فوري" : "مجدول" },
                            set: { newValue in
                                startImmediately = (newValue == "فوري")
                            }
                        ),
                        scheduledHours: $scheduledHours,
                        scheduledMinutes: $scheduledMinutes
                    )
                },
                onDismiss: { showCupSettingsPopup = false }
            )
        }
        
    }
}

#Preview {
    CreatePublicCup()
}
