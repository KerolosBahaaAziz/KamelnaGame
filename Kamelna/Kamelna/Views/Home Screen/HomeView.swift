//
//  HomeView.swift
//  Kamelna
//
//  Created by Kerlos on 02/05/2025.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @State var roomID : String = ""
    @State var shouldNavigate : Bool = false
    @State var isLoading = false
    @State var showDownloadView = false
    @State private var showProfileDetail = false
    let userId = UserDefaults.standard.string(forKey: "userId")
    @State private var showGameView = false
    @State var createdRoomId: String?
    @State var showProfile = false
    @State var profileViewModel = ProfileViewModel()
       
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Top bar
                HStack {
                    Button {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .font(.title2)
                    }
                    Spacer()
                    LogoView()
                    Spacer()
                    
                    Button {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        showProfile.toggle()
                    } label: {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .font(.title2)
                    }
                    NavigationLink(destination: ProfileView(), isActive: $showProfile) {
                        EmptyView()
                    }
                }
                .padding(.horizontal)
                
                // Profile card
                GeometryReader { geometry in
                    VStack(spacing: 20) {
                        Text("Kerolos Bahaa")
                            .font(.title3.bold())
                        Text("غير مشترك")
                            .font(.caption)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(ButtonBackGroundColor.backgroundGradient)
                            .clipShape(Capsule())
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                showProfileDetail = true
                            }
                            .fullScreenCover(isPresented: $showProfileDetail) {
                                ProfileView()
                            }
                        
                        HStack(spacing: 20) {
                            Spacer()
                            StatView(icon: "heart.fill", value: "0", color: .red)
                            Spacer()
                            StatView(icon: "medal.fill", value: "0", color: .orange)
                            Spacer()
                            StatView(icon: "star.fill", value: "0", color: .yellow)
                            Spacer()
                            StatView(icon: "creditcard.fill", value: "0", color: .green)
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.9)
                    .background(SecondaryBackgroundGradient.backgroundGradient)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
                Spacer()
                
                // Play button
                Button(action: {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                    playBlot()
                }) {
                    Text("العب بلوت")
                        .font(.title3.bold())
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ButtonBackGroundColor.backgroundGradient)
                        .cornerRadius(30)
                        .shadow(color: Color(red: 92/255, green: 59/255, blue: 30/255).opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 50)
                
                // Session buttons
                HStack(spacing: 20) {
                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        print("جلسة صوتية tapped")
                    }) {
                        SessionButton(title: "جلسة صوتية", icon: "mic.fill")
                    }
                    
                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        print("إنشاء جلسة tapped")
                        
                        guard let userId = userId else {
                            print("No user ID found. Please register.")
                            return
                        }
                        showGameView = true
                    }) {
                        SessionButton(title: "إنشاء جلسة", icon: "plus.circle.fill")
                    }

                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        print("لعبة ودية tapped")
                        
                        if let root = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .first?.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                            RewardedAdManager.shared.showAd(from: root) {
                                print("User earned reward — proceed to create session")
                            }
                        }
                    }) {
                        SessionButton(title: "لعبة ودية", icon: "gamecontroller.fill")
                    }
                    
                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        print("قائمة الجلسات tapped")
                    }) {
                        SessionButton(title: "قائمة الجلسات", icon: "list.bullet")
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Kamelna cup
                VStack {
                    Text("كأس كملنا")
                        .font(.headline)
                    Image(systemName: "crown.fill")
                        .resizable()
                        .frame(width: 90, height: 60)
                        .foregroundColor(.yellow)
                }
                .padding()
                .background(SecondaryBackgroundGradient.backgroundGradient)
                .cornerRadius(15)
                .padding(.top)
                
                // Tab Bar
                HStack {
                    TabBarButton(title: "المتجر", icon: "cart.fill")
                    TabBarButton(title: "المجتمع", icon: "person.3.fill")
                    TabBarButton(title: "الرئيسية", icon: "house.fill", isActive: true)
                    TabBarButton(title: "الدوريات", icon: "trophy.fill")
                    TabBarButton(title: "دردشة", icon: "bubble.left.and.bubble.right.fill", badge: 5)
                }
                .padding()
                .background(SecondaryBackgroundGradient.backgroundGradient)
                .cornerRadius(20)
                .shadow(radius: 5)
                NavigationLink(destination: CreateRoomView(), isActive: $showGameView) {
                    EmptyView()
                }
                NavigationLink(destination: GameSceneView(roomId: roomID, playerId: Auth.auth().currentUser?.uid ?? ""), isActive: $shouldNavigate) {
                    EmptyView()
                }
                .hidden()
            }
            .background(BackgroundGradient.backgroundGradient)
            .edgesIgnoringSafeArea(.bottom)
            .fullScreenCover(isPresented: $isLoading) {
                LoadingScreenView()
            }
            .onAppear {
                RewardedAdManager.shared.loadAd()
            }
        }
    }

    func playBlot() {
        if let userId = UserDefaults.standard.string(forKey: "userId"),
           let email = Auth.auth().currentUser?.email {
            
            var firstname: String = ""
            isLoading = true
            
            DataBaseManager.shared.fetchUserInfo(email: email) { firstName, lastName in
                firstname = firstName ?? ""
                print("first name is: \(firstname)")
                
                RoomManager.shared.autoJoinOrCreateRoom(currentUserId: userId,currentUserEmail: profileViewModel.user?.email ?? "", playerName: firstname) { roomId in
                    guard let roomId = roomId else {
                        print("Couldn't create a room ID")
                        isLoading = false
                        return
                    }
                    
                    self.roomID = roomId
                    
                    BotsManager.shared.startBotTimerAfterCreatingRoom(roomId: roomId) {updatedPlayers in
                        DispatchQueue.main.async {
                            isLoading = false
                            shouldNavigate = true
                        }
                        RoomManager.shared.distributeCardsToPlayers(roomId: roomId, players: updatedPlayers) { success in
                            
                            print("Bots added: \(updatedPlayers.count), cards distributed: \(success)")
                        }
                    }
                }
                print("User ID: \(userId)")
            }
        } else {
            print("no user id")
        }
    }
}

#Preview {
    HomeView()
}
