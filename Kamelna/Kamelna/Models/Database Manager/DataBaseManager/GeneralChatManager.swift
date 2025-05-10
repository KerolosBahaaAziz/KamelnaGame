//
//  GeneralChatManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 07/05/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class GeneralChatManager: ObservableObject {
    @Published var messages: [Message] = []
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private let collection = "general_messages"

    static let shared = GeneralChatManager()

    func listenToMessages() {
        listener = db.collection(collection)
            .order(by: "timestamp", descending: false)
            .limit(toLast: 100)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self.messages = docs.compactMap { doc -> Message? in
                    let data = doc.data()
                    guard
                        let senderId = data["senderId"] as? String,
                        let senderName = data["senderName"] as? String,
                        let text = data["text"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp
                    else { return nil }

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

    func stopListening() {
        listener?.remove()
    }

    func sendMessage(text: String, senderId: String, senderName: String, completion: @escaping () -> Void) {
        let messageData: [String: Any] = [
            "senderId": senderId,
            "senderName": senderName,
            "text": text,
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection(collection).addDocument(data: messageData) { error in
            if error == nil {
                self.enforceMessageLimit()
                completion()
            }
        }
    }

    // Keep only the latest 100 messages
    private func enforceMessageLimit() {
        db.collection(collection)
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents, docs.count > 100 else { return }

                let extra = docs.prefix(docs.count - 100)
                for doc in extra {
                    doc.reference.delete()
                }
            }
    }
}
