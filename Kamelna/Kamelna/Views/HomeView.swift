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
                    Button { } label: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                    Spacer()
                    Button { } label: {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Profile card
                VStack(spacing: 20) {
                    Text("Kerolos Bahaa")
                        .font(.title3.bold())
                    Text("غير مشترك")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Capsule())
                    
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 20) {
                        StatView(icon: "heart.fill", value: "0", color: .red)
                        StatView(icon: "medal.fill", value: "0", color: .orange)
                        StatView(icon: "star.fill", value: "0", color: .yellow)
                        StatView(icon: "creditcard.fill", value: "0", color: .green)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Spacer()
                
                // Play button
                Button(action: {
                    playBlot()
                }) {
                    Text("العب بلوت")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(30)
                        .shadow(color: .green.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 50)
                
                // Session buttons
                HStack(spacing: 20) {
                    Button(action: {
                        print("جلسة صوتية tapped")
                    }) {
                        SessionButton(title: "جلسة صوتية", icon: "mic.fill")
                    }
                    
                    Button(action: {
                        print("إنشاء جلسة tapped")
                    }) {
                        SessionButton(title: "إنشاء جلسة", icon: "plus.circle.fill")
                    }
                    
                    Button(action: {
                        print("لعبة ودية tapped")
                    }) {
                        SessionButton(title: "لعبة ودية", icon: "gamecontroller.fill")
                    }
                    
                    Button(action: {
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
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(15)
                .padding(.top)
                
                Spacer()
                
                // Tab Bar
                HStack {
                    TabBarButton(title: "المتجر", icon: "cart.fill")
                    TabBarButton(title: "المجتمع", icon: "person.3.fill")
                    TabBarButton(title: "الرئيسية", icon: "house.fill", isActive: true)
                    TabBarButton(title: "الدوريات", icon: "trophy.fill")
                    TabBarButton(title: "دردشة", icon: "bubble.left.and.bubble.right.fill", badge: 5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            .background(Color(.systemGroupedBackground))
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
            
            NavigationLink(destination: GameView(roomId: $roomID), isActive: $shouldNavigate) {
//                EmptyView()
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

struct StatView: View {
    let icon: String
    let value: String
    let color: Color

    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(.caption)
        }
    }
}

struct SessionButton: View {
    let title: String
    let icon: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 70)
    }
}

struct TabBarButton: View {
    let title: String
    let icon: String
    var isActive: Bool = false
    var badge: Int? = nil

    var body: some View {
        VStack {
            ZStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isActive ? .blue : .gray)
                if let badge, badge > 0 {
                    Text("\(badge)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
            Text(title)
                .font(.caption2)
                .foregroundColor(isActive ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}

