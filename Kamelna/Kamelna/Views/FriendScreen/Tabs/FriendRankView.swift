//
//  FriendRankView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 25/06/2025.
//
import SwiftUI
struct FriendRankView : View{
    @ObservedObject var userViewModel : UserViewModel
    @State var postion = 0
    var body: some View{
      
            ZStack{
                BackgroundGradient.backgroundGradient.ignoresSafeArea()
                ZStack{
                
                    SecondaryBackgroundGradient.backgroundGradient
                    if !userViewModel.isLoading{
                        if  !userViewModel.friendList.isEmpty {
                            VStack{
                                HStack{
                                    Text("النقاط")
                                    Spacer()
                                    Text("الاسم")
                                        .padding(.trailing,5)
                                    Text("|")
                                    Text("الترتيب")
                                    
                                }.font(.subheadline)
                                .padding()

                                ScrollView{
                                    ForEach(Array(userViewModel.sortFriendsByRank().enumerated()), id: \.offset) { index, user in
                                        FriendRowRank(
                                            postion: index,
                                            rankPoints: user.rankPoints,
                                            firstName: user.firstName,
                                            lastName: user.lastName,
                                            profilePictureUrl: user.profilePictureUrl
                                        )
                                    }.listRowBackground(Color.clear)
                                    
                                    Spacer()
                                }.padding()
                            }
                         
                             
                            
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
                    .frame(width: UIScreen.main.bounds.width - 20, height:  UIScreen.main.bounds.height - 220  )
            }
        
        
       
    }
    
}
