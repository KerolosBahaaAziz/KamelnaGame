//
//  Room.swift
//  Kamelna
//
//  Created by Kerlos on 05/05/2025.
//

import Foundation

struct Room: Codable {
    var hostId: String
    var status: String
    var gameType: String
    var trumpSuit: String?
    var turnPlayerId: String?
    var roundNumber: Int
    var teamScores: [String: Int]
    var players: [String: Player]
    var currentTrick: [String: String]
    var trickWinner: String?
}
