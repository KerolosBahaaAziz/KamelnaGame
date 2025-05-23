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
            let rankCategory = RankCategory()
            var newRank = "مبتدئ"
            let sortedRanks = rankCategory.categories.sorted { $0.value < $1.value }
            for (rankName,threshold) in sortedRanks{
                if rankPoints > threshold{
                    newRank = rankName
                }
            }
           updateUser(enumField: .rank, value: newRank)
           updateUser(enumField: .rankPoints, value: rankPoints)
    }
    func updateFriendList(email : String){
        guard let user = user else{return}
        var friendList = user.friendList
        friendList.append(email)
        updateUser(enumField: .friendList, value: friendList)
        
    }
    // reason for the formula below is that the user doesnt start from 0 to the next rank , he has already an established rank , so we calculate from that point instead of userRankpoint/threshold
    func rankPercentage() -> CGFloat {
        let rankCategory = RankCategory()
        let sortedRanks = rankCategory.categories.sorted { $0.value < $1.value }

        guard let user = user else { return 0.0 }
        let currentPoints = CGFloat(user.rankPoints)

        // Get current rank threshold
        guard let currentIndex = sortedRanks.firstIndex(where: { $0.key == user.rank }) else {
            return 0.0
        }

        let currentThreshold = CGFloat(sortedRanks[currentIndex].value)

        // Handle "max rank" edge case: No next rank
        if currentIndex + 1 >= sortedRanks.count {
            return 1.0
        }

        let nextThreshold = CGFloat(sortedRanks[currentIndex + 1].value)

        // Avoid divide-by-zero
        let range = nextThreshold - currentThreshold
        guard range > 0 else { return 1.0 }

        // Calculate normalized percentage toward the next rank
        let progress = (currentPoints - currentThreshold) / range
        return min(max(progress, 0.0), 1.0) // Clamp between 0 and 1
    }

        
}
