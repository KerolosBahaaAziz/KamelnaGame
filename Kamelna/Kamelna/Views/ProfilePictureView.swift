//
//  ProfilePictureView.swift
//  Kamelna
//
//  Created by Kerlos on 02/05/2025.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

struct ProfilePictureView: View {
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var isUploading = false
    @State private var uploadedUrl: String?
    
    let userEmail: String // Pass logged-in user's email here
    
    var body: some View {
        VStack(spacing: 20) {
            
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 150, height: 150)
                    .overlay(Text("Pick Image").foregroundColor(.white))
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Choose Profile Picture")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
            
            if selectedImage != nil {
                Button(action: uploadImage) {
                    if isUploading {
                        ProgressView()
                    } else {
                        Text("Upload and Save")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            
            if let uploadedUrl {
                Text("✅ Uploaded URL saved!")
                Text(uploadedUrl)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
    
    // 🔥 Upload Function
    func uploadImage() {
        guard let selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.8) else { return }
        
        isUploading = true
        
        let safeEmail = userEmail.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        let filename = "\(safeEmail)_profile_picture.jpg"
        let ref = Storage.storage().reference().child("profile_pictures/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("❌ Upload failed: \(error.localizedDescription)")
                isUploading = false
                return
            }
            ref.downloadURL { url, error in
                isUploading = false
                guard let url else {
                    print("❌ Failed to get URL")
                    return
                }
                self.uploadedUrl = url.absoluteString
                saveProfilePicUrl(url.absoluteString)
            }
        }
    }
    
    // ✅ Save URL to Firestore
    func saveProfilePicUrl(_ url: String) {
        let safeEmail = userEmail.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        let userDoc = Firestore.firestore().collection("users").document(safeEmail)
        
        userDoc.updateData(["profilePictureUrl": url]) { error in
            if let error = error {
                print("❌ Failed to save URL: \(error.localizedDescription)")
            } else {
                print("✅ URL saved in Firestore")
            }
        }
    }
}


#Preview {
    ProfilePictureView(userEmail: "kero@")
}
