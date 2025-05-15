
//
//  Player.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//
//
//  Player.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//


import Foundation

struct Player: Identifiable, Codable {
    var id: String
    var name: String
    var seat: Int
    var hand: [String]
    var team: Int
    var score: Int
    var isReady: Bool
}
