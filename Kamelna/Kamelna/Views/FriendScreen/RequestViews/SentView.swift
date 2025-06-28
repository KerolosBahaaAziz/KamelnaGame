//
//  SentView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 10/06/2025.
//
import SwiftUI
struct SentView : View{
    @ObservedObject var userViewModel : UserViewModel
    var body: some View{
        ZStack{
            BackgroundGradient.backgroundGradient.ignoresSafeArea()

                ZStack{
                
                    SecondaryBackgroundGradient.backgroundGradient
                    if !userViewModel.isLoading{
                        if  !userViewModel.sentList.isEmpty {
                            List {
                                ForEach(userViewModel.sentList, id: \.id) { user in
                                    
                                    
                                    HStack{
                                        Button {
                                            userViewModel.cancelSentRequest(email: user.email)	
                                        } label: {
                                            Text("إلغاء")
                                                    .foregroundColor(.red) // Use foregroundColor for solid colors
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(Color.white)
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                            
                                        }

                                       
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
                            Text("ليس هناك دعوات صداقه وارده")
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
