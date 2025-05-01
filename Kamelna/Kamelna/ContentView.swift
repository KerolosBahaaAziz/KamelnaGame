//
//  ContentView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let roomManager = RoomManager()
    @State var roomID : String = ""
    @State var message : String = ""
    var body: some View {
//        GameView()
        VStack{
            GoogleSignInView()
            Button("Create Room", action: {
                if let user = Auth.auth().currentUser {
                    let userId = user.uid
                    roomManager.autoJoinOrCreateRoom(currentUserId: userId, playerName: "testing2", completion: {
                        roomId in
                        guard let roomId = roomId else {
                            print("Couldn't create a room ID")
                            return
                        }
                        roomID = roomId
                        print("Successfully Created a room \(roomId)")
                    })
                    print("User ID: \(userId)")
                } else {
                    // Handle the case where no user is signed in
                    print("No user is logged in. Redirect to login screen.")
                }
            })
            TextField("send message", text: $message)
            Button("Send Message") {
                if let user = Auth.auth().currentUser {
                    let userId = user.uid
                    roomManager.sendMessage(roomId: roomID, senderId: userId, message: message) { error in
                        if let error = error {
                            print("Error sending message: \(error.localizedDescription)")
                        } else {
                            print("Message sent: \(message)")
                            message = "" // Clear message field after send
                        }
                    }
                }
            }
            RoomChatView(roomId: "V3FDS")
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
