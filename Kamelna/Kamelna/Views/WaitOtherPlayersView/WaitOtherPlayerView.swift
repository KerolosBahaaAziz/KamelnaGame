//
//  JoinToRoomView.swift
//  Kamelna
//
//  Created by Kerlos on 14/05/2025.
//

import SwiftUI

struct WaitOtherPlayersView: View {
    @StateObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 20) {
            HeaderView()

            MainCardView()

            PlayersListView(players: viewModel.players)

            Spacer()
            
            
            StartGameButton(isEnabled: viewModel.players.count == 4) {
                // Put your game start logic here
                print("Game started!")
            }

        }
        .padding()
        .background(BackgroundGradient.backgroundGradient)
    }
}


