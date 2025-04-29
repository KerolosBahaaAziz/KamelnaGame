//
//  Card.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import Foundation

struct Card : Identifiable, Codable {
    var id = UUID()
    var suit: Suit
    var value: CardValue
    
    enum Suit : String, Codable, CaseIterable{
        case hearts = "♥️",
             diamonds = "♦️",
             clubs = "♣️",
             spades = "♠️"
    }
    
    enum CardValue : String, Codable, CaseIterable{
        case two = "2",
             three = "3",
             four = "4",
             five = "5",
             six = "6",
             seven = "7",
             eight = "8",
             nine = "9",
             jack = "J" ,
             queen = "Q",
             king = "K",
             ace = "A"
    }
}

