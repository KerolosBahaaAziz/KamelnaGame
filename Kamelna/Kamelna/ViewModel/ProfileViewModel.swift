//
//  ProfileViewModel.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//
import Foundation
import UIKit
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
    func genrerateUrlImage(image:UIImage){
        UserManager.shared.generateUrlImage(image) { result in
            switch result {
                case .success(let urlString):
                self.updateUser(enumField: .profilePictureUrl, value: urlString)
                case .failure(let error):
                    print("Error uploading image: \(error)")
                }
        }
    }
    func updateRank(earnedPoint: Int){
        guard var rankPoints=user?.rankPoints else{ return}
        rankPoints += earnedPoint
        switch (rankPoints){
        case 0...999:
            updateUser(enumField: .rank, value: "مبتدئ")
        case 1000...2999:
            updateUser(enumField: .rank, value: "جيد")
        case 3000...7999:
            updateUser(enumField: .rank, value: "لعيب")
        case 8000...15999:
            updateUser(enumField: .rank, value: "خبره")
        case 16000...:
            updateUser(enumField: .rank, value: "نادر")
        default:
            updateUser(enumField: .rank, value: "مبتدئ")
            
        }
       updateUser(enumField: .rankPoints, value: rankPoints)
    }
    
}
