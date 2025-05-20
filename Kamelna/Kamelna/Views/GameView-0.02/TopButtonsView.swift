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
        NavigationStack{
            HStack{
                iconButton(systemName: "ellipsis", label: "المزيد", action: {
                    print("المزيد")
                })
                iconButton(systemName: "speaker.wave.3.fill", label: "الصوت", action: {
                    print("الصوت")
                })
                // add here a text "لنا" "لهم" and below them the score and below the score the number of the room
                VStack(spacing: 4) {
                    HStack(spacing: 10) {
                        // Us (لنا)
                        VStack {
                            Text("لنا")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.caption)
                            Text("\(usScore)")
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal, 4) // Increased horizontal padding
                                .padding(.vertical, 4)
                                .background(SelectedButtonBackGroundColor.backgroundGradient)
                                .cornerRadius(10) // Rounded corners
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
                                .padding(.horizontal, 4) // Increased horizontal padding
                                .padding(.vertical, 4)
                                .background(SelectedButtonBackGroundColor.backgroundGradient)
                                .cornerRadius(10) // Rounded corners
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
                NavigationLink(destination: RoomChatView(roomId: roomNumber)) {
                    VStack {
                        Image(systemName: "bubble.left.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        Text("تعابير")
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .font(.caption)
                    }
                    .padding()
                    .background(ButtonBackGroundColor.backgroundGradient)
                    .cornerRadius(20)
                }
            }
            .padding(5)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -3)
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
    TopButtonsView(usScore: 12, themScore: 900, roomNumber: "567J5")
}
