//
//  ParticipantsView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 30/05/2025.
//

import SwiftUI
import FirebaseFirestore

struct ParticipantsView: View {
    
    @Environment(\.dismiss) private var dismiss
    //
    //    let participants: [Participants] = [
    //        Participants(participantID: "1", name: "Alice", teamNumber: 1 , level: 2, image : ""),
    //        Participants(participantID: "2", name: "Bob", teamNumber: 2 , level: 2, image : ""),
    //        Participants(participantID: "3", name: "Charlie", teamNumber: 1  , level: 2, image : ""),
    //        Participants(participantID: "4", name: "Diana", teamNumber: 2  , level: 2, image : ""),
    //        Participants(participantID: "5", name: "Eli", teamNumber: 1  , level: 2, image : ""),
    //        Participants(participantID: "6", name: "Fay", teamNumber: 2  , level: 2, image : "")
    //    ]
    @StateObject var userViewModel = UserViewModel()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @StateObject private var cupViewModel = CupViewModel() // Add CupViewModel
    @State var cup: Cup
    var body: some View {
        ZStack{
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            if userViewModel.isUserLoaded {
                VStack{
                    HStack{
                        TextManager.textFormater("نشط الان")
                        Spacer()
                        VStack(spacing: 0) {
                            AsyncImage(url: URL(string: cup.creator.profilePictureUrl ?? "")) { image in image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            Text(cup.creator.firstName)
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
                            ForEach(cup.participants, id: \.participantID) { participant in
                                VStack(spacing: 8) {
                                    // Placeholder image
                                    AsyncImage(url: URL(string: participant.image)) { image in image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                    }
                                    
                                    // Level (mocked, since `Participants` has no `level` yet)
                                    Text("Level \(participant.level)") // Replace with actual level property
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
                    if let user = userViewModel.user, cup.participants.contains(where: { $0.participantID == user.id }) {
                        Button(action: {
                            leaveCup()
                        },label: {
                            TextManager.textFormater("مغادرة")
                        })
                    }
                }
                .padding()
            }else {
                ProgressView("جاري تحميل البيانات...")
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            }
        }
        .navigationTitle("") // Hide default title
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                LogoView(width: 70, height: 70)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    joinCup()
                },label: {
                    TextManager.textFormater("دخول")
                })
                .disabled(isJoinButtonDisabled)
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
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            userViewModel.setUser() // Ensure user data is fetched
            listenForCupUpdates()
        }
    }
    
    private var isJoinButtonDisabled: Bool {
        if !userViewModel.isUserLoaded {
            print("User Data not yet loaded")
            return true // still loading
        }
        
        guard let user = userViewModel.user else {
            print("couldn't fetch user data")
            return true // still nil after loading
        }
        
        return cup.participants.count >= cup.settings.numberOfPlayers ||
        cup.participants.contains { $0.participantID == user.id }
        //        ||
        //        user.rankPoints < cup.gameSettings.minLevelRequired
    }
    
    private func joinCup() {
        guard userViewModel.isUserLoaded else {
            errorMessage = "User data is still loading"
            showErrorAlert = true
            return
        }
        guard let user = userViewModel.user, let userId = user.id else {
            errorMessage = "User not logged in"
            showErrorAlert = true
            return
        }
        guard cup.participants.count < cup.settings.numberOfPlayers else {
            errorMessage = "Cannot join: Cup is full"
            showErrorAlert = true
            return
        }
        guard !cup.participants.contains(where: { $0.participantID == userId }) else {
            errorMessage = "Cannot join: You are already a participant"
            showErrorAlert = true
            return
        }
        //        guard user.rankPoints >= cup.gameSettings.minLevelRequired else {
        //            errorMessage = "Cannot join: Insufficient rank points"
        //            showErrorAlert = true
        //            return
        //        }
        
        let newParticipant = Participants(
            participantID: userId,
            name: user.firstName,
            teamNumber: assigneTeamNumber(),
            level: user.rankPoints,
            image: user.profilePictureUrl ?? ""
        )
        
        let db = Firestore.firestore()
        guard let cupId = cup.id else {
            errorMessage = "Error: Invalid cup ID"
            showErrorAlert = true
            return
        }
        // Atomic update using arrayUnion
        do {
            try db.collection("Public_Cups").document(cupId).updateData([
                "participants": FieldValue.arrayUnion([try Firestore.Encoder().encode(newParticipant)])
            ]) { error in
                if let error = error {
                    print("Error updating cup data: \(error.localizedDescription)")
                    self.errorMessage = "فشل في تحديث بيانات الكأس: \(error.localizedDescription)"
                    self.showErrorAlert = true
                } else {
                    print("Successfully joined cup")
                }
            }
        } catch {
            print("Error encoding participant: \(error.localizedDescription)")
            errorMessage = "خطأ في تشفير المشارك: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
    
    private func leaveCup() {
        guard userViewModel.isUserLoaded, let user = userViewModel.user, let userId = user.id else {
            errorMessage = "User not loaded"
            showErrorAlert = true
            return
        }
        
        let participant = Participants(
            participantID: userId,
            name: user.firstName,
            teamNumber: cup.participants.first(where: { $0.participantID == userId })?.teamNumber ?? 0,
            level: user.rankPoints,
            image: user.profilePictureUrl ?? ""
        )
        cupViewModel.leaveCup(cupID: cup.id ?? "" ,participant: participant)
    }
    
    private func assigneTeamNumber() ->Int {
        return cup.participants.count / 2
    }
    
    private func listenForCupUpdates() {
        guard let cupId = cup.id else {
            errorMessage = "خطأ: معرف الكأس غير صالح"
            showErrorAlert = true
            return
        }
        Firestore.firestore().collection("Public_Cups").document(cupId)
            .addSnapshotListener { document, error in
                if let error = error {
                    print("Error listening for cup updates: \(error.localizedDescription)")
                    self.errorMessage = "خطأ في متابعة التحديثات: \(error.localizedDescription)"
                    self.showErrorAlert = true
                    return
                }
                if let document = document, let updatedCup = try? document.data(as: Cup.self) {
                    self.cup = updatedCup
                }
            }
    }
}

#Preview {
    let previewCup = Cup(
        name: "كأس رمضان",
        creator: User(
            firstName: "Yasser",
            lastName: "Yasser",
            email: "yasser@example.com",
            profilePictureUrl: nil,
            creationDate: "2025-05-30",
            id: "user123"
        ),
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
