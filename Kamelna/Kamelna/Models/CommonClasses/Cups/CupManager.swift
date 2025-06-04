//
//  CupManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 01/06/2025.
//

import Foundation

class CupManager {
    static func checkTime(_ time : Int) -> String{
        if time == 5 {
            return "rocket"
        }else if time == 10 {
            return "rabit"
        } else {
            return "turtle"
        }
    }
    
    static func checkGameType(_ type : String) ->String{
        if type == "لعب حر"{
            return "arrow"
        } else {
            return "leftarrow"
        }
    }
    static func checkNumberOfPlayers(_ number : Int) ->String{
        if number == 16 {
            return "16"
        } else if number == 32{
            return "32"
        } else {
            return "64"
        }
    }
    static func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    static func levelMapping(_ number : Int) -> String {
        switch number {
        case 1: return "مبتدئ"
        case 2: return "متوسط"
        case 3: return "متقدم"
        case 4: return "محترف"
        case 5: return "خبير"
        case 6: return "نابغه"
        default : return "مبتدئ"
        }
    }
}
