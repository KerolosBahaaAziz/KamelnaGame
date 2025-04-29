//
//  Player.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import Foundation

struct Player : Identifiable {
    let id = UUID()
    let name : String
    var hand : [Card]
    var score: Int = 0
}
