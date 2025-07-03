//
//  MainCupView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 20/05/2025.
//

import SwiftUI

struct MainCupView: View {
    @State private var selectedTab = 2
    

    var body: some View {
        NavigationView{
            ZStack{
                BackgroundGradient.backgroundGradient.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Custom Tab Bar
                    HStack(spacing: 0){
                        Button(action :{
                            
                        }){
                            Text("مساعدة")
                                .padding(5)
                                .padding(.horizontal , 10)
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .background(ButtonBackGroundColor.backgroundGradient)
                                .cornerRadius(20)
                        }
                        
                        Spacer()
                        
                        Text("الدوريات")
                            .font(.title)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        
                        Spacer()
                        
                        Button(action :{
                            
                        }){
                            Text("عودة")
                                .padding(5)
                                .padding(.horizontal , 10)
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .background(ButtonBackGroundColor.backgroundGradient)
                                .cornerRadius(20)
                        }
                        
                    }
                    .padding()
                    HStack(spacing: 0) {
                        iconButtonView(iconName: "PrivateCup", label: "دوريات خاصه", tabIndex: 0)
                        iconButtonView(iconName: "GameCup", label: "دوريات اربعة", tabIndex: 1)
                        iconButtonView(iconName: "PublicCup", label: "دوريات عامه", tabIndex: 2)
                    }
                    .padding()
                    .background(ButtonBackGroundColor.backgroundGradient)
                    .cornerRadius(20)
                    
                    
                    // Content View
                    Group {
                        switch selectedTab {
                        case 0:
                            PrivateCup()
                                .padding()
                        case 1:
                            Text("Content for Tab 2")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.green.opacity(0.1))
                        case 2:
                            PublicCup()
                                .padding()
                        default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer()
                }
            }
        }
    }
    
    func iconButtonView(iconName: String, label: String, tabIndex: Int) -> some View {
        let isSelected = selectedTab == tabIndex

        return Button(action: {
            selectedTab = tabIndex
            SoundManager.shared.playSound(named: "ButtonPressed.mp3")
        }) {
            VStack(spacing: 4) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(isSelected ? Color.white : Color.black)

                Text(label)
                    .font(.callout)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundStyle(Color.black)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(isSelected ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient)
            .cornerRadius(12)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    MainCupView()
}
