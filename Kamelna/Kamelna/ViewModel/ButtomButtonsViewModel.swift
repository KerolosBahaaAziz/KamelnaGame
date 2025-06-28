//
//  ButtomButtonsViewModel.swift
//  Kamelna
//
//  Created by Kerlos on 20/06/2025.
//

import Foundation
import FirebaseFirestore
//import Combine

class BottomButtonsViewModel: ObservableObject {
    @Published var gameStatus: String = RoomStatus.waiting.rawValue

    private var listener: ListenerRegistration?
    private let roomId = UserDefaults.standard.string(forKey: "roomId") ?? ""

    init() {
        listenToStatusChanges()
    }

    func listenToStatusChanges() {
        let roomRef = Firestore.firestore().collection("rooms").document(roomId)
        listener = roomRef.addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(), let status = data["status"] as? String else { return }
            DispatchQueue.main.async {
                self.gameStatus = status
            }
        }
    }

    deinit {
        listener?.remove()
    }
}
