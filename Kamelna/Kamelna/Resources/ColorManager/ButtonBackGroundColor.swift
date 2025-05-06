//
//  ButtonBackGroundColor.swift
//  Kamelna
//
//  Created by Yasser Yasser on 06/05/2025.
//

import Foundation
import SwiftUICore

struct ButtonBackGroundColor {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 242/255, green: 192/255, blue: 120/255)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
