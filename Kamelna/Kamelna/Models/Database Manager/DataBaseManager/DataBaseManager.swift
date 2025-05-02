//
//  DataBaseManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 30/04/2025.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

final class DataBaseManager {
    static let shared = DataBaseManager()
    
    private let database = Database.database(url: "https://kamelna-fd00f-default-rtdb.firebaseio.com").reference()
    
}

extension DataBaseManager {
    func userExists(with email : String , completion : @escaping (Bool)-> Void){
        
        let safeEmail = email.replacingOccurrences(of: ".", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapShot in
            guard snapShot.exists() else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func addUser(user : User){
        database.child(user.safeEmail).setValue([
            "firstName" : user.firstName,
            "lastName" : user.lastName,
        ])
    }
    
    func signOut(completion: @escaping (Bool, String) -> Void) {
        do {
            try Auth.auth().signOut()  // Firebase sign-out method
            UserDefaults.standard.set(false, forKey: "isLogin")
            print("✅ Successfully signed out.")
            completion(true, "Successfully signed out.")  // Success callback
        } catch let error {
            print("❌ Sign out failed: \(error.localizedDescription)")  // Print the error if sign-out fails
            completion(false, "Sign-out failed: \(error.localizedDescription)")  // Failure callback
        }
    }
    
}


struct User {
    let firstName : String
    let lastName : String
    let email : String
    var safeEmail : String {
        self.email.replacingOccurrences(of: ".", with: "-")
    }
}
