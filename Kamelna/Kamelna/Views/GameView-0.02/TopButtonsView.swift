//
//  TopButtonsView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 17/05/2025.
//

import SwiftUI

struct TopButtonsView: View {
    let usScore: Int
    let themScore: Int
    let roomNumber: String
    var body: some View {
        ZStack{
            SecondaryBackgroundGradient
                .backgroundGradient
                .ignoresSafeArea()
            HStack{
                iconButton(systemName: "ellipsis", label: "المزيد", action: {
                    print("المزيد")
                })
                iconButton(systemName: "speaker.wave.3.fill", label: "الصوت", action: {
                    print("الصوت")
                })
                // add here a text "لنا" "لهم" and below them the score and below the score the number of the room
                VStack(spacing: 4) {
                    HStack(spacing: 20) {
                        // Us (لنا)
                        VStack {
                            Text("لنا")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.caption)
                            Text("\(usScore)")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.subheadline)
                                .bold()
                                .background(.white)
                        }
                        // Them (لهم)
                        VStack {
                            Text("لهم")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.caption)
                            Text("\(themScore)")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.subheadline)
                                .bold()
                                .background(.white)
                        }
                    }
                    Text("غرفة: \(roomNumber)")
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .font(.caption2)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(20)
                iconButton(systemName: "square.and.arrow.up.fill", label: "المشاركة", action: {
                    print("المشاركة")
                })
                iconButton(systemName: "bubble.left.fill", label: "تعابير", action: {
                    print("تعابير")
                })
            }
        }
    }
    
    func iconButton(systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack{
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                Text("\(label)")
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .font(.caption)
            }
            .padding()
        }
        .background(ButtonBackGroundColor.backgroundGradient)
        .cornerRadius(20)
    }
}

#Preview {
    TopButtonsView(usScore: 100, themScore: 70, roomNumber: "567J5")
}
