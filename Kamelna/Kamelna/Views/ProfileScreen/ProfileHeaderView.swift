//
//  ProfileHeaderView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var selectedImageData: Data?
    @Binding var showPhotoOptions: Bool
    @Binding var showPhotoPicker: Bool

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button("تعديل") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                }.padding(5)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .background(ButtonBackGroundColor.backgroundGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                
                Spacer()
                
                Text("الملف الشخصي")
                    .font(.title3.bold())
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            
                Spacer()
                
                Button("عودة") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                }
                .padding(5)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .background(ButtonBackGroundColor.backgroundGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
               
            }
            .padding(.horizontal)
            
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "plus")
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    )
                
                Spacer()
                
                Button {
                    showPhotoOptions = true
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        if let data = selectedImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(SecondaryBackgroundGradient.backgroundGradient)
                        }
                        
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.brown)
                            .clipShape(Circle())
                            .offset(x: 5, y: 5)
                    }
                }
                .confirmationDialog("اختر خيار", isPresented: $showPhotoOptions) {
                    Button("تغيير الصورة") {
                        showPhotoPicker = true
                    }
                    Button("حذف الصورة", role: .destructive) {
                        selectedImageData = nil
                    }
                    Button("إلغاء", role: .cancel) { }
                }
                
                Spacer()
                
                VStack {
                    Text(profileViewModel.user?.rank ?? "مبتدئ")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ButtonBackGroundColor.backgroundGradient)
                        .cornerRadius(10)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<4) { _ in
                            Image(systemName: "suit.club.fill")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.caption2)
                        }
                    }
                }
            }
            
            if let user = profileViewModel.user {
                Text("\(user.firstName) \(user.lastName)")
        
            
            HStack(spacing: 30) {
                StatView(icon: "medal.fill", value: String(user.medal), color: .yellow)
                StatView(icon: "heart.fill", value: String(user.hearts), color: .red)
                StatView(icon: "star.fill", value: String(user.blackStars), color: .yellow)
                StatView(icon: "plus.circle.fill", value: "0", color: .brown)
            }
            .padding(.top, 5)
          }
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
