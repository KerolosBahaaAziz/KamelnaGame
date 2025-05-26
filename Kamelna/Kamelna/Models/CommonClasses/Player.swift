//
//  Player.swift
//  Kamelna
//
//  Created by Kerlos on 13/05/2025.
//

import Foundation

struct Player: Identifiable, Codable {
    var id: String?
    var name: String?
    var seat: Int?
    var hand: [String]
    var team: Int?
    var score: Int?
    var isReady: Bool?
    var email : String?
}

enum PlayerSeatPosition {
    case top, left, right
}
