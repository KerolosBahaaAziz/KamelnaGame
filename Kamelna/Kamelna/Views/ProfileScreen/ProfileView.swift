//
//  ProfileView.swift
//  Kamelna
//
//  Created by Kerlos on 03/05/2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showPhotoOptions = false
    @State private var selectedTab: String = "نبذة"
    @State private var bioText: String = ""
    @State private var showPhotoPicker = false
    @State private var showBioEditor = false
    @State private var tempBioText: String = ""
    @State private var selectedRankingCardTab : String = "daily"
    @State private var selectedRankingArranging : String = "arranging"
    @State private var awardsSelectedTab = "الجوائز"
    let awardsTabs = ["الجوائز", "الإنجازات", "الألقاب"]
    
    let tabs = ["نبذة", "التصنيف", "الجوائز"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Top bar
            HStack {
                Button("تعديل") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                }
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .font(.callout.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(10)
                .shadow(radius: 2)
                
                
                Spacer()
                
                Text("الملف الشخصي")
                    .font(.title3.bold())
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                
                Spacer()
                
                Button("عودة") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                }
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .font(.callout.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
            .padding(.horizontal)
            
            // Profile Card
            VStack(spacing: 12) {
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
                        Text("مبتدئ")
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
                
                Text("Kerolos Bahaa")
                    .font(.headline)
                
                HStack(spacing: 30) {
                    StatView(icon: "medal.fill", value: "0", color: .yellow)
                    StatView(icon: "heart.fill", value: "0", color: .red)
                    StatView(icon: "star.fill", value: "0", color: .yellow)
                    StatView(icon: "plus.circle.fill", value: "0", color: .brown)
                }
                .padding(.top, 5)
            }
            .padding()
            .background(Color("CardBackground"))
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
            
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
            Group {
                if selectedTab == "نبذة" {
                    bioCard
                } else if selectedTab == "التصنيف" {
                    rankingCard
                } else if selectedTab == "الجوائز" {
                    awardsCard
                }
            }
            .animation(.easeInOut, value: selectedTab)
            
            Text("لقد انضممت الى كملنا بتاريخ 2025/04/22")
                .font(.footnote)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            
            Spacer()
            
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                EmptyView()
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
            
            .onChange(of: showPhotoPicker) { show in
                if show {
                    selectedItem = nil
                }
            }
        }
        .background(BackgroundGradient.backgroundGradient)
        //        .padding(.top)
        .environment(\.layoutDirection, .rightToLeft)
        .sheet(isPresented: $showBioEditor) {
            bioEditorSheet
        }
    }
    
    // MARK: - Cards
    var bioCard: some View {
        VStack {
            if bioText.isEmpty {
                Button("اضغط هنا لإضافة نبذة عامة") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                    tempBioText = bioText
                    showBioEditor = true
                }
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            } else {
                VStack(spacing: 8) {
                    Text(bioText)
                        .multilineTextAlignment(.trailing)
                        .padding()
                    
                    Button("تعديل") {
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        tempBioText = bioText
                        showBioEditor = true
                    }
                    .font(.caption)
                    .foregroundColor(.brown)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SecondaryBackgroundGradient.backgroundGradient)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
    
    var rankingCard: some View {
        VStack(spacing: 16) {
            
            // Top Tab: "الأداء" / "الترتيب"
            HStack(spacing: 8) {
                ForEach(["arranging", "performace"], id: \.self) { tab in
                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                        selectedRankingArranging = tab
                    }) {
                        Text(tab == "arranging" ? "الترتيب" : "الأداء")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedRankingArranging == tab ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Card Content
            VStack(spacing: 20) {
                Text("مستواك الحالي: مبتدئ")
                    .font(.headline)
                    .padding()
                
                // Circular Progress
                ZStack {
                    Circle()
                        .stroke(SecondaryBackgroundGradient.backgroundGradient, lineWidth: 10)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(BackgroundGradient.backgroundGradient, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 120, height: 120)
                    
                    Text("250")
                        .font(.title)
                        .bold()
                }
                
                Text("لا توجد تصنيفات متاحة حالياً.")
                
                // Bottom Tab: "يوميًا" / "أسبوعيًا"
                HStack(spacing: 8) {
                    ForEach(["daily", "weekly"], id: \.self) { tab in
                        Button(action: {
                            SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                            selectedRankingCardTab = tab
                        }) {
                            Text(tab == "daily" ? "يوميًا" : "أسبوعيًا")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedRankingCardTab == tab ? SelectedButtonBackGroundColor.backgroundGradient : UnSelectedButtonBackGroundColor.backgroundGradient)
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
    
    
    
    var awardsCard: some View {
        VStack(spacing: 16) {
            // Custom Tab Picker
            HStack(spacing: 8) {
                ForEach(awardsTabs, id: \.self) { tab in
                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                        awardsSelectedTab = tab
                    }) {
                        Text(tab)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(awardsSelectedTab == tab
                                          ? SelectedButtonBackGroundColor.backgroundGradient
                                          : UnSelectedButtonBackGroundColor.backgroundGradient)
                            )
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    }
                }
            }
            .padding(.horizontal)
            
            // The awards card view
            VStack(spacing: 16) {
                ZStack {
                    Image("cupBoard")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(0.3)
                    
                    Text("خزانة الجوائز فارغة")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .padding(.horizontal)
                }
                
                Text("لم تحصل على أي جوائز بعد.")
                    .font(.footnote)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Bio Editor Sheet
    var bioEditorSheet: some View {
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
                        bioText = tempBioText
                        showBioEditor = false
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



#Preview {
    ProfileView()
}
