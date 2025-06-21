//
//  Enums.swift
//  Kamelna
//
//  Created by Kerlos on 02/05/2025.
//

import Foundation


enum RoomStatus: String {
    case waiting,started, playing, ended
}

enum Suit: String, CaseIterable, Codable {
    case spades = "♠️"
    case hearts = "♥️"
    case clubs = "♣️"
    case diamonds = "♦️"
}

enum ProjectTypes: String {
    case fourHundred = "fourHundred"
    case hundred = "hundred"
    case fifty = "fifty"
    case sra = "sra"
    
    var priority: Int {
        switch self {
        case .fourHundred: return 4
        case .hundred:     return 3
        case .fifty:       return 2
        case .sra:         return 1
        }
    }
}
