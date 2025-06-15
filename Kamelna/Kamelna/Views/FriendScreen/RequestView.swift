//
//  RequestesView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 10/06/2025.
//
import SwiftUI
struct RequestView : View{
    @State private var selectedTab: String = "طلبات الصداقه"
    @ObservedObject var userViewModel : UserViewModel
    let tabs = ["طلبات الصداقه","طلباتى"]
    var body: some View{
        ZStack{
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            
            VStack{
                Text("طلبات")
                HStack {
                    if selectedTab == "طلبات الصداقه" {
                        ReceivedView(userViewModel: userViewModel)
                    } else if selectedTab == "طلباتى" {
                        SentView(userViewModel: userViewModel)
                    }
                }
                .animation(.easeInOut, value: selectedTab)
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        Button {
                            SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                            selectedTab = tab
                        } label: {
                            Text(tab)
                                .font(.callout)
                                .foregroundStyle(Color.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedTab == tab ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient
                                )
                                .cornerRadius(15)
                        }
                    }
                }
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(20)
                
            }
           
        }
    }
}
