//
//  RoomManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 30/04/2025.
//

import Foundation
import FirebaseFirestore

class RoomManager {
    func createRoom(currentUserId: String, name: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let roomId = generateRoomCode()
        
        let roomRef = db.collection("rooms").document(roomId)
        
        let roomData: [String: Any] = [
            "hostId": currentUserId,
            "createdAt": FieldValue.serverTimestamp(),
            "status": "waiting", // ممكن تبقى: waiting / playing / ended
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
    
    func generateRoomCode(length: Int = 5) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
    
    func distributeCardsToPlayers(roomId: String, playersIds: [String], completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId)
        
        // قائمة الكروت الممكنة في البلوت
        let allCards = [
            "7♠️", "8♠️", "9♠️", "10♠️", "J♠️", "Q♠️", "K♠️", "A♠️",
            "7♥️", "8♥️", "9♥️", "10♥️", "J♥️", "Q♥️", "K♥️", "A♥️",
            "7♣️", "8♣️", "9♣️", "10♣️", "J♣️", "Q♣️", "K♣️", "A♣️",
            "7♦️", "8♦️", "9♦️", "10♦️", "J♦️", "Q♦️", "K♦️", "A♦️"
        ]
        
        // نخلط الكروت
        var shuffledCards = allCards.shuffled()
        
        // توزيع الكروت على اللاعبين
        var playerHands: [String: [String]] = [:]
        
        for playerId in playersIds {
            playerHands[playerId] = Array(shuffledCards.prefix(8)) // كل لاعب ياخد 8 كروت
            shuffledCards.removeFirst(8) // حذف الكروت اللي اتوزعت
        }
        
        // تحديث الـ Firestore
        var playersData: [String: [String: Any]] = [:]
        for (playerId, hand) in playerHands {
            playersData[playerId] = [
                "hand": hand
            ]
        }
        
        // تحديث كروت اللاعبين في قاعدة البيانات
        roomRef.updateData(["players": playersData]) { error in
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
    func calculateTrickWinner(cardsInTrick: [String: String], trumpSuit: String) -> String? {
        var highestCard: String = ""
        var highestCardValue: Int = 0
        var winnerPlayerId: String?
        
        for (playerId, card) in cardsInTrick {
            let cardValue = getCardPoints(card: card, trumpSuit: trumpSuit)
            
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
    func getCardPoints(card: String, trumpSuit: String) -> Int {
        let isTrump = isTrumpCard(card: card, trumpSuit: trumpSuit)
        
        if isTrump {
            // إذا كانت الورقة ترامب، نقوم بإعطائها قيمة أعلى
            return getCardValue(card: card) + 100  // نضيف 100 للنقاط لو الورقة ترامب
        } else {
            return getCardValue(card: card)
        }
    }
    
    // دالة للتحقق إذا كانت الورقة من نوع ترامب
    func isTrumpCard(card: String, trumpSuit: String) -> Bool {
        return card.contains(trumpSuit)
    }
    
    // دالة لحساب قيمة الورقة
    func getCardValue(card: String) -> Int {
        switch card {
        case "2", "3", "4", "5", "6", "7", "8", "9", "10":
            return Int(card) ?? 0
        case "J":
            return 11
        case "Q":
            return 12
        case "K":
            return 13
        case "A":
            return 14
        default:
            return 0
        }
    }
    
    // دالة لتحديث النقاط بعد انتهاء الجولة
    func endRound(roomId: String, cardsInTrick: [String: String], trumpSuit: String) {
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
                let winningTeam = strongSelf.getWinningTeam(playerId: winnerPlayerId)
                
                // إضافة النقاط للفريق الفائز
                if winningTeam == "team1" {
                    teamScores["team1"] = (teamScores["team1"] ?? 0) + 10  // مثال على إضافة 10 نقاط
                } else {
                    teamScores["team2"] = (teamScores["team2"] ?? 0) + 10  // مثال على إضافة 10 نقاط
                }
                
                // تحديث بيانات الغرفة
                roomRef.updateData([
                    "teamScores": teamScores,
                    "currentTurn": strongSelf.getNextTurn(currentTurn: document.data()?["currentTurn"] as! String)
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
    func getWinningTeam(playerId: String) -> String {
        // فرضاً نقول إن اللاعبين 1 و 2 في فريق والفريق الآخر 3 و 4
        if playerId == "player1" || playerId == "player2" {
            return "team1"
        } else {
            return "team2"
        }
    }
    
    // دالة لتحديد الدور التالي
    func getNextTurn(currentTurn: String) -> String {
        switch currentTurn {
        case "player1":
            return "player2"
        case "player2":
            return "player3"
        case "player3":
            return "player4"
        case "player4":
            return "player1"
        default:
            return "player1" // إذا كان الدور غير معروف، نبدأ من اللاعب الأول
        }
    }
}
