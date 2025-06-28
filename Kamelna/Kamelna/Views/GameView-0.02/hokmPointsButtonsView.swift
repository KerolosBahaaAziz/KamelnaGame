//
//  hokmPointsButtonsView.swift
//  Kamelna
//
//  Created by Kerlos on 27/06/2025.
//

import SwiftUI

struct hokmPointsButtonsView: View {
    @StateObject private var viewModel = PointsChoicesViewModel.shared

    var body: some View {
        VStack {
            let columnCount = viewModel.availableChoices.count <= 3 ? viewModel.availableChoices.count : 2
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount)

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(viewModel.availableChoices, id: \.self) { title in
                    actionButton(title: title, action: {
                        viewModel.chooseOption(option: title)
                    })
                }
            }
            .padding(.vertical, 6)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -3)
        }
    }

    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        let isDisabled = title.contains("غير متاح")
        let cleanTitle = title.replacingOccurrences(of: " (غير متاح)", with: "")
        
        return Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            Text(cleanTitle)
                .font(.title3)
                .frame(minWidth: 110)
                .padding(.vertical, 4)
                .foregroundStyle(isDisabled ? AnyShapeStyle(Color.gray) : AnyShapeStyle(ButtonForeGroundColor.backgroundGradient))
                .background(isDisabled ? AnyShapeStyle(Color.gray) : AnyShapeStyle(ButtonForeGroundColor.backgroundGradient))
                .cornerRadius(10)
        }
        .disabled(isDisabled)
    }

}


#Preview {
    hokmPointsButtonsView()
}
