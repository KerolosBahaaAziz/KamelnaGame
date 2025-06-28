import SwiftUI
import PhotosUI

struct ProfileHeaderView: View {
    @ObservedObject var profileViewModel: UserViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedData: Data?
    
    var body: some View {
        VStack(spacing: 12) {
            // Top Navigation Bar
            HStack {
                // Edit Button - Could be for profile editing
                Button("تعديل") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                   // profileViewModel.updateRank(earnedPoint: 1000)
                }
                .padding(5)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .background(ButtonBackGroundColor.backgroundGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
                Text("الملف الشخصي")
                    .font(.title3.bold())
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                
                Spacer()
                
                // Back Button - Should likely dismiss the view
                Button("عودة") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                    // Add back/dismiss functionality here
                }
                .padding(5)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .background(ButtonBackGroundColor.backgroundGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            
            // Profile Picture and Stats Row
            HStack {
                // The plus sign appears to be for adding something - perhaps friends?
                Button {
                    // Add functionality for whatever this plus represents
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "plus")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        )
                }
                
                Spacer()
                
                // Profile Picture with direct photo picker
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    AsyncImage(url: URL(string: (profileViewModel.user?.profilePictureUrl ?? ""))) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(SecondaryBackgroundGradient.backgroundGradient)
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        case .failure(_):
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(SecondaryBackgroundGradient.backgroundGradient)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .onChange(of: selectedItem, initial: false) { _, newItem in
                    Task {
                        selectedData = nil
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedData = data
                            if let uiImage = UIImage(data: data) {
                                self.profileViewModel.updateImage(image: uiImage)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Rank and Stars
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
            
            // User Name and Stats
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
