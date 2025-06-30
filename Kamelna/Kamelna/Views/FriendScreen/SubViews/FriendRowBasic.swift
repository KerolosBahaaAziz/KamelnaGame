//
//  FriendRowBasic.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 25/06/2025.
//

//
//  FriendRowRank.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 25/06/2025.
//
import SwiftUI

struct FriendRowBasic: View {
    @ObservedObject var userViewModel : UserViewModel
    @State var user : User
    var body: some View {
   
            HStack{
                Button {
                    userViewModel.unFriendUser(email: user.email)
                } label: {
                    Image(systemName: "trash")
                        .padding()
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
        
        
    }
}
