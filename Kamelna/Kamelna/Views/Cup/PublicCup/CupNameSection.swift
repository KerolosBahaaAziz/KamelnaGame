//
//  CupNameSection.swift
//  Kamelna
//
//  Created by Yasser Yasser on 23/05/2025.
//

import SwiftUI

struct CupNameSection: View {
    @Binding var cupName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("اسم الدوري")
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            TextField("اسم الدوري", text: $cupName)
                .frame(height: 50)
                .background(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    @Previewable @State var cupName = "helo"
    CupNameSection(cupName: $cupName)
}
