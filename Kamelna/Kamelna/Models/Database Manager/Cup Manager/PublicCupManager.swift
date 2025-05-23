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
    func joinCup(cupID: String, userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let cupRef = db.collection(cupsCollection).document(cupID)
        
        // Update the participants array in Firestore (assuming a participants field exists)
        cupRef.updateData([
            "participants": FieldValue.arrayUnion([userID])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Fetch all cups (for listing purposes)
    func fetchAllCups(completion: @escaping (Result<[Cup], Error>) -> Void) {
        db.collection(cupsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let cups = documents.compactMap { doc in
                try? doc.data(as: Cup.self)
            }
            completion(.success(cups))
        }
    }
}
