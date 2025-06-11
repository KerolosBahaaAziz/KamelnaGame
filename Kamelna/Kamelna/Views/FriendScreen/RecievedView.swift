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
            SecondaryBackgroundGradient.backgroundGradient
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(width: UIScreen.main.bounds.width - 50, height:  UIScreen.main.bounds.height - 200)
            if  !userViewModel.recievedList.isEmpty {
                List {
                    ForEach(userViewModel.recievedList, id: \.id) { friend in
                        Text("\(friend.firstName) \(friend.lastName)")
                    }.listRowBackground(Color.clear)
                }.scrollContentBackground(.hidden)
            }else{
                Text("لا يوجد طلبات")
            }
        }
    }
}
