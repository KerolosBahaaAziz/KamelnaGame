import SwiftUI

struct GameSceneView: View {
    @StateObject private var viewModel: GameViewModel
    @State private var showTurnMessage = false
    
    init(roomId: String, playerId: String) {
        _viewModel = StateObject(wrappedValue: GameViewModel(roomId: roomId, playerId: playerId))
    }
    
    var currentPlayer: Player? {
        guard let roomData = viewModel.roomData,
              let players = roomData["players"] as? [String: [String: Any]],
              let playerData = players[viewModel.playerId] else {
            print("Error: Failed to load current player data")
            return nil
        }
        
        return Player(
            id: viewModel.playerId,
            name: playerData["name"] as? String ?? "Unknown",
            seat: playerData["seat"] as? Int ?? 0,
            hand: playerData["hand"] as? [String] ?? [],
            team: playerData["team"] as? Int ?? 0,
            score: playerData["score"] as? Int ?? 0,
            isReady: playerData["isReady"] as? Bool ?? false
        )
    }
    
    var otherPlayers: [Player] {
        guard let roomData = viewModel.roomData,
              let players = roomData["players"] as? [String: [String: Any]] else {
            print("Error: roomData is  nil), players not found or invalid")
            return []
        }
        print("Players data : \(players)")
        return players.compactMap { playerId, data in
            guard playerId != viewModel.playerId else { return nil }
            return Player(
                id: playerId,
                name: data["name"] as? String ?? "Unknown",
                seat: data["seat"] as? Int ?? 0,
                hand: data["hand"] as? [String] ?? [],
                team: data["team"] as? Int ?? 0,
                score: data["score"] as? Int ?? 0,
                isReady: data["isReady"] as? Bool ?? false
            )
        }
    }
    
    var playedCards: [String: Card] {
        guard let trick = viewModel.roomData?["currentTrick"] as? [String: Any],
              let cards = trick["cards"] as? [[String: String]] else {
            return [:]
        }
        
        var result: [String: Card] = [:]
        for cardData in cards {
            if let playerId = cardData["playerId"],
               let cardString = cardData["card"],
               let card = Card.from(string: cardString) {
                result[playerId] = card
            }
        }
        return result
    }
    
    var body: some View {
        ZStack {
            if let currentPlayer = currentPlayer {
                TableView(
                    currentPlayer: currentPlayer,
                    otherPlayers: otherPlayers,
                    playedCards: playedCards,
                    playCard: { card in
                        if viewModel.isMyTurn {
                            viewModel.playCard(card: card)
                        } else {
                            showTurnMessage = true
                        }
                    },
                    currentTurnPlayerId: "youssab"
                )
                
                if !viewModel.isMyTurn {
                    Text("ليس دورك")
                        .font(.title2)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .opacity(showTurnMessage ? 1 : 0)
                        .animation(.easeInOut, value: showTurnMessage)
                        .onAppear {
                            if showTurnMessage {
                                withAnimation(.easeInOut){
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showTurnMessage = false
                                    }
                                }
                            }
                        }
                }
            } else {
                ProgressView("جاري تحميل بيانات اللعبة...")
            }
        }
        .onAppear {
            viewModel.startListeningForRoomUpdates()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameSceneView(roomId: "YOJWLQ", playerId: "IVV3Xu3XKodrbweHBTHD7V6CL6s1")
}
