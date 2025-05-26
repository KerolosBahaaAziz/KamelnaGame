//
//  BotsManager.swift
//  Kamelna
//
//  Created by Kerlos on 02/05/2025.
//

import Foundation
import FirebaseFirestore

class BotsManager{
    static let shared = BotsManager()
    
    func startBotTimerAfterCreatingRoom(roomId: String, completion: @escaping ([String: [String: Any]]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let roomRef = Firestore.firestore().collection("rooms").document(roomId)
            
            roomRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      var players = data["players"] as? [String: [String: Any]],
                      var playerOrder = data["playerOrder"] as? [String] else {
                    completion([:])
                    return
                }

                if players.count >= 4 {
                    completion(players)
                    return
                }

                // Add bots
                let updatedPlayers = self.addBotsIfNeeded(to: players)
                let updatedPlayerOrder = playerOrder + updatedPlayers.keys.filter {
                    !playerOrder.contains($0) && $0.starts(with: "bot")
                }

                // Update Firestore
                roomRef.updateData([
                    "players": updatedPlayers,
                    "playerOrder": updatedPlayerOrder
                ]) { error in
                    if let error = error {
                        print("Error updating room: \(error)")
                        completion([:])
                        return
                    }

                    completion(updatedPlayers)
                    // Distribute cards
                    /*RoomManager.shared.distributeCardsToPlayers(roomId: roomId, players: updatedPlayers) { success in
                        
                        print("Bots added: \(updatedPlayers.count - players.count), cards distributed: \(success)")
                        completion()
                    }*/
                }
            }
        }
    }
    
    func addBotsIfNeeded(to players: [String: [String: Any]]) -> [String: [String: Any]] {
        var updatedPlayers = players
        var currentCount = players.count
        let neededBots = max(0, 4 - currentCount)
        
        
        for i in 1...neededBots {
            let botId = "bot\(i)"
            if updatedPlayers[botId] == nil {
                updatedPlayers[botId] = [
                    "name": "Bot \(i)",
                    "isBot": true,
                    "hand": [],
                    "seat": currentCount,
                    "team":currentCount%2 + 1,
                    "score":0,
                    "playedCard": NSNull()
                ]
            }
            currentCount = currentCount+1
        }
        
        return updatedPlayers
    }
    
    func playBotTurn(playerId: String, roomId: String) {
        let roomRef = Firestore.firestore().collection("rooms").document(roomId)
        
        roomRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  var players = data["players"] as? [String: [String: Any]],
                  var bot = players[playerId],
                  var hand = bot["hand"] as? [String],
                  let currentTurnId = data["turnPlayerId"] as? String,
                  currentTurnId == playerId else {
                print("Bot \(playerId) tried to play, but it's not its turn or data missing.")
                return
            }
            
            // Get current trick info
            var currentTrick = data["currentTrick"] as? [String: Any] ?? [:]
            var cards = currentTrick["cards"] as? [[String: String]] ?? []
            
            // Determine required suit
            var requiredSuit: String? = nil
            if let firstCard = cards.first?["card"] {
                requiredSuit = String(firstCard.suffix(1)) // e.g. "7H" → "H"
            }
            
            // Choose a card to play
            let validCards = requiredSuit != nil ? hand.filter { $0.hasSuffix(requiredSuit!) } : hand
            guard let selectedCard = validCards.first ?? hand.first else {
                print("Bot \(playerId) has no cards to play.")
                return
            }
            
            // Update hand and trick
            hand.removeAll { $0 == selectedCard }
            bot["hand"] = hand
            players[playerId] = bot
            cards.append(["playerId": playerId, "card": selectedCard])
            currentTrick["cards"] = cards
            
            // Commit updates
            roomRef.updateData([
                "players": players,
                "currentTrick": currentTrick
            ]) { error in
                if let error = error {
                    print("Error updating bot play: \(error.localizedDescription)")
                } else {
                    print("Bot \(playerId) played \(selectedCard)")
                    RoomManager.shared.advanceTurn(toNextPlayerIn: roomId)
                }
            }
        }
    }

}
