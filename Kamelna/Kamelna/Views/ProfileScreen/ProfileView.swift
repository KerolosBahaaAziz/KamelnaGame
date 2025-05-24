//
//  ProfileView.swift
//  Kamelna
//
//  Created by Kerlos on 03/05/2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var selectedTab: String = "نبذة"
    @State private var bioText: String = ""
    @State private var showPhotoPicker = false
    @State private var showBioEditor = false
    @State private var tempBioText: String = ""
    @State private var selectedRankingCardTab : String = "daily"
    @State private var selectedRankingArranging : String = "arranging"
    @State private var awardsSelectedTab = "الجوائز"
    @ObservedObject var profileViewModel = ProfileViewModel()
    let awardsTabs = ["الجوائز", "الإنجازات", "الألقاب"]
    
    
    let tabs = ["نبذة", "التصنيف", "الجوائز"]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            ProfileHeaderView(profileViewModel: profileViewModel)
            // Tabs
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
            //            .padding(5)
            //            .padding(.horizontal)
            .background(ButtonBackGroundColor.backgroundGradient)
            .cornerRadius(20)
            
            
            // Dynamic Content
            HStack {
                if selectedTab == "نبذة" {
                    BioCardView(profileViewModel: profileViewModel, showBioEditor: $showBioEditor, tempBioText: $tempBioText)
                } else if selectedTab == "التصنيف" {
                    RankingCardView(profileViewModel: profileViewModel, selectedRankingCardTab: $selectedRankingCardTab, selectedRankingArranging: $selectedRankingArranging)
                } else if selectedTab == "الجوائز" {
                    AwardsCardView(selectedTab: $awardsSelectedTab)
                }
            }
            .animation(.easeInOut, value: selectedTab)
            
            Text("لقد انضممت إلى كملنا بتاريخ \(profileViewModel.user?.creationDate ?? "")")
                .font(.footnote)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            
            Spacer()
            
        }
        .background(BackgroundGradient.backgroundGradient)
        //        .padding(.top)
        .environment(\.layoutDirection, .rightToLeft)
        .sheet(isPresented: $showBioEditor) {
            BioEditorSheet(tempBioText: $tempBioText, showBioEditor: $showBioEditor, profileViewModel: profileViewModel)
        }
        
    }
    
}


