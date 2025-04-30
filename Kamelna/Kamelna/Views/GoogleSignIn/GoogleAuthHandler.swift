//
//  GoogleAuthHandler.swift
//  RFOXIA
//
//  Created by Yasser Yasser on 22/04/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class GoogleAuthHandler {
    
    static let shared = GoogleAuthHandler()
    
    func signIn(presenting viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ No clientID found.")
            completion(false)
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                print("❌ Google sign-in failed: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ Missing Google token")
                completion(false)
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil, let result = authResult else {
                    print("❌ Firebase sign-in failed")
                    completion(false)
                    return
                }

                guard let email = result.user.email, let name = result.user.displayName else {
                    print("❌ Missing user info")
                    completion(false)
                    return
                }

                DataBaseManager.shared.userExists(with: email) { exists in
                    if !exists {
                        let components = name.components(separatedBy: " ")
                        guard components.count > 1 else {
                            print("❌ Couldn’t parse full name: \(name)")
                            return
                        }

                        let user = User(firstName: components[0],
                                        lastName: components[1],
                                        email: email)
                        DataBaseManager.shared.addUser(user: user)
                    }
                }

                print("✅ Signed in: \(email), \(name)")
                completion(true)
            }
        }
    }
}

