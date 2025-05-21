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
             ten = "10",
             jack = "J" ,
             queen = "Q",
             king = "K",
             ace = "A"
    }
}

extension Card {
    static func from(string: String) -> Card? {
        let valuePart = String(string.prefix { $0.isNumber || "JQKA".contains($0) })
        let suitPart = String(string.dropFirst(valuePart.count))

        guard let value = CardValue(rawValue: valuePart),
              let suit = Suit.allCases.first(where: { $0.rawValue == suitPart }) else {
            return nil
        }

        return Card(suit: suit, value: value)
    }

    func toString() -> String {
        return value.rawValue + suit.rawValue
    }
}

