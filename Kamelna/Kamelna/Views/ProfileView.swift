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

    let tabs = ["نبذة", "التصنيف", "الجوائز"]

    var body: some View {
        VStack(spacing: 20) {
            // Top bar
            HStack {
                Button("تعديل") { }
                    .font(.callout.bold())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)

                Spacer()

                Text("الملف الشخصي")
                    .font(.title3.bold())

                Spacer()

                Button("عودة") { }
                    .font(.callout.bold())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding(.horizontal)

            // Profile Card
            VStack(spacing: 12) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "plus")
                                .foregroundColor(.gray)
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
                                    .foregroundColor(.gray.opacity(0.5))
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
                            .background(Color.brown.opacity(0.2))
                            .cornerRadius(10)

                        HStack(spacing: 2) {
                            ForEach(0..<4) { _ in
                                Image(systemName: "suit.club.fill")
                                    .foregroundColor(.gray)
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
                        selectedTab = tab
                    } label: {
                        Text(tab)
                            .font(.callout)
                            .foregroundColor(selectedTab == tab ? .brown : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedTab == tab ? Color.white : Color.clear)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(6)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .padding(.horizontal)

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
                .foregroundColor(.gray)

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
        .padding(.top)
        .background(Color("Background").ignoresSafeArea())
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
                    tempBioText = bioText
                    showBioEditor = true
                }
                .foregroundColor(.gray)
            } else {
                VStack(spacing: 8) {
                    Text(bioText)
                        .multilineTextAlignment(.trailing)
                        .padding()

                    Button("تعديل") {
                        tempBioText = bioText
                        showBioEditor = true
                    }
                    .font(.caption)
                    .foregroundColor(.brown)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }

    var rankingCard: some View {
        VStack(spacing: 10) {
            Text("مستواك الحالي: مبتدئ")
                .font(.headline)
            Text("لا توجد تصنيفات متاحة حالياً.")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }

    var awardsCard: some View {
        VStack(spacing: 10) {
            Text("لم تحصل على أي جوائز بعد.")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }

    // MARK: - Bio Editor Sheet
    var bioEditorSheet: some View {
        VStack(spacing: 16) {
            Text("تعديل النبذة")
                .font(.title2.bold())
                .foregroundColor(.white)

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
                    showBioEditor = false
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .cornerRadius(12)

                Spacer()

                Button("حفظ") {
                    bioText = tempBioText
                    showBioEditor = false
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.brown)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(30)
        .presentationDetents([.medium])
    }

}



#Preview {
    ProfileView()
}
