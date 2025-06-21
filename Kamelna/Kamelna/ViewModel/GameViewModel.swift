//
//  GameViewModel.swift
//  Kamelna
//
//  Created by Kerlos on 11/05/2019.
//

import Foundation
import FirebaseFirestore

class GameViewModel: ObservableObject {
    @Published var roomData: [String: Any]?
    @Published var isMyTurn = false
    @Published var players: [Player] = []
    
    var listener: ListenerRegistration?
    var roomId: String
    var playerId: String
    var hand: [Card] {
        guard let roomData = roomData,
              let players = roomData["players"] as? [String: [String: Any]],
              let playerData = players[playerId],
              let handStrings = playerData["hand"] as? [String] else {
            return []
        }
        
        return handStrings.compactMap { Card.from(string: $0) }
    }
    
    var centerCard: Card? {
        guard let trick = roomData?["currentTrick"] as? [String: Any],
              let cards = trick["cards"] as? [[String: String]],
              let lastCardString = cards.last?["card"] else {
            return nil
        }
        
        return Card.from(string: lastCardString)
    }
    
    var playedCards: [Card] {
        guard let roomData = roomData,
              let trick = roomData["trick"] as? [String: String] else {
            return []
        }
        return trick.values.compactMap { Card.from(string: $0) }
    }
    
    
    init(roomId: String, playerId: String) {
        self.roomId = roomId
        self.playerId = playerId
        listenToRoomUpdates()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.fetchPlayers(roomId: roomId)
        }
    }
    
    
    func listenToRoomUpdates() {
        RoomManager.shared.listenToRoom(roomId: roomId) { [weak self] data in
            if data != nil {
                DispatchQueue.main.async {
                    self?.roomData = data
                    self?.checkTurn()
                }
            }else {
                print("no room wwith this id so can not to fetch room data")
            }
        }
    }
    
    func fetchPlayers(roomId: String) {
        Firestore.firestore().collection("rooms").document(roomId)
            .addSnapshotListener { snapshot, error in
                guard let data = snapshot?.data() else { return }
                print("room id : \(roomId)")
                
                if let playersMap = data["players"] as? [String: [String: Any]] {
                    let players: [Player] = playersMap.compactMap { (key, value) in
                        do {
                            var player = try Firestore.Decoder().decode(Player.self, from: value)
                            player.id = key // <-- 🔥 This is critical!
                            return player
                        } catch {
                            print("Decoding error for player \(key): \(error)")
                            return nil
                        }
                    }
                    print("number of players = \(players.count)")
                    self.players = players
                }
            }
    }
    
    func playCard(card: Card) {
        RoomManager.shared.playCard(roomId: roomId, playerId: playerId, card: card.toString()) { success in
            if !success {
                print("Failed to play card")
            }else{
                self.checkTurn()
            }
        }
    }
    
    func checkTurn() {
        RoomManager.shared.isPlayerTurn(roomId: roomId, playerId: playerId) { [weak self] isTurn in
            DispatchQueue.main.async {
                self?.isMyTurn = isTurn
            }
        }
    }
    
    func parseHand() -> [Card] {
        guard let roomData = roomData,
              let players = roomData["players"] as? [String: [String: Any]],
              let playerData = players[playerId],
              let handStrings = playerData["hand"] as? [String] else {
            return []
        }
        
        return handStrings.compactMap { Card.from(string: $0) }
    }
    
    func startListeningForRoomUpdates() {
        let db = Firestore.firestore()
        listener = db.collection("rooms").document(roomId).addSnapshotListener { [weak self] snapshot, error in
            self?.checkTurn()
        }
    }
    
    deinit {
        listener?.remove()
    }
    
}
