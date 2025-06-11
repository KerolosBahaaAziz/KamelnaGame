//
//  BioCardView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//

import SwiftUI

struct BioCardView: View {
    @ObservedObject var profileViewModel: UserViewModel
    @Binding var showBioEditor: Bool
    @Binding var tempBioText: String

    var body: some View {
        VStack {
            if let bioText = profileViewModel.user?.brief {
                if tempBioText.isEmpty {
                    Button("اضغط هنا لإضافة نبذة عامة") {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        tempBioText = ""
                        showBioEditor = true
                    }
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                } else {
                    VStack(spacing: 8) {
                        Button {
                            SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                            tempBioText = bioText
                            showBioEditor = true
                        } label: {
                            Text(tempBioText)
                                .multilineTextAlignment(.trailing)
                                .padding()
                                .foregroundStyle(.black)
                            
                        }
                        
                        
                    }
                }
            }
       
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SecondaryBackgroundGradient.backgroundGradient)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
