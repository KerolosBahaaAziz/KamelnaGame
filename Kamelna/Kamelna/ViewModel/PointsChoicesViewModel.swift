//
//  PointsChoices.swift
//  Kamelna
//
//  Created by Kerlos on 21/06/2025.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Combine

class PointsChoicesViewModel: ObservableObject{
    static let shared = PointsChoicesViewModel()
    
    private init() {}
    
    let roomId = UserDefaults.standard.string(forKey: "roomId")
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    func addDoubleCoice(){
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId ?? "")

        // Get current user ID
        guard let userId = userId else { return }
        
        roomRef.updateData([
            "double": true
        ]) { error in
            if let error = error {
                print("Error recording بس candidate: \(error)")
            } else {
                print("\(userId) chose بس — deferring decision.")
            }
        }
    }
    
}
