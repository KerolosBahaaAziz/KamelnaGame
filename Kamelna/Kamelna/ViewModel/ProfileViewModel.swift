//
//  ProfileViewModel.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//
import Foundation
class ProfileViewModel : ObservableObject{
    @Published var user : User?

    init(){
        setUser()
            
        
    }
    func setUser(){
        UserManager.shared.fetchUserByEmail(email: UserManager.shared.currentUserEmail ?? "") { user in
            self.user = user
        }

    }
    func updateUser(enumField : UserFireStoreAttributes , value: Any){
        guard let user=user else {return}
        UserManager.shared.updateUserData(user: user, enumField: enumField, value: value)
        setUser()
    }
    
    
}
