//
//  TextManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 01/06/2025.
//

import Foundation
import SwiftUICore

class TextManager {
    static func textFormater(_ text : String) -> some View {
        Text("\(text)")
            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            .padding(5)
            .background(ButtonBackGroundColor.backgroundGradient)
            .cornerRadius(10)
    }
}
