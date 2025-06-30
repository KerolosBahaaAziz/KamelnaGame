//
//  FriendRowRank.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 25/06/2025.
//
import SwiftUI

struct FriendRowRank: View {
    @State var postion : Int
    @State var rankPoints : Int
    @State var firstName : String
    @State var lastName : String
    @State var profilePictureUrl : String?
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "star.circle.fill")
                    .foregroundStyle(.white)
                    .background(.cyan)
                    .clipShape(Circle())
                Spacer()
                Text("\(rankPoints)")
            }
            .frame(width: 100)
            .background(Color(#colorLiteral(red: 0.67680469, green: 0.5414626345, blue: 0.4466940624, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            Spacer()
            HStack{
                Text("\(firstName) \(lastName)")
                    .font(.subheadline)
                AsyncImageView(url: URL(string:profilePictureUrl ?? ""), placeHolder: "person.fill", errorImage: "photo.artframe.circle.fill")
                  
                
                Text("|")
                    
                Text("\(postion)")
                    .padding(.leading,30)
                
                
            }
        }
    }
}
