//
//  GameEngine.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import Foundation
import Combine

class GameEngine : ObservableObject {
    // MARK: - Published Properties (UI will listen to changes)
    @Published var players: [Player] = []
    @Published var deck: [Card] = []
    @Published var tableCards: [PlayedCard] = [] // Cards played on the table
    @Published var currentPlayerIndex: Int = 0
    @Published var roundEnded: Bool = false
    @Published var timeRemaning : Int = 10
    
    private var timer : AnyCancellable?
    // MARK: - Setup Functions
    
    func setupGame(playerNames: [String]) {
        players = playerNames.map { Player(name: $0, hand: []) }
        createAndShuffleDeck()
        dealCards(cardsPerPlayer: 52 / players.count)
        currentPlayerIndex = 0
        tableCards = []
        roundEnded = false
        startTurnTimer()
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
            SoundManager.shared.playSound(named: "flipcard.mp3")
            // Remove from hand
            let playedCard = PlayedCard(playerName: currentPlayer.name, card: card, playerIndex: currentPlayerIndex)
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
            stopTurnTimer()
        }else if players.allSatisfy({ $0.hand.isEmpty }){
            roundEnded = true
            stopTurnTimer()
            return
        }else {
            currentPlayerIndex = (currentPlayerIndex + 1) % players.count
            startTurnTimer()
        }
    }
    
    private func endRound() {
        roundEnded = true
        startTurnTimer()
        // You can add scoring logic here later
    }
    
    func resetRound() {
        tableCards = []
        roundEnded = false
        currentPlayerIndex = 0
        startTurnTimer()
    }
    
    func startTurnTimer(){
        stopTurnTimer() //just for protection
        timeRemaning = 10
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.tick()
            }
    }
    
    func stopTurnTimer(){
        timer?.cancel()
        timer = nil
    }
    
    private func tick(){
        guard timeRemaning > 0 else {
            timerDidFinish()
            return
        }
        timeRemaning -= 1
    }
    
    private func timerDidFinish(){
        stopTurnTimer()
        playRandomCard()
    }
    
    func playRandomCard(){
        let player = players[currentPlayerIndex]
        
        guard !player.hand.isEmpty else {
            // there is someLogic needed to be handled here
            return
        }
        if let randomCard = player.hand.randomElement() {
            playCard(randomCard)
        }
    }
    func cardPlayedByPlayer(index: Int) -> Card? {
        return tableCards.first(where: { $0.playerIndex == index })?.card
    }
}

struct PlayedCard: Identifiable {
    let id = UUID()
    let playerName: String
    let card: Card
    let playerIndex: Int
}
