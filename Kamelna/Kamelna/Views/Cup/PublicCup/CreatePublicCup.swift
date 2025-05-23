//
//  CreatePublicCup.swift
//  Kamelna
//
//  Created by Yasser Yasser on 21/05/2025.
//

import SwiftUI

struct CreatePublicCup: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = CupViewModel()
    
    // State for form inputs
    @State private var cupName: String = ""
    
    @State private var startImmediately: Bool = true
    @State private var startDelay: Date = Date()

    @State private var scheduledMinutes: Int = 15
    @State private var scheduledSeconds: Int = 0

    @State private var numberOfTeams: String = "8 فريق/16 عضو"
    @State private var matchType: String = "قهوه واحده"
    @State private var gameType: String = "Trivia"
    @State private var innerGameTimerSeconds: String = "30"
    @State private var minLevelRequired: String = "1"
    @State private var firstPlacePrize: String = "100"
    @State private var secondPlacePrize: String = ""
    @State private var thirdPlacePrize: String = ""
    
    private let creatorID: String = "user123" // Replace with actual user ID
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSessionSettingsPopup = false
    @State private var showCupSettingsPopup = false
    
    private let gameTypeOptions = ["Trivia", "Quiz", "Puzzle"]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                
                mainFormView
                
                popupOverlays
            }
            .navigationTitle("إنشاء دوري عام")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("إنشاء") { createCup() }
                        .disabled(!isFormValid)
                }
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
        }
    }
    
    
    private var isFormValid: Bool {
        !cupName.isEmpty &&
        !numberOfTeams.isEmpty && Int(numberOfTeams) != nil &&
        !innerGameTimerSeconds.isEmpty && Int(innerGameTimerSeconds) != nil &&
        !minLevelRequired.isEmpty && Int(minLevelRequired) != nil &&
        !firstPlacePrize.isEmpty && Int(firstPlacePrize) != nil
    }
    
    private func createCup() {
        guard let numberOfTeams = Int(numberOfTeams),
              let innerGameTimerSeconds = Int(innerGameTimerSeconds),
              let minLevelRequired = Int(minLevelRequired),
              let firstPlacePrize = Int(firstPlacePrize) else {
            errorMessage = "يرجى التأكد من أن جميع الحقول الرقمية تحتوي على أرقام صحيحة."
            showError = true
            return
        }
        
        let settings = CupSettings(
            startImmediately: startImmediately,
            startDelay: startImmediately ? nil : startDelay,
            numberOfTeams: numberOfTeams,
            matchType: matchType
        )
        
        let gameSettings = GameSettings(
            gameType: gameType,
            innerGameTimerSeconds: innerGameTimerSeconds,
            minLevelRequired: minLevelRequired
        )
        
        let prize = CupPrize(
            firstPlace: firstPlacePrize,
            secondPlace: secondPlacePrize.isEmpty ? nil : Int(secondPlacePrize),
            thirdPlace: thirdPlacePrize.isEmpty ? nil : Int(thirdPlacePrize)
        )
        
        viewModel.createCup(
            name: cupName,
            settings: settings,
            gameSettings: gameSettings,
            prize: prize,
            creatorID: creatorID
        )
    }
    
    private var mainFormView: some View {
        ScrollView {
            VStack(spacing: 10) {
                CupNameSection(cupName: $cupName)
                SettingsSection(
                    showSessionSettingsPopup: $showSessionSettingsPopup,
                    showCupSettingsPopup: $showCupSettingsPopup, startImmediately: $startImmediately
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
                content: { Text("محتوى إعدادات الجلسه (يحتاج إلى تنفيذ)") },
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
                        scheduledMinutes: $scheduledMinutes,
                        scheduledSeconds: $scheduledSeconds
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
