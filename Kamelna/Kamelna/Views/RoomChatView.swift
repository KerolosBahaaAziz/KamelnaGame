//
//  RoomMessagesView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 01/05/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Message: Identifiable {
    var id: String
    var senderId: String
    var senderName: String
    var text: String
    var timestamp: Date
}


struct RoomChatView: View {
    @Binding var roomId: String
    @StateObject private var roomManager = RoomManager.shared
    @State private var newMessage: String = ""
    @State private var userId: String = Auth.auth().currentUser?.uid ?? ""

//    var roomManager = RoomManager()
    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(roomManager.messages) { message in
                            HStack {
                                if message.senderId == userId {
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(message.senderName)
                                            .font(.caption)
                                            .foregroundColor(.gray)

                                        Text(message.text)
                                            .padding(10)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                            .foregroundColor(.white)

                                        Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .id(message.id)
                                } else {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(message.senderName)
                                            .font(.caption)
                                            .foregroundColor(.gray)

                                        Text(message.text)
                                            .padding(10)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                            .foregroundColor(.black)

                                        Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .id(message.id)
                                    Spacer()
                                }
                            }
                        }

                    }
                    .padding()
                }
                .onReceive(roomManager.$messages) { messages in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let last = messages.last {
                            scrollProxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            HStack {
                TextField("Enter your message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)

                Button {
                    roomManager.sendMessage(
                        roomId: roomId,
                        text: newMessage,
                        senderId: userId,
                        senderName: Auth.auth().currentUser?.displayName ?? "Anonymous"
                    ) {
                        newMessage = "" // Clear input after sending
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }

            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .navigationTitle("Room: \(roomId)")
        .onAppear {
            userId = Auth.auth().currentUser?.uid ?? ""
            roomManager.messages = []
            roomManager.listenToMessages(roomId: roomId) {
                
            }
        }

        .onDisappear {
            roomManager.stopListening()
        }
    }
}


#Preview {
    @Previewable @State var roomId: String = ""
    RoomChatView(roomId: $roomId)
}
