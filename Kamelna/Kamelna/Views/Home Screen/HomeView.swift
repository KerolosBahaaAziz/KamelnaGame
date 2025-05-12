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
    
    var body: some View {
        NavigationStack{
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
                        } label: {
                            Image(systemName: "person.2.fill")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
//                    .padding(.top , 20)
                    
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
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                            
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
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // center
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
                        }) {
                            SessionButton(title: "إنشاء جلسة", icon: "plus.circle.fill")
                        }
                        
                        Button(action: {
                            SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                            print("لعبة ودية tapped")
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
                    
//                    Spacer()
                    
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
                }
                .background(BackgroundGradient.backgroundGradient)
                .edgesIgnoringSafeArea(.bottom)
                
                if isLoading {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                        Text("جاري تحميل الغرفة...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                
            NavigationLink(destination: EmptyView(), isActive: $shouldNavigate) {
                    //                EmptyView()
//                    GameView(roomId: $roomID)
                }.hidden()
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
                
                RoomManager.shared.autoJoinOrCreateRoom(currentUserId: userId, playerName: firstname) { roomId in
                    guard let roomId = roomId else {
                        print("Couldn't create a room ID")
                        isLoading = false
                        return
                    }
                    
                    self.roomID = roomId
                    
                    BotsManager.shared.startBotTimerAfterCreatingRoom(roomId: roomId) {
                        DispatchQueue.main.async {
                            isLoading = false
                            shouldNavigate = true
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

