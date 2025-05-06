//
//  SelectedButtonBackGroundColor.swift
//  Kamelna
//
//  Created by Yasser Yasser on 06/05/2025.
//

import Foundation
import SwiftUICore

struct SelectedButtonBackGroundColor {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 239/255, green: 169/255, blue: 74/255)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct UnSelectedButtonBackGroundColor {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 217/255, green: 180/255, blue: 143/255)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
