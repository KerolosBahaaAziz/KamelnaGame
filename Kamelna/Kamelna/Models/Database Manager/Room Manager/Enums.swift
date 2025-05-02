//
//  Enums.swift
//  Kamelna
//
//  Created by Kerlos on 02/05/2025.
//

import Foundation


enum RoomStatus: String {
    case waiting, playing, ended
}

enum Suit: String, CaseIterable {
    case spades = "♠️"
    case hearts = "♥️"
    case clubs = "♣️"
    case diamonds = "♦️"
}
