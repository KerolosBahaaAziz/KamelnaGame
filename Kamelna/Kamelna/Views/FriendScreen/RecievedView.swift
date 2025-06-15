//
//  RecievedView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 10/06/2025.
//
import SwiftUI

struct ReceivedView : View{
    @ObservedObject var userViewModel : UserViewModel
    var body: some View{
        ZStack{
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            ZStack{
            
                SecondaryBackgroundGradient.backgroundGradient
                if !userViewModel.isLoading{
                    if  !userViewModel.recievedList.isEmpty {
                        List {
                            ForEach(userViewModel.recievedList, id: \.id) { user in
                                
                                
                                HStack{
                                    Button {
                                        userViewModel.acceptFriendRequest(email: user.email)
                                    } label: {
                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 24, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .frame(width: 30, height: 30)
                                                            .background(Color.green)
                                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    }.buttonStyle(.borderless)
                                    Button {
                                        userViewModel.cancelFriendRequest(email: user.email)
                                    } label: {
                                        Image(systemName: "xmark")
                                                            .font(.system(size: 24, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .frame(width: 30, height: 30)
                                                            .background(Color.red)
                                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                                                    
                                    }.buttonStyle(.borderless)

                                   
                                    Spacer()
                                    HStack{
                                        Text("\(user.firstName) \(user.lastName)")
                                            .font(.subheadline)
                                        AsyncImageView(url: URL(string:user.profilePictureUrl ?? ""), placeHolder: "person.fill", errorImage: "photo.artframe.circle.fill")
                                            .padding(.leading,5)
                                            
                                        

                                        

                                    }
                                }
                                
                            }.listRowBackground(Color.clear)
                        }.scrollContentBackground(.hidden)
                    }else{
                        Text("لا يوجد طلبات")
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
