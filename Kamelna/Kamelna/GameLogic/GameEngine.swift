//
//  GameEngine.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import Foundation

class GameEngine : ObservableObject {
    // MARK: - Published Properties (UI will listen to changes)
    @Published var players: [Player] = []
    @Published var deck: [Card] = []
    @Published var tableCards: [PlayedCard] = [] // Cards played on the table
    @Published var currentPlayerIndex: Int = 0
    @Published var roundEnded: Bool = false
    
    // MARK: - Setup Functions
    
    func setupGame(playerNames: [String]) {
        players = playerNames.map { Player(name: $0, hand: []) }
        createAndShuffleDeck()
        dealCards()
        currentPlayerIndex = 0
        tableCards = []
        roundEnded = false
    }
    
    private func createAndShuffleDeck() {
        deck = []
        for suit in Card.Suit.allCases {
            for value in Card.CardValue.allCases {
                let card = Card(suit: suit, value: value)
                deck.append(card)
            }
        }
        deck.shuffle()
    }
    
    private func dealCards(cardsPerPlayer: Int = 13) {
        for _ in 0..<cardsPerPlayer {
            for i in 0..<players.count {
                if let card = deck.popLast() {
                    players[i].hand.append(card)
                }
            }
        }
    }
    
    // MARK: - Gameplay Functions
    
    func playCard(_ card: Card) {
        guard !roundEnded else { return }
        var currentPlayer = players[currentPlayerIndex]
        
        // Validate if the player has the card
        if let cardIndex = currentPlayer.hand.firstIndex(where: { $0.id == card.id }) {
            // Remove from hand
            let playedCard = PlayedCard(playerName: currentPlayer.name, card: card)
            tableCards.append(playedCard)
            currentPlayer.hand.remove(at: cardIndex)
            players[currentPlayerIndex] = currentPlayer // Update
            
            nextTurn()
        }
    }
    
    private func nextTurn() {
        // Check if round ends (all players played one card)
        if tableCards.count >= players.count {
            endRound()
        } else {
            currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        }
    }
    
    private func endRound() {
        roundEnded = true
        // You can add scoring logic here later
    }
    
    func resetRound() {
        tableCards = []
        roundEnded = false
        currentPlayerIndex = 0
    }
}

struct PlayedCard: Identifiable {
    let id = UUID()
    let playerName: String
    let card: Card
}
