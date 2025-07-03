//
//  PrizeSection.swift
//  Kamelna
//
//  Created by Yasser Yasser on 23/05/2025.
//

import SwiftUI

struct PrizeSection: View {
    @Binding var firstPlacePrize: String
    @Binding var secondPlacePrize: String
    @Binding var thirdPlacePrize: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Text("إعدادات الجوائز")
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            TextField("جائزة المركز الأول", text: $firstPlacePrize)
                .frame(height: 50)
                .background(.white)
                .cornerRadius(10)
                .keyboardType(.numberPad)
            TextField("جائزة المركز الثاني (اختياري)", text: $secondPlacePrize)
                .frame(height: 50)
                .background(.white)
                .cornerRadius(10)
                .keyboardType(.numberPad)
            TextField("جائزة المركز الثالث (اختياري)", text: $thirdPlacePrize)
                .frame(height: 50)
                .background(.white)
                .cornerRadius(10)
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    
    @Previewable @State var firstPlacePrize: String = ""
    @Previewable @State var secondPlacePrize: String = ""
    @Previewable @State var thirdPlacePrize: String = ""
    PrizeSection(firstPlacePrize: $firstPlacePrize, secondPlacePrize: $secondPlacePrize, thirdPlacePrize: $thirdPlacePrize)
}
