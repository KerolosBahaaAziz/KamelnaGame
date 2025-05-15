import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showPhotoOptions = false
    @State private var selectedTab: String = "نبذة"
    @State private var showPhotoPicker = false
    @State private var showBioEditor = false
    @State private var tempBioText: String = ""
    @State private var selectedRankingCardTab : String = "daily"
    @State private var selectedRankingArranging : String = "arranging"
    @State private var awardsSelectedTab = "الجوائز"

    let tabs = ["نبذة", "التصنيف", "الجوائز"]

    var body: some View {
        VStack(spacing: 20) {
            ProfileHeaderView(profileViewModel: profileViewModel,
                              selectedImageData: $selectedImageData,
                              showPhotoOptions: $showPhotoOptions,
                              showPhotoPicker: $showPhotoPicker)

            ProfileTabsView(tabs: tabs, selectedTab: $selectedTab)

            Group {
                switch selectedTab {
                case "نبذة":
                    BioCardView(profileViewModel: profileViewModel,
                                showBioEditor: $showBioEditor,
                                tempBioText: $tempBioText)
                case "التصنيف":
                    RankingCardView(profileViewModel: profileViewModel,
                                    selectedRankingCardTab: $selectedRankingCardTab,
                                    selectedRankingArranging: $selectedRankingArranging)
                case "الجوائز":
                    AwardsCardView(selectedTab: $awardsSelectedTab)
                default:
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: selectedTab)

            Text(profileViewModel.user?.creationDate ?? "")
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
        }
        .sheet(isPresented: $showBioEditor) {
            BioEditorSheet(tempBioText: $tempBioText, showBioEditor: $showBioEditor)
        }
        .background(BackgroundGradient.backgroundGradient)
        .environment(\.layoutDirection, .rightToLeft)
    }
}
