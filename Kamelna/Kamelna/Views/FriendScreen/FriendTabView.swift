//
//  FriendTabView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 25/06/2025.
//
import SwiftUI

struct FriendTabView : View{
    @StateObject var userViewModel = UserViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showRequest = false
 
    var body: some View{
        NavigationView{
        ZStack{
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            VStack{
                HStack{
                    Button {
                        showRequest.toggle()
                    } label: {
                        Text("طلبات")
                    }.padding(10)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .background(ButtonBackGroundColor.backgroundGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Text("الاصدقاء")
                        .font(.title)
                        .foregroundStyle(.black)
                        .padding(.leading,50)
                        .padding(.trailing, 50)
                    Button {
                        dismiss()
                    } label: {
                        Text("عوده")
                    }.padding(10)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .background(ButtonBackGroundColor.backgroundGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    NavigationLink(destination: RequestView(userViewModel: userViewModel), isActive: $showRequest) {
                        EmptyView()
                    }
                    
                }.padding(.bottom,20)
                    .frame(alignment: .top)
                TabView {
                    FriendView(userViewModel: userViewModel)
                        .tabItem {
                            Label("اصدقاء", systemImage: "person.3")
                        }

                    FriendRankView(userViewModel: userViewModel)
                        .tabItem {
                            Label("المتصدرون", systemImage: "star.circle")
                        }

                    FriendAddView(userViewModel: userViewModel)
                        .tabItem {
                            Label("اضافات", systemImage: "person.badge.plus")
                        }
                }
                .tint(SelectedButtonBackGroundColor.backgroundGradient)
                .onAppear {
                    UITabBar.appearance().unselectedItemTintColor = UIColor(red: 62/255, green: 31/255, blue: 12/255, alpha: 1)
                }
            }
                
            }
        }
        
        .ignoresSafeArea(.keyboard)
    }
    
}
