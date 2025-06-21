//
//  JoinRoomByCode.swift
//  Kamelna
//
//  Created by Kerlos on 16/05/2025.
//

import SwiftUI

struct JoinRoomByCode: View {
    @State private var enteredText: String = ""
    @ObservedObject var profileViewModel = UserViewModel()
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Something:")
                .font(.headline)

            TextField("Type here...", text: $enteredText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                RoomManager.shared.joinRoom(roomId: enteredText, currentUserId: UserDefaults.standard.string(forKey: "userId") ?? "mom", currentUserEmail: profileViewModel.user?.email ?? "", playerName: "soad") { success in
                    if success{
                        print("joined to the room")
                    }else{
                        print("faild to join the room")
                    }
                }
            }) {
                Text("Print Text")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

struct TextFieldButtonView_Previews: PreviewProvider {
    static var previews: some View {
        JoinRoomByCode()
    }
}

