//
//  JoinToRoomView.swift
//  Kamelna
//
//  Created by Kerlos on 14/05/2025.
//

import SwiftUI

struct JoinToRoomView: View {
    @StateObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 20) {
            HeaderView()

            MainCardView()

            //ActionButtonsView()

            PlayersListView(players: viewModel.players)

            Spacer()
        }
        .padding()
        .background(BackgroundGradient.backgroundGradient)
    }
}


struct HeaderView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.white)
            }
            Spacer()
            Text("Party Time!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
}

struct MainCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🚌 اتوبيس كومبليت\n(لعبة الحروف) 😎")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("By Ayhm-Mahmoud")
                .foregroundColor(.purple)
                .fontWeight(.semibold)

            Text("17,079 Plays | 24 Questions")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("🚌 اتوبيس كومبليت (لعبة الحروف) /\nوممنوع التكرار 👻👻👻")
                .font(.body)

            VStack(spacing: 8) {
                Text("SHARE CODE")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("973 924")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.purple, lineWidth: 2))
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct PlayersListView: View {
    var players: [Player] // Make sure Player is Identifiable

    var body: some View {
        VStack(alignment: .leading) {
            Text("Waiting for Players...")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(players) { player in
                HStack {
                    Text( "👑 \(player.id)")
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.purple)
                }
                .padding()
                .background(Color.yellow.opacity(0.7))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}
