import Foundation
import SwiftUI
import Combine

class CupViewModel: ObservableObject {
    @Published var cups: [Cup] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let cupManager = PublicCupManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Create a new cup
    func createCup(name: String ,creatorName : String, settings: CupSettings, gameSettings: GameSettings, prize: CupPrize, creatorID: String) {
        isLoading = true
        errorMessage = nil
        
        let newCup = Cup(
            name: name,
            creatorID: creatorID,
            creatorName: creatorName,
            settings: settings,
            gameSettings: gameSettings,
            prize: prize
        )
        
        cupManager.createCup(newCup) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.fetchCups() // Refresh cup list after creation
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Fetch a single cup
    func fetchCup(cupID: String) {
        isLoading = true
        errorMessage = nil
        
        cupManager.fetchCup(cupID: cupID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let cup):
                    if let index = self?.cups.firstIndex(where: { $0.id == cup.id }) {
                        self?.cups[index] = cup
                    } else {
                        self?.cups.append(cup)
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Fetch all cups
    func fetchCups() {
        isLoading = true
        errorMessage = nil
        
        cupManager.fetchAllCups { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let cups):
                    self?.cups = cups
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
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
}
