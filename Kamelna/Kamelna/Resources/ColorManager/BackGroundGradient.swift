//
//  BackGroundGradient.swift
//  Kamelna
//
//  Created by Yasser Yasser on 05/05/2025.
//

import Foundation
import SwiftUICore

struct BackgroundGradient {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            //            Color(red: 62/255, green: 43/255, blue: 27/255),   // #3E2B1B
            //            Color(red: 92/255, green: 60/255, blue: 38/255),   // #5C3C26
            //            Color(red: 245/255, green: 224/255, blue: 195/255) // #F5E0C3
            Color(red: 165/255, green: 90/255, blue: 42/255),  // #A55A2A
            Color(red: 122/255, green: 62/255, blue: 28/255)   // #7A3E1C
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
