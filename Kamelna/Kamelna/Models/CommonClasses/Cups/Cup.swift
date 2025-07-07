//
//  Cup.swift
//  Kamelna
//
//  Created by Yasser Yasser on 21/05/2025.
//

import Foundation
import FirebaseFirestore


struct Cup : Identifiable, Codable{
    @DocumentID var id : String? = UUID().uuidString
    var name : String
    var creator : User
    var settings : CupSettings
    var gameSettings : GameSettings
    var prize : CupPrize
    var createdAt : Date
    var participants : [Participants]
    
    init(name: String, creator : User,
         settings: CupSettings, gameSettings: GameSettings, prize: CupPrize ) {
        self.name = name
        self.creator = creator
        self.settings = settings
        self.gameSettings = gameSettings
        self.prize = prize
        self.createdAt = Date()
        // First participant is the creator
        let creatorParticipant = Participants(participantID: creator.id ?? UUID().uuidString,
                                              name: creator.firstName,
                                              teamNumber: 1,
                                              level: creator.rankPoints,
                                              image : creator.profilePictureUrl ?? "")
        self.participants = [creatorParticipant]
    }
}

struct CupSettings : Codable{
    var startImmediately : Bool
    var startDelay : Date?
    var numberOfPlayers : Int
    var matchType : String
}

struct GameSettings : Codable{
    var gameType : String
    var innerGameTimerSeconds : Int
    var minLevelRequired : Int
}

struct CupPrize : Codable{
    var firstPlace : Int
    var secondPlace : Int?
    var thirdPlace : Int?
}

struct Participants : Codable{
    var participantID : String
    var name : String
    var teamNumber : Int
    var level : Int
    var image : String
}
