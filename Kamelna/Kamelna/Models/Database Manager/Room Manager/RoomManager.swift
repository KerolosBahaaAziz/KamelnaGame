//
//  RoomManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 30/04/2025.
//

import Foundation
import FirebaseFirestore

class RoomManager : ObservableObject{
    static let shared = RoomManager()
    @Published var listener: ListenerRegistration?
    @Published var messages: [Message] = []
    
    private init() {}
  
    func playCard(roomId: String, playerId: String, card: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)
        
        roomRef.getDocument { document, error in
            guard let document = document, document.exists,
                  var roomData = document.data(),
                  var players = roomData["players"] as? [String: [String: Any]],
                  var playerData = players[playerId],
                  var hand = playerData["hand"] as? [String] else {
                print("Error: Player or room not found")
                completion(false)
                return
            }
            
            // تحقق من أن الورقة موجودة في يد اللاعب
            guard hand.contains(card) else {
                print("Card not found in player's hand")
                completion(false)
                return
            }

            // إزالة الورقة من اليد
            hand.removeAll { $0 == card }
            playerData["hand"] = hand
            players[playerId] = playerData
            
            // أضف الورقة إلى currentTrick
            var currentTrick = roomData["currentTrick"] as? [String: Any] ?? [:]
            var cards = currentTrick["cards"] as? [[String: String]] ?? []
            cards.append(["playerId": playerId, "card": card])
            currentTrick["cards"] = cards
            
            
            // تحديث Firestore
            roomRef.updateData([
                "players": players,
                "currentTrick": currentTrick,
                "players.\(playerId).hand": hand
            ]) { error in
                if let error = error {
                    print("Error playing card: \(error)")
                    completion(false)
                } else {
                    self.advanceTurn(toNextPlayerIn: roomId)
                    print("Card \(card) played by player \(playerId)")
                    completion(true)
                    
                }
            }
        }
    }

    func getRoomInfo(roomId: String, completion: @escaping ([String: Any]?) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)
        
        roomRef.getDocument { document, error in
            if let error = error {
                print("Error fetching room info: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                print("Room not found")
                completion(nil)
                return
            }
            
            completion(document.data())
        }
    }

    func resetCurrentTrick(roomId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)
        
        roomRef.updateData([
            "currentTrick.cards": []
        ]) { error in
            if let error = error {
                print("Error resetting current trick: \(error)")
                completion(false)
            } else {
                print("Current trick reset successfully")
                completion(true)
            }
        }
    }

    func listenToRoom(roomId: String, onChange: @escaping ([String: Any]?) -> Void) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening to room: \(error)")
                onChange(nil)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("Room snapshot doesn't exist")
                onChange(nil)
                return
            }
            
            onChange(snapshot.data())
        }
    }

    func isPlayerTurn(roomId: String, playerId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomId).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let currentTurn = data["turnPlayerId"] as? String {
                print("currentTurn \(currentTurn)")
                completion(currentTurn == playerId)
            } else {
                completion(false)
            }
        }
    }

    func advanceTurn(toNextPlayerIn roomId: String) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomId).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let players = data["playerOrder"] as? [String],
                  let currentTurn = data["turnPlayerId"] as? String,
                  let index = players.firstIndex(of: currentTurn),
                  let currentInTrick = data["currentTrick"] as? [String: Any],
                  let cardsArray = currentInTrick["cards"] as? [[String: String]] ,
                  let index = players.firstIndex(of: currentTurn) else {
                      print("did not enter in advance turn function")
                return
            }
            
            if let cardsArray = currentInTrick["cards"] as? [[String: String]], cardsArray.count >= 4 {
                // Build a map: [playerId: card]
                var cardsInTrick: [String: String] = [:]
                for entry in cardsArray {
                    if let pid = entry["playerId"], let c = entry["card"] {
                        cardsInTrick[pid] = c
                    }
                }

                // End of trick
                RoomManager.shared.endRound(roomId: roomId, cardsInTrick: cardsInTrick, trumpSuit: .hearts)
                return
            }
            
            
            let nextIndex = (index + 1) % players.count
            let nextPlayer = players[nextIndex]
            print("now turn :\( players[nextIndex])")
            db.collection("rooms").document(roomId).updateData(["turnPlayerId": nextPlayer]){ error in
                if error == nil {
                    RoomManager.shared.checkIfIsBotTurn(roomId: roomId)
                }
            }
        }
    }

  
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
            "turnPlayerId": currentUserId, // لسه متبدأش اللعبة
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
            "playerOrder": [currentUserId],
            "history": [:] // ممكن نحط كل تريك بعد ما يخلص هنا
        ]
        
        roomRef.setData(roomData) { error in
            if let error = error {
                print("Error creating room: \(error)")
                completion(nil)
            } else {
                print("Room created with ID: \(roomId)")
                completion(roomId)
                RoomManager.shared.checkIfIsBotTurn(roomId: roomId)

            }
        }
    }
    
    func checkIfIsBotTurn(roomId: String) {
        let roomRef = Firestore.firestore().collection("rooms").document(roomId)

        roomRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let turnPlayerId = data["turnPlayerId"] as? String,
                  let players = data["players"] as? [String: [String: Any]],
                  let playerData = players[turnPlayerId],
                  let isBot = playerData["isBot"] as? Bool,
                  isBot else {
                return
            }

            print("It's bot \(turnPlayerId)'s turn. Triggering bot logic...")
            
            // Add small delay for realism
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                BotsManager.shared.playBotTurn(playerId: turnPlayerId, roomId: roomId)
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
            roomRef.updateData(["players": playersData, "playerOrder": FieldValue.arrayUnion([currentUserId])]) { error in
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

        guard let winnerPlayerId = calculateTrickWinner(cardsInTrick: cardsInTrick, trumpSuit: trumpSuit) else {
            print("Could not determine trick winner.")
            return
        }
        print("player win is: \(winnerPlayerId)")
        
        roomRef.getDocument { document, error in
            guard let doc = document, doc.exists,
                  var playersData = doc.data()?["players"] as? [String: [String: Any]],
                  var teamScores = doc.data()?["teamScores"] as? [String: Int],
                  let round = doc.data()?["roundNumber"] as? Int else {
                return
            }

            let winningTeam = self.getWinningTeam(playerId: winnerPlayerId, playersData: playersData)

            if winningTeam == "team1" {
                teamScores["team1"] = (teamScores["team1"] ?? 0) + 10
            } else {
                teamScores["team2"] = (teamScores["team2"] ?? 0) + 10
            }

            roomRef.updateData([
                "turnPlayerId": winnerPlayerId,
                "currentTrick": ["cards": [:]],
                "roundNumber": round + 1,
                "teamScores": teamScores
            ]) { error in
                if error == nil {
                    print("Trick ended. Round \(round + 1) started. Winner: \(winnerPlayerId)")
                    RoomManager.shared.checkIfIsBotTurn(roomId: roomId)
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
    
    func sendMessage(roomId: String, text: String, senderId: String, senderName: String, completion: (() -> Void)? = nil) {
        let db = Firestore.firestore()
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let messageData: [String: Any] = [
            "senderId": senderId,
            "senderName": senderName,
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
                    print("Message sent.")
                    completion?()
                }
            }
    }
    
    
    func listenToMessages(roomId: String, onReady: (() -> Void)? = nil) {
        let db = Firestore.firestore()
        listener?.remove()
        guard !roomId.isEmpty else { return }

        listener = db.collection("rooms")
            .document(roomId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                guard let documents = snapshot?.documents else {
                    print("No messages or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.messages = documents.compactMap { doc -> Message? in
                    let data = doc.data()
                    guard let senderId = data["senderId"] as? String,
                          let senderName = data["senderName"] as? String,
                          let text = data["message"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
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

                onReady?()
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
}

