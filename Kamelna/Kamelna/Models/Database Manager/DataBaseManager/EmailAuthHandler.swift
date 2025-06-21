//
//  EmailAuthHandler.swift
//  Kamelna
//
//  Created by Kerlos on 02/05/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class EmailAuthHandler{
    
    static let shared = EmailAuthHandler()
    
    func registerWithEmail(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool, String) -> Void) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let tempDate = formatter.string(from: Date())
        let userAdded = User(firstName: firstName,
                             lastName: lastName,
                             email: email,
                             creationDate: tempDate,id:"")
        // 1. Check if user already exists
        DataBaseManager.shared.userExists(with: email) { exists in
            if exists {
                // Uncomment to delete the user for debugging purposes
                DataBaseManager.shared.deleteUser(user: userAdded)
                let errorMessage = "❌ User already exists"
                print(errorMessage)
                completion(false, errorMessage)
                return
            }
            
            // 2. If not exists, create user
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    let errorMessage = "❌ Email registration failed: \(error.localizedDescription)"
                    print(errorMessage)
                    completion(false, errorMessage)
                    return
                }
                
                guard let user = authResult?.user else {
                    let errorMessage = "❌ No user returned after registration"
                    print(errorMessage)
                    completion(false, errorMessage)
                    return
                }
                
                // 3. Save user info to your database
                
                DataBaseManager.shared.addUser(user: userAdded)
                
                // 4. Send email verification
                user.sendEmailVerification { error in
                    if let error = error {
                        print("❌ Failed to send verification email: \(error.localizedDescription)")
                    } else {
                        print("✅ Verification email sent.")
                    }
                }
                completion(true, "✅ Welcome! Verification email sent.")
                print("✅ Registered with email: \(user.email ?? "Unknown")")
            }
        }
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let errorMessage = "❌ Email sign-in failed: \(error.localizedDescription)"
                print(errorMessage)
                completion(false, errorMessage)
                return
            }
    
            guard let user = authResult?.user else {
                let errorMessage = "❌ No user returned"
                print(errorMessage)
                completion(false, errorMessage)
                return
            }
            
            if user.isEmailVerified {

                print("✅ Signed in with email: \(user.email ?? "Unknown")")
                completion(true, "✅ Welcome")
                
                guard (authResult?.user.uid) != nil else {
                    completion(false, "User not found")
                    return
                }
                
                DataBaseManager.shared.userExists(with: email) { exists in
                    if exists {
                    }else{
                        print("already exist")
                    }
                }
                
                // Check if user is subscribed
               /* SubscriptionHandler.shared.checkSubscriptionStatus(safeEmail: user.email ?? "") { isSubscribed in
                    if isSubscribed {
                        print("✅ User is subscribed.")
                        //completion(true, "you subscribed")
                        UserDefaults.standard.set(true, forKey: "isSubscribed")
                    } else {
                        print("❌ User is not subscribed.")
                        //completion(true, "Please subscribe to continue.")
                        UserDefaults.standard.set(false, forKey: "isSubscribed")
                    }
                }*/
            } else {
                print("⚠️ Email is NOT verified")
                UserDefaults.standard.set(false, forKey: "isLogin")
                completion(false, "⚠️ Please verify your email address before signing in.")
            }
        }
    }
    
    
}


