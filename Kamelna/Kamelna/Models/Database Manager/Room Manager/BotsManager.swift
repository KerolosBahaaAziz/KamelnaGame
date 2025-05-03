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
    
    func startBotTimerAfterCreatingRoom(roomId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) { 
            let roomRef = Firestore.firestore().collection("rooms").document(roomId)
            
            roomRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      var players = data["players"] as? [String: [String: Any]] else {
                          completion()
                          return
                      }

                if players.count >= 4 {
                    completion()
                    return
                }

                let updatedPlayers = self.addBotsIfNeeded(to: players)

                roomRef.updateData(["players": updatedPlayers]) { error in
                    if error == nil {
                        RoomManager.shared.distributeCardsToPlayers(roomId: roomId, players: updatedPlayers) { success in
                            print ("bots added and card distributed : \(success)")
                            completion()
                        }
                    } else {
                        completion()
                    }
                }
            }
        }
    }
    
    func addBotsIfNeeded(to players: [String: [String: Any]]) -> [String: [String: Any]] {
        var updatedPlayers = players
        let currentCount = players.count
        let neededBots = max(0, 4 - currentCount)
        
        for i in 1...neededBots {
            let botId = "bot\(i)"
            if updatedPlayers[botId] == nil {
                updatedPlayers[botId] = [
                    "name": "Bot \(i)",
                    "isBot": true,
                    "hand": [],
                    "playedCard": NSNull()
                ]
            }
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
                  let firstPlayerId = data["firstPlayerInTrick"] as? String,
                  let firstCard = (data["cardsInTrick"] as? [String: String])?[firstPlayerId] else {
                return
            }

            // نوع الورقة المطلوبة (نفس نوع أول لاعب في الجولة)
            let requiredSuit = String(firstCard.last!)  // مثال: "7H" → "H"
            
            // حاول يلاقي ورقة من نفس النوع
            let validCards = hand.filter { $0.hasSuffix(requiredSuit) }
            let cardToPlay = validCards.first ?? hand.first  // لو مفيش من نفس النوع، العب أي ورقة

            guard let selectedCard = cardToPlay else { return }
            hand.removeAll { $0 == selectedCard }
            bot["hand"] = hand
            bot["playedCard"] = selectedCard
            players[playerId] = bot

            var cardsInTrick = data["cardsInTrick"] as? [String: String] ?? [:]
            cardsInTrick[playerId] = selectedCard

            roomRef.updateData([
                "players": players,
                "cardsInTrick": cardsInTrick
            ]) { _ in
                print("Bot \(playerId) played \(selectedCard)")
            }
        }
    }
}
