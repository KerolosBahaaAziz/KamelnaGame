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
                            Label("Friends", systemImage: "person.3")
                        }

                    FriendRankView(userViewModel: userViewModel)
                        .tabItem {
                            Label("Ranking", systemImage: "star.circle")
                        }

                    EmptyView()
                        .tabItem {
                            Label("Account", systemImage: "person.badge.plus")
                        }
                }
            }
        }
        
       
    }
    
}
