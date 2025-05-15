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
       
        UserManager.shared.fetchUserByEmail(email: UserManager.shared.currentUserEmail ?? "") { user in
            self.user = user
        }
    
        
    }
    
    
}
