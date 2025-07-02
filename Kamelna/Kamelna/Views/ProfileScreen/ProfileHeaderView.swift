import SwiftUI
import PhotosUI

struct ProfileHeaderView: View {
    @ObservedObject var profileViewModel: UserViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedData: Data?
    
    var body: some View {
        VStack(spacing: 10) {
            // Header with Text and Button
            HStack {
                Button("عودة") {
                    SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                    // Add back/dismiss functionality here
                }
                .padding(10)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .background(ButtonBackGroundColor.backgroundGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing,40)
                
                Text("الملف الشخصي")
                    .font(.title3.bold())
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
               Spacer()
               
            }
            .frame(maxWidth: .infinity, alignment: .center) 
            
            // Profile Picture
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
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.leading, 0) // Remove leading padding to avoid skewing
            
            // Rank, Name, and Stats
            VStack(spacing: 5) {
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
                if let user = profileViewModel.user {
                    Text("\(user.firstName) \(user.lastName)")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack(spacing: 30) {
                        StatView(icon: "heart.fill", value: String(user.hearts), color: .red)
                    }
                    .padding(.top, 5)
                }
                
               
            }
            .frame(maxWidth: .infinity, alignment: .center) // Center the entire section
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}


