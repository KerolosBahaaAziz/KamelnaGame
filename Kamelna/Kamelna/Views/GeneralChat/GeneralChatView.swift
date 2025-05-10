//
//  GeneralChatView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 07/05/2025.
//

import SwiftUI
import FirebaseAuth

struct GeneralChatView: View {
    @StateObject private var chatManager = GeneralChatManager.shared
    @State private var newMessage: String = ""
    @State private var userId: String = Auth.auth().currentUser?.uid ?? ""

    var body: some View {
        VStack {
            LogoView()
            Text("الدردشة العامة")
                .font(.title2)
                .bold()

            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(chatManager.messages) { message in
                            HStack {
                                if message.senderId == userId {
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(message.senderName)
                                            .font(.caption)
                                            .foregroundColor(.gray)

                                        Text(message.text)
                                            .padding(10)
                                            .background(ButtonBackGroundColor.backgroundGradient)
                                            .cornerRadius(10)
                                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)

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
                                            .background(UnSelectedButtonBackGroundColor.backgroundGradient)
                                            .cornerRadius(10)
                                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)

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
                .onReceive(chatManager.$messages) { messages in
                    if let last = messages.last {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
                    let trimmedMessage = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedMessage.isEmpty else { return }

                    chatManager.sendMessage(
                        text: trimmedMessage,
                        senderId: userId,
                        senderName: Auth.auth().currentUser?.displayName ?? "Anonymous"
                    ) {
                        newMessage = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(BackgroundGradient.backgroundGradient)
        .onAppear {
            userId = Auth.auth().currentUser?.uid ?? ""
            chatManager.listenToMessages()
        }
        .onDisappear {
            chatManager.stopListening()
        }
    }
}


#Preview {
    GeneralChatView()
}
