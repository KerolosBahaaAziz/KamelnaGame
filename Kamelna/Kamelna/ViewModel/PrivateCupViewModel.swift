//
//  PrivateCupViewModel.swift
//  Kamelna
//
//  Created by Yasser Yasser on 01/07/2025.
//

import Foundation
import Combine
import Firebase
import SwiftUICore

class PrivateCupViewModel : ObservableObject {
    @Published var cups: [Cup] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let cupManager = PrivateCupManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private var cupsListener: ListenerRegistration?
    
    
    
    func createCup(name: String ,creator : User, settings: CupSettings, gameSettings: GameSettings, prize: CupPrize ,onSuccess : @escaping (String)-> Void) {
        isLoading = true
        errorMessage = nil
        
        let newCup = Cup(
            name: name,
            creator: creator,
            settings: settings,
            gameSettings: gameSettings,
            prize: prize
        )
        guard let newCupID = newCup.id else {
            print("❌ Cup ID is nil")
            isLoading = false
            return
        }
        cupManager.createCup(newCup) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.isLoading = false
                switch result {
                case .success:
                    strongSelf.fetchCup(cupID: newCupID) // Refresh cup list after creation
                    onSuccess(newCupID)
                case .failure(let error):
                    strongSelf.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchCups() {
        isLoading = true
        errorMessage = nil
        guard cupsListener == nil else {
            print("Listener already active, skipping fetchCups")
            return
        }
        
        cupsListener = cupManager.fetchAllCups { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updatedCups):
                    self?.cups = updatedCups
                    print("Listener received \(updatedCups.count) cups") // Debug log
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchCup(cupID: String) {
        guard !cups.contains(where: { $0.id == cupID }) else { return }
        
        isLoading = true
        errorMessage = nil
        
        cupManager.fetchCup(cupID: cupID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let cup):
                    self?.cups.append(cup)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func stopListeningToCups() {
        cupsListener?.remove()
        cupsListener = nil
        isLoading = false
        errorMessage = nil
    }
    
    // Join a cup
    func joinCup(cupID: String, participant: Participants) {
        isLoading = true
        errorMessage = nil
        
        if checkIfParticipantIsAlreadyInCup(participant, in: cupID) {
            self.isLoading = false
            self.errorMessage = "You are already in this cup."
            return
        }
        
        cupManager.joinCup(cupID: cupID, participant: participant) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.fetchCup(cupID: cupID) // Refresh the cup data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func checkIfParticipantIsAlreadyInCup(_ participant: Participants, in cupID: String) -> Bool {
        guard let cup = cups.first(where: { $0.id == cupID }) else {
            return false
        }
        
        return cup.participants.contains(where: { $0.participantID == participant.participantID })
    }
    deinit {
        stopListeningToCups()
    }
    
    // not yet tested
    func leaveCup(cupID: String, participant: Participants) {
        isLoading = true
        errorMessage = nil
        
        cupManager.leaveCup(cupID: cupID, participant: participant) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.fetchCup(cupID: cupID)// Refresh the cup data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
