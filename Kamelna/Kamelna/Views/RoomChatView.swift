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
    let roomId: String
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var listener: ListenerRegistration?
    @State private var userId: String = Auth.auth().currentUser?.uid ?? ""
    var roomManager = RoomManager()
    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(messages) { message in
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
                .onChange(of: messages.count) { _ , _ in
                    if let lastMessage = messages.last {
                        scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack {
                TextField("Enter your message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .navigationTitle("Room: \(roomId)")
        .onAppear {
            userId = Auth.auth().currentUser?.uid ?? ""
            listenToMessages()
        }
        .onDisappear {
            listener?.remove()
        }
    }

    func listenToMessages() {
        let db = Firestore.firestore()
        listener = db.collection("rooms")
            .document(roomId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.messages = documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let senderId = data["senderId"] as? String,
                        let senderName = data["senderName"] as? String,
                        let text = data["message"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp
                    else {
                        return nil
                    }

                    return Message(
                        id: doc.documentID,
                        senderId: senderId,
                        senderName: senderName,
                        text: text,
                        timestamp: timestamp.dateValue()
                    )
                }
            }
    }

    func sendMessage() {
        let db = Firestore.firestore()
        let trimmedText = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let messageData: [String: Any] = [
            "senderId": userId,
            "senderName": Auth.auth().currentUser?.displayName ?? "Anonymous",
            "message": trimmedText,
            "timestamp": FieldValue.serverTimestamp()
        ]


        db.collection("rooms")
            .document(roomId)
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    newMessage = ""
                }
            }
    }
}


#Preview {
    RoomChatView(roomId: "V3FDS")
}
