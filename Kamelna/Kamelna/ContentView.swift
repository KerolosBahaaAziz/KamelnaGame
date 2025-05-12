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
    //    let roomManager = RoomManager()
    @State var roomID : String = ""
    @State var shouldNavigate = false
    
    var body: some View {
//                GameView()
//                NavigationStack{
//                    VStack{
//                        GoogleSignInView()
//                        Button("Create Room", action: {
//                            if let user = Auth.auth().currentUser {
//                                let userId = user.uid
//                                RoomManager.shared.autoJoinOrCreateRoom(currentUserId: userId, playerName: "testing2", completion: {
//                                    roomId in
//                                    guard let roomId = roomId else {
//                                        print("Couldn't create a room ID")
//                                        return
//                                    }
//                                    roomID = roomId
//                                    shouldNavigate = true
//                                    print("Successfully Created a room \(roomId)")
//                                })
//                                print("User ID: \(userId)")
//                            } else {
//                                // Handle the case where no user is signed in
//                                print("No user is logged in. Redirect to login screen.")
//                            }
//                        })
//                        NavigationLink(destination: RoomChatView(roomId: $roomID), isActive: $shouldNavigate) {
//                            EmptyView()
//                        }
//                        .hidden()
//                    }
//                }
//            }
        //                GameView()
        //                NavigationStack{
        //                    VStack{
        //                        GoogleSignInView()
        //                        Button("Create Room", action: {
        //                            if let user = Auth.auth().currentUser {
        //                                let userId = user.uid
        //                                RoomManager.shared.autoJoinOrCreateRoom(currentUserId: userId, playerName: "testing2", completion: {
        //                                    roomId in
        //                                    guard let roomId = roomId else {
        //                                        print("Couldn't create a room ID")
        //                                        return
        //                                    }
        //                                    roomID = roomId
        //                                    shouldNavigate = true
        //                                    print("Successfully Created a room \(roomId)")
        //                                })
        //                                print("User ID: \(userId)")
        //                            } else {
        //                                // Handle the case where no user is signed in
        //                                print("No user is logged in. Redirect to login screen.")
        //                            }
        //                        })
        //                        NavigationLink(destination: RoomChatView(roomId: $roomID), isActive: $shouldNavigate) {
        //                            EmptyView()
        //                        }
        //                        .hidden()
        //                    }
        //                }
        //            }
        //        RegisterView()
        //        CreateRoomView()
        //        LoadingScreenView()
//        GeneralChatView()
//        RoomChatView(roomId: $roomID)
//        LoadingScreenView()
//        HomeView()
        GameSceneView(roomId: "20WCY", playerId: "lX91ZYxO5Tbx31lYNVVrXB7yJsM2")
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
