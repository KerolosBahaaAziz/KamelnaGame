//
//  FriendRankView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 25/06/2025.
//
import SwiftUI
struct FriendRankView : View{
    @StateObject var userViewModel : UserViewModel
    var body: some View{
      
            ZStack{
                BackgroundGradient.backgroundGradient.ignoresSafeArea()
                ZStack{
                
                    SecondaryBackgroundGradient.backgroundGradient
                    if !userViewModel.isLoading{
                        if  !userViewModel.friendList.isEmpty {
                            List {
                                ForEach(userViewModel.friendList, id: \.id) { user in
                                    
                                    FriendRowRank(rankPoints: user.rankPoints, firstName: user.firstName, lastName: user.lastName, profilePictureUrl: user.profilePictureUrl)
                                    
                                }.listRowBackground(Color.clear)
                            }.scrollContentBackground(.hidden)
                        }else{
                            Text("لا يوجد لديك اصدقاء")
                        }
                    }else{
                        VStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(1.5)
                                Text("جارى التحميل ...")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            
                    }
                   
                    
                }.clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: UIScreen.main.bounds.width - 50, height:  UIScreen.main.bounds.height - 200  )
            }
        
        
       
    }
    
}
