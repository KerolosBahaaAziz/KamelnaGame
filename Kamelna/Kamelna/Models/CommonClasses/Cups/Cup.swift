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
    var settings : CupSettings
    var gameSettings : GameSettings
    var prize : CupPrize
    var createdAt : Date
    var creatorID: String
}

struct CupSettings : Codable{
    var startImmediately : Bool
    var startDelay : Date?
    var numberOfTeams : Int
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
