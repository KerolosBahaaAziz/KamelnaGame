//
//  TestingFindOrCreateRoom.swift
//  Kamelna
//
//  Created by Yasser Yasser on 30/04/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct TestingFindOrCreateRoom: View {
    @State private var userId: String = ""
    @State private var roomId: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    var roomManager : RoomManager = RoomManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("User ID: \(userId)")
                .font(.caption)
                .foregroundColor(.gray)

            if isLoading {
                ProgressView("Searching for a room...")
            } else {
                Button("Find or Create Room") {
                    findOrCreateRoom()
                }
            }

            if !roomId.isEmpty {
                Text("Joined/Created Room: \(roomId)")
                    .font(.headline)
                    .foregroundColor(.green)
            }

            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            signInAnonymously()
        }
    }

    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                self.errorMessage = "Auth error: \(error.localizedDescription)"
                return
            }
            if let user = authResult?.user {
                self.userId = user.uid
                print("Signed in as: \(user.uid)")
            }
        }
    }

    func findOrCreateRoom() {
        guard !userId.isEmpty else {
            self.errorMessage = "User not signed in"
            return
        }

        isLoading = true
        errorMessage = nil

        roomManager.autoJoinOrCreateRoom(currentUserId: userId, playerName: "Player-\(userId.prefix(4))") { result in
            DispatchQueue.main.async {
                isLoading = false
                if let room = result {
                    roomId = room
                } else {
                    errorMessage = "Failed to join or create a room"
                }
            }
        }
    }
}

#Preview {
    TestingFindOrCreateRoom()
}
