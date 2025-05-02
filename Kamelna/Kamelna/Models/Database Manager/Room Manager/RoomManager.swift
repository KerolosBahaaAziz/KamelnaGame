//
//  RoomManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 30/04/2025.
//

import Foundation
import FirebaseFirestore

class RoomManager {
    static let shared = RoomManager()
    
    func createRoom(currentUserId: String, name: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let roomId = generateRoomCode()
        
        let roomRef = db.collection("rooms").document(roomId)
        
        let roomData: [String: Any] = [
            "hostId": currentUserId,
            "createdAt": FieldValue.serverTimestamp(),
            "status": RoomStatus.waiting.rawValue, // ممكن تبقى: waiting / playing / ended
            "gameType": "baloot",
            "trumpSuit": NSNull(), // لسه متحددش
            "turnPlayerId": NSNull(), // لسه متبدأش اللعبة
            "roundNumber": 1, // يبدأ من الجولة 1
            "teamScores": [
                "team1": 0, // فريق 1 يبدأ من صفر
                "team2": 0  // فريق 2 يبدأ من صفر
            ],
            "players": [
                currentUserId: [
                    "name": name,
                    "seat": 0,
                    "hand": [], // هتتحط بعد التوزيع
                    "team": 1,
                    "score": 0,
                    "isReady": false
                ]
            ],
            "currentTrick": [
                "cards": [] // هيتضاف كل لاعب يلعب
            ],
            "trickWinner": NSNull(),
            "history": [:] // ممكن نحط كل تريك بعد ما يخلص هنا
        ]
        
        roomRef.setData(roomData) { error in
            if let error = error {
                print("Error creating room: \(error)")
                completion(nil)
            } else {
                print("Room created with ID: \(roomId)")
                completion(roomId)
            }
        }
    }
    
    private func generateRoomCode(length: Int = 5) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
    
    func distributeCardsToPlayers(roomId: String, players: [String: [String: Any]], completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)

        // تأكد إن عدد اللاعبين ٤ فقط
        guard players.count == 4 else {
            print("Error: Number of players must be exactly 4 to distribute cards.")
            completion(false)
            return
        }

        let allCards = [
            "7♠️", "8♠️", "9♠️", "10♠️", "J♠️", "Q♠️", "K♠️", "A♠️",
            "7♥️", "8♥️", "9♥️", "10♥️", "J♥️", "Q♥️", "K♥️", "A♥️",
            "7♣️", "8♣️", "9♣️", "10♣️", "J♣️", "Q♣️", "K♣️", "A♣️",
            "7♦️", "8♦️", "9♦️", "10♦️", "J♦️", "Q♦️", "K♦️", "A♦️"
        ]

        var shuffledCards = allCards.shuffled()
        var updatedPlayers = players

        for (playerId, var playerData) in updatedPlayers {
            let hand = Array(shuffledCards.prefix(8))
            shuffledCards.removeFirst(8)
            playerData["hand"] = hand
            playerData["playedCard"] = NSNull()
            updatedPlayers[playerId] = playerData
        }

