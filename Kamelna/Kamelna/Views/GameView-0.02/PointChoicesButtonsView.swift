//
//  PointChoicesButtonsView.swift
//  Kamelna
//
//  Created by Kerlos on 21/06/2025.
//

import SwiftUI

struct PointChoicesButtonsView: View {
    @StateObject private var viewModel = PointsChoicesViewModel.shared
    
    let roundButtons = ["دبل" , "ثري" ,"فور" , "بس"]
    let roomId = UserDefaults.standard.string(forKey: "roomId")
    let userId = UserDefaults.standard.string(forKey: "userId")
    var ifAvailable: Bool = false
    
    var body: some View {
        VStack {
            let columnCount = roundButtons.count <= 3 ? roundButtons.count : 2
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount)
            
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(roundButtons, id: \.self) { title in
                    actionButton(title: title, action: {
                        viewModel.addDoubleCoice()
                    })
                    //.disabled(!(viewModel.currentSelector == viewModel.userId && !viewModel.roundTypeChosen))
                }
            }
            .padding(.vertical, 6)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -3)
        }
    }
    
    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .frame(minWidth: 110)
                .padding(.vertical, 4)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(10)
        }
    }

    
}

#Preview {
    PointChoicesButtonsView()
}
