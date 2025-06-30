//
//  ProfileViewModel.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 13/05/2025.
//
import Foundation
import UIKit
class UserViewModel : ObservableObject{
    @Published var user : User?
    @Published var friendList = [User]()
    @Published var sentList = [User]()
    @Published var recievedList = [User]()
    @Published var isUserLoaded = false
    
    
    init(){
        setUser()
        
        
    }
    func setUser(){
        UserManager.shared.fetchUserByEmail(email: UserManager.shared.currentUserEmail ?? "") { user in
            self.user = user
            self.setList()
            DispatchQueue.main.async {
                self.isUserLoaded = true
            }
        }
        
    }
    func setList(){
        if let user = user {
            user.friendList.forEach { friend in
                fetchUser(email: friend){user in
                    if let user = user{
                        self.friendList.append(user)
                    }
                }
            }
            user.sentFriendList.forEach { friend in
                fetchUser(email: friend){user in
                    if let user = user{
                        self.sentList.append(user)
                    }
                }
            }
            user.recievedFriendList.forEach { friend in
                fetchUser(email: friend){user in
                    if let user = user{
                        self.recievedList.append(user)
                    }
                }
            }
            
            
        }
    }
    func fetchUser(email: String ,completion: @escaping (User?) -> Void){
        UserManager.shared.fetchUserByEmail(email: email) { user in
            if let user = user{
                completion(user)
            }else{
                completion(nil)
            }
            
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
        //print (friendList.first)
        updateUser(enumField: .friendList, value: friendList)
        
    }
    func updateSentAndRecieveFriendsList(email : String){
        guard let user = user else{return}
        var sentFriendList = user.sentFriendList
        sentFriendList.append(email)
        // print (sentFriendList.first)
        updateUser(enumField: .sentFriendList, value: sentFriendList)
        UserManager.shared.fetchUserByEmail(email: email) { user in
            guard let user = user else {
                print(email)
                return}
            var tempRecieveList = user.recievedFriendList
            tempRecieveList.append(self.user?.email ?? "")
            UserManager.shared.updateUserData(user: user, enumField: .recievedFriendList, value: tempRecieveList)
            
        }
    }
    
    func updateHearts(email: String,isLike: Int){
        UserManager.shared.fetchUserByEmail(email: email) { user in
            guard let user = user else {
                print(email)
                return}
            let tempHearts = user.hearts + isLike
            UserManager.shared.updateUserData(user: user, enumField: .hearts, value: tempHearts)
            
        }
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
    func isFriend(email:String)->Bool{
        if (user?.friendList.first(where: {$0 == email})) != nil{
            return true
        } else{
            if (user?.sentFriendList.first(where: {$0 == email})) != nil{
                return true
            } else{
                return false
            }
        }
        
    }
    
    
}

