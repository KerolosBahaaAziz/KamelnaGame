//
//  BioEditorSheet.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//


import SwiftUI

struct BioEditorSheet: View {
    @Binding var tempBioText: String
    @Binding var showBioEditor: Bool
    @ObservedObject var profileViewModel: UserViewModel
    var body: some View {
        ZStack {
            BackgroundGradient.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("تعديل النبذة")
                    .font(.title2.bold())
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)

                ScrollView {
                    TextEditor(text: $tempBioText)
                        .frame(height: 150)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .foregroundColor(.black)
                }

                HStack {
                    Button("إلغاء") {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        showBioEditor = false
                    }
                    .font(.headline)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .padding()
                    .background(ButtonBackGroundColor.backgroundGradient)
                    .cornerRadius(12)

                    Spacer()

                    Button("حفظ") {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        showBioEditor = false
                        // TODO: Save bioText back to ViewModel or persistence
                        profileViewModel.updateBreif(brief: tempBioText)
                    }
                    .font(.headline)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .padding()
                    .background(ButtonBackGroundColor.backgroundGradient)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}
