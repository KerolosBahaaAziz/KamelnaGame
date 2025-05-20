//
//  BottomButtonsView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 17/05/2025.
//

import SwiftUI

import SwiftUI

struct BottomButtonsView: View {
    let userName: String
    let status: String

    var body: some View {
        VStack(spacing: 10) {
            // User info and icons
            HStack(spacing: 10) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(userName)
                        .font(.body)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(SelectedButtonBackGroundColor.backgroundGradient)
                        .cornerRadius(10)
                    
                    Text(status)
                        .font(.caption)
                        .padding(6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)

                HStack(spacing: 10) {
                    iconButton(systemName: "gift.fill", label: "Send gift", action: {
                        print("gift clicked")
                    })
                    iconButton(systemName: "flame", label: "Fire action", action: {
                        print("fire clicked")
                    })
                }
            }
            .padding()
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(15)

            // Action buttons row
            HStack {
                actionButton(title: "بس", action: { print("بس clicked") })
                Spacer()
                actionButton(title: "حكم", action: { print("حكم clicked") })
                Spacer()
                actionButton(title: "صن", action: { print("صن clicked") })
            }
            .padding()
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -3)
            .offset(y :-20)
        }
//        .padding(.horizontal)
    }

    // MARK: - Reusable Button Views

    func iconButton(systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding()
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
        }
        .accessibilityLabel(label)
        .background(ButtonBackGroundColor.backgroundGradient)
        .cornerRadius(20)
    }

    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .frame(minWidth: 110)
                .padding(.vertical, 10)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(10)
        }
    }
}

#Preview {
    BottomButtonsView(userName: "Youssab", status: "جديد")
}
