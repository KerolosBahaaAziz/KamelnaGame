//
//  CardBackView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 02/05/2025.
//

import SwiftUI

struct CardBackView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.red)
            .frame(width: 60, height: 90)
            .overlay(Text("🂠").font(.largeTitle))
    }
}


#Preview {
    CardBackView()
}
