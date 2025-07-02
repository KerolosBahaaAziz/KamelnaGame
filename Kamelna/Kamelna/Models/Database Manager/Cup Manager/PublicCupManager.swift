//
//  PublicCupManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 21/05/2025.
//

import Foundation
import FirebaseFirestore

class PublicCupManager {
    static let shared = PublicCupManager()
    private let db = Firestore.firestore()
    private let cupsCollection = "Public_Cups"
    
    private init() {}
    
    // Create a new cup in Firestore
    func createCup(_ cup: Cup, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let documentRef = db.collection(cupsCollection).document()
            try documentRef.setData(from: cup) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(documentRef.documentID))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // Fetch a single cup by ID
    func fetchCup(cupID: String, completion: @escaping (Result<Cup, Error>) -> Void) {
        db.collection(cupsCollection).document(cupID).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cup not found"])))
                return
            }
            
            do {
                let cup = try snapshot.data(as: Cup.self)
                completion(.success(cup))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Join a cup (e.g., add user to a participants array)
    func joinCup(cupID: String, participant: Participants, completion: @escaping (Result<Void, Error>) -> Void) {
        let cupRef = db.collection(cupsCollection).document(cupID)
        
        // Update the participants array in Firestore (assuming a participants field exists)
        do {
            let data = try Firestore.Encoder().encode(participant)
            cupRef.updateData([
                "participants": FieldValue.arrayUnion([data])
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // Fetch all cups (for listing purposes)
    func fetchAllCups(completion: @escaping (Result<[Cup], Error>) -> Void) -> ListenerRegistration {
        return db.collection(cupsCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Listener error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents received in snapshot")
                completion(.success([]))
                return
            }
            
            print("Received \(documents.count) documents")
            let cups = documents.compactMap { doc in
                do {
                    let cup = try doc.data(as: Cup.self)
                    print("Decoded cup: \(cup.name), participants: \(cup.participants.count)")
                    return cup
                } catch {
                    print("Failed to decode document \(doc.documentID): \(error)")
                    return nil
                }
            }
            
            print("Total cups decoded: \(cups.count)")
            completion(.success(cups))
        }
    }
    
    // not yet tested
    func leaveCup(cupID: String, participant: Participants, completion: @escaping (Result<Void, Error>) -> Void) {
        let cupRef = db.collection(cupsCollection).document(cupID)
        
        do {
            let data = try Firestore.Encoder().encode(participant)
            cupRef.updateData([
                "participants": FieldValue.arrayRemove([data])
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
