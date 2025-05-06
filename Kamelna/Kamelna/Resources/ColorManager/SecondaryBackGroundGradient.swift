//
//  SecondaryBackGroundGradient.swift
//  Kamelna
//
//  Created by Yasser Yasser on 06/05/2025.
//

import Foundation
import SwiftUICore

struct SecondaryBackgroundGradient {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            //            Color(red: 62/255, green: 43/255, blue: 27/255),   // #3E2B1B
            //            Color(red: 92/255, green: 60/255, blue: 38/255),   // #5C3C26
            //            Color(red: 245/255, green: 224/255, blue: 195/255) // #F5E0C3
            Color(red: 217/255, green: 180/255, blue: 143/255),  // #D9B48F
            Color(red: 178/255, green: 133/255, blue: 88/255)    // #B28558
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