        var updates: [String: Any] = [:]
        for (playerId, playerData) in updatedPlayers {
            updates["players.\(playerId)"] = playerData
        }
        roomRef.updateData(updates) { error in
            if let error = error {
                print("Error distributing cards: \(error)")
                completion(false)
            } else {
                print("Cards distributed successfully")
                completion(true)
            }
        }
    }
    
    func joinRoom(roomId: String, currentUserId: String, playerName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)
        
        // جلب بيانات الغرفة من Firestore
        roomRef.getDocument { document, error in
            if let error = error {
                print("Error fetching room: \(error)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("Room not found")
                completion(false)
                return
            }
            
            // إذا كانت الغرفة موجودة، نبدأ معالجة بيانات اللاعبين
            var playersData = document.data()?["players"] as? [String: [String: Any]] ?? [:]
            
            // التحقق من عدد اللاعبين في الغرفة
            if playersData.count >= 4 {
                print("Room is full")
                completion(false)
                return
            }
            
            // تحقق إذا كان اللاعب موجود بالفعل أو لا
            if playersData[currentUserId] != nil {
                print("Player already in the room")
                completion(false)
                return
            }
            
            // إضافة اللاعب الجديد إلى playersData
            playersData[currentUserId] = [
                "name": playerName,
                "seat": playersData.count, // تحديد المقعد بناءً على عدد اللاعبين الحاليين
                "hand": [], // سيتم توزيع الكروت لاحقًا
                "team": playersData.count % 2 + 1, // تحديد الفريق: فريق 1 أو فريق 2
                "score": 0,
                "isReady": false
            ]
            
            // تحديث بيانات الغرفة في Firestore
            roomRef.updateData(["players": playersData]) { error in
                if let error = error {
                    print("Error joining room: \(error)")
                    completion(false)
                } else {
                    print("Player \(playerName) joined the room successfully")
                    completion(true)
                }
            }
        }
    }
    
    func joinRoom(roomId: String, currentUserId: String, playerName: String, teamChoice: Int, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)
        
        // جلب بيانات الغرفة من Firestore
        roomRef.getDocument { document, error in
            if let error = error {
                print("Error fetching room: \(error)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("Room not found")
                completion(false)
                return
            }
            
            // إذا كانت الغرفة موجودة، نبدأ معالجة بيانات اللاعبين
            var playersData = document.data()?["players"] as? [String: [String: Any]] ?? [:]
            
            // التحقق من عدد اللاعبين في الغرفة
            if playersData.count >= 4 {
                print("Room is full")
                completion(false)
                return
            }
            
            // التحقق من الفريقين
            let team1Count = playersData.values.filter { $0["team"] as? Int == 1 }.count
            let team2Count = playersData.values.filter { $0["team"] as? Int == 2 }.count
            
            // التحقق من توازن الفرق
            if teamChoice == 1 && team1Count >= 2 {
                print("Team 1 is full, please choose team 2")
                completion(false)
                return
            } else if teamChoice == 2 && team2Count >= 2 {
                print("Team 2 is full, please choose team 1")
                completion(false)
                return
            }
            
            // إضافة اللاعب الجديد إلى playersData
            playersData[currentUserId] = [
                "name": playerName,
                "seat": playersData.count, // تحديد المقعد بناءً على عدد اللاعبين الحاليين
                "hand": [], // سيتم توزيع الكروت لاحقًا
                "team": teamChoice, // تحديد الفريق حسب اختيار اللاعب
                "score": 0,
                "isReady": false
            ]
            
            // تحديث بيانات الغرفة في Firestore
            roomRef.updateData(["players": playersData]) { error in
                if let error = error {
                    print("Error joining room: \(error)")
                    completion(false)
                } else {
                    print("Player \(playerName) joined the room successfully")
                    completion(true)
                }
            }
        }
    }
    
    // دالة لتحديد الفائز في الجولة
    func calculateTrickWinner(cardsInTrick: [String: String], trumpSuit: Suit) -> String? {
        var highestCard: String = ""
        var highestCardValue: Int = 0
        var winnerPlayerId: String?
        
        for (playerId, card) in cardsInTrick {
            let isTrump = isTrumpCard(card: card, trumpSuit: trumpSuit)
            let cardValue = getCardPoints(card: card, trumpSuit: trumpSuit, isTrumpGame: isTrump)
            
            // إذا كانت الورقة أعلى من الورقة الحالية
            if cardValue > highestCardValue {
                highestCardValue = cardValue
                highestCard = card
                winnerPlayerId = playerId
            }
        }
        
        return winnerPlayerId
    }
    
    // دالة لحساب النقاط بناءً على الورقة
    func getCardPoints(card: String, trumpSuit: Suit, isTrumpGame: Bool) -> Int {
        let isTrump = isTrumpCard(card: card, trumpSuit: trumpSuit)
        
        if isTrump {
            // إذا كانت الورقة ترامب، نعتمد التقييم الخاص بالترامب
            return getCardValue(card: card, trumpSuit: trumpSuit.rawValue, isTrumpGame: isTrumpGame)
        } else {
            return getCardValue(card: card, trumpSuit: trumpSuit.rawValue, isTrumpGame: isTrumpGame)
        }
    }
    
    // دالة للتحقق إذا كانت الورقة من نوع ترامب
    func isTrumpCard(card: String, trumpSuit: Suit) -> Bool {
        return card.contains(trumpSuit.rawValue)
    }

    
    // دالة لحساب قيمة الورقة
    func getCardValue(card: String, trumpSuit: String?, isTrumpGame: Bool) -> Int {
        // استخرج الرتبة والسوت
        let suits = ["♠️", "♥️", "♣️", "♦️"]
        guard let suit = suits.first(where: { card.contains($0) }) else { return 0 }

        // استخرج الرتبة (زي "J", "10", "A"...)
        let ranks = ["10", "J", "Q", "K", "A", "9", "8", "7"]
        guard let rank = ranks.first(where: { card.contains($0) }) else { return 0 }

        let isTrump = (trumpSuit != nil && suit == trumpSuit)

        if isTrumpGame && isTrump {
            // قيم الكروت في الحكم
            switch rank {
            case "J": return 20
            case "9": return 14
            case "A": return 11
            case "10": return 10
            case "K": return 4
            case "Q": return 3
            default: return 0
            }
        } else {
            // قيم الكروت في صن أو غير الحكم
            switch rank {
            case "A": return 11
            case "10": return 10
            case "K": return 4
            case "Q": return 3
            case "J": return 2
            default: return 0
            }
        }
    }
    
    // دالة لتحديث النقاط بعد انتهاء الجولة
    func endRound(roomId: String, cardsInTrick: [String: String], trumpSuit: Suit) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)
        
        // حساب الفائز في الجولة
        if let winnerPlayerId = calculateTrickWinner(cardsInTrick: cardsInTrick, trumpSuit: trumpSuit) {
            
            // جلب بيانات الغرفة
            roomRef.getDocument {[weak self] document, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    print("Error fetching room data: \(error)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("Room not found")
                    return
                }
                
                var playersData = document.data()?["players"] as? [String: [String: Any]] ?? [:]
                var teamScores = document.data()?["teamScores"] as? [String: Int] ?? ["team1": 0, "team2": 0]
                
                // تحديد الفريق الفائز بالجولة بناءً على الفائز
                let winningTeam = strongSelf.getWinningTeam(playerId: winnerPlayerId, playersData: playersData)
                
                // إضافة النقاط للفريق الفائز
                if winningTeam == "team1" {
                    teamScores["team1"] = (teamScores["team1"] ?? 0) + 10  // مثال على إضافة 10 نقاط
                } else {
                    teamScores["team2"] = (teamScores["team2"] ?? 0) + 10  // مثال على إضافة 10 نقاط
                }
                
                // تحديث بيانات الغرفة
                roomRef.updateData([
                    "teamScores": teamScores,
                    "turnPlayerId": strongSelf.getNextTurn(
                        currentTurnPlayerId: document.data()?["turnPlayerId"] as! String,
                        playersData: playersData // make sure you have this dictionary available here
                    )

                ]) { error in
                    if let error = error {
                        print("Error updating room data: \(error)")
                    } else {
                        print("Round ended, scores updated, and turn passed")
                    }
                }
            }
        }
    }
    
    // دالة لتحديد الفريق الفائز بناءً على اللاعب الفائز بالجولة
    func getWinningTeam(playerId: String, playersData: [String: [String: Any]]) -> String {
        if let team = playersData[playerId]?["team"] as? Int {
            return team == 1 ? "team1" : "team2"
        }
        return "team1" // default
    }

    
    // دالة لتحديد الدور التالي
    func getNextTurn(currentTurnPlayerId: String, playersData: [String: [String: Any]]) -> String {
        guard let currentPlayer = playersData[currentTurnPlayerId],
              let currentSeat = currentPlayer["seat"] as? Int else { return currentTurnPlayerId }
        
        let nextSeat = (currentSeat + 1) % 4
        let nextPlayer = playersData.first { $0.value["seat"] as? Int == nextSeat }
        return nextPlayer?.key ?? currentTurnPlayerId
    }
    
    func autoJoinOrCreateRoom(currentUserId: String, playerName: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let roomsRef = db.collection("rooms")

        // Fetch rooms with status "waiting"
        roomsRef.whereField("status", isEqualTo: "waiting").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching rooms: \(error)")
                completion(nil)
                return
            }

            let rooms = snapshot?.documents ?? []
            var joinableRoom: QueryDocumentSnapshot?

            // Prioritize rooms that are almost full (3 players → needs 1, then 2, etc.)
            let sortedRooms = rooms.sorted { lhs, rhs in
                let lhsPlayers = (lhs.data()["players"] as? [String: Any])?.count ?? 0
                let rhsPlayers = (rhs.data()["players"] as? [String: Any])?.count ?? 0
                return (4 - lhsPlayers) < (4 - rhsPlayers)  // Sort by how many players are missing
            }

            // Loop through sorted rooms to find one with available spots
            for room in sortedRooms {
                if let players = room.data()["players"] as? [String: Any], players.count < 4 {
                    joinableRoom = room
                    break
                }
            }

            // If a joinable room is found, attempt to join it
            if let room = joinableRoom {
                let roomId = room.documentID
                self.joinRoom(roomId: roomId, currentUserId: currentUserId, playerName: playerName) { success in
                    if success {
                        print("Joined existing room: \(roomId)")
                        completion(roomId)
                    } else {
                        print("Could not join room, creating a new one.")
                        // If join failed, create a new room
                        self.createRoom(currentUserId: currentUserId, name: playerName) { newRoomId in
                            completion(newRoomId)
                        }
                    }
                }
            } else {
                // No room found, create a new one
                print("No available room found. Creating a new room.")
                self.createRoom(currentUserId: currentUserId, name: playerName) { newRoomId in
                    completion(newRoomId)
                }
            }
        }
    }

}

