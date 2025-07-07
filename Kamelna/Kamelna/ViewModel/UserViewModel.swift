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
    @Published var isLoading = true
    private var isFetching = false
    init(){
        setUser()
        
        
    }
    func setUser() {
            guard !isFetching else {
                print("Already fetching user, skipping...")
                return
            }
            isFetching = true
            isLoading = true
            print("Fetching user for email: \(UserManager.shared.currentUserEmail ?? "unknown")")
            UserManager.shared.fetchUserByEmail(email: UserManager.shared.currentUserEmail ?? "") { [weak self] user in
                guard let self = self else { return }
                self.user = user
                print("Fetched user: \(user?.email ?? "nil") with friendList: \(user?.friendList ?? [])")
                self.setList()
                self.isFetching = false
            }
        }
    func setList() {
            guard let user = user else {
                self.isLoading = false
                return
            }
            
            // Clear lists to prevent duplicates
            friendList.removeAll()
            sentList.removeAll()
            recievedList.removeAll()
            
            // Fetch all users in parallel
            let group = DispatchGroup()
            
            // Fetch friends
            user.friendList.forEach { email in
                group.enter()
                fetchUser(email: email) { user in
                    if let user = user {
                        DispatchQueue.main.async {
                            self.friendList.append(user)
                        }
                    }
                    group.leave()
                }
            }
            
            // Fetch sent requests
            user.sentFriendList.forEach { email in
                group.enter()
                fetchUser(email: email) { user in
                    if let user = user {
                        DispatchQueue.main.async {
                            self.sentList.append(user)
                        }
                    }
                    group.leave()
                }
            }
            
            // Fetch received requests
            user.recievedFriendList.forEach { email in
                group.enter()
                fetchUser(email: email) { user in
                    if let user = user {
                        DispatchQueue.main.async {
                            self.recievedList.append(user)
                        }
                    }
                    group.leave()
                }
            }
            
            // Set isLoading to false when all fetches are complete
            group.notify(queue: .main) {
                self.isLoading = false
            }
        }
    private func updateUser(enumField : UserFireStoreAttributes , value: Any){
        guard let user=user else {return}
        UserManager.shared.updateUserData(user: user, enumField: enumField, value: value)
        setUser()
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
  
    func updateBreif(brief : String){
        updateUser(enumField: .brief, value: brief)
    }
    func addCup(cupId: String){
        guard let user = user else { return }
        var tempCupIdList = user.cupIdList
        tempCupIdList.append(cupId)
        updateUser(enumField: .cupIdList, value: cupId )
    }
    func removeCup(cupId: String){
        guard let user = user else { return }
        var tempCupIdList = user.cupIdList
        tempCupIdList.removeAll(where: { $0 == cupId })
        updateUser(enumField: .cupIdList, value: cupId )
    }
    func updateImage(image:UIImage){
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
    
    func acceptFriendRequest(email: String) {
            guard let user = user else { return }
            var tempFriendList = user.friendList
            tempFriendList.append(email)
            var tempRecieveList = user.recievedFriendList
            tempRecieveList.removeAll(where: { $0 == email })
            
            // Update current user's data
            updateUser(enumField: .friendList, value: tempFriendList)
            updateUser(enumField: .recievedFriendList, value: tempRecieveList)
            
            // Update the other user's sentFriendList
            UserManager.shared.fetchUserByEmail(email: email) { user in
                guard let user = user else {
                    print("Failed to fetch user with email: \(email)")
                    return
                }
                var tempSentList = user.sentFriendList
                tempSentList.removeAll(where: { $0 == UserManager.shared.currentUserEmail ?? "" })
                UserManager.shared.updateUserData(user: user, enumField: .sentFriendList, value: tempSentList)
                
                // Add current user to the other user's friend list
                var otherUserFriendList = user.friendList
                otherUserFriendList.append(UserManager.shared.currentUserEmail ?? "")
                UserManager.shared.updateUserData(user: user, enumField: .friendList, value: otherUserFriendList)
            }
        }
    func cancelFriendRequest(email: String) {
            guard let user = user else { return }
            var tempRecieveList = user.recievedFriendList
            tempRecieveList.removeAll(where: { $0 == email })
            updateUser(enumField: .recievedFriendList, value: tempRecieveList)
            
            UserManager.shared.fetchUserByEmail(email: email) { user in
                guard let user = user else {
                    print("Failed to fetch user with email: \(email)")
                    return
                }
                var tempSentList = user.sentFriendList
                tempSentList.removeAll(where: { $0 == UserManager.shared.currentUserEmail ?? "" })
                UserManager.shared.updateUserData(user: user, enumField: .sentFriendList, value: tempSentList)
            }
        }
    func cancelSentRequest(email:String){
        guard let user = user else {return}
        var tempSentList = user.sentFriendList
        tempSentList.removeAll(where: {$0 == email})
        updateUser(enumField: .sentFriendList, value: tempSentList)
        UserManager.shared.fetchUserByEmail(email: email) { user in
            guard let user = user else {
                print("Failed to fetch user with email: \(email)")
                return
            }
            var tempRecievedList = user.recievedFriendList
            tempRecievedList.removeAll(where: { $0 == UserManager.shared.currentUserEmail ?? "" })
            UserManager.shared.updateUserData(user: user, enumField: .recievedFriendList, value: tempRecievedList)
        }
    }
    func sendFriendRequest(email: String) ->Bool {
            guard let user = user else { return false}
            var sentFriendList = user.sentFriendList
            var userFound = false
            
            
            UserManager.shared.fetchUserByEmail(email: email) {[weak self] user in
                guard let user = user else {
                    print("user doesnt exsist")
                    return
                }
                userFound.toggle()
                sentFriendList.append(email)
                self?.updateUser(enumField: .sentFriendList, value: sentFriendList)
                var tempRecieveList = user.recievedFriendList
                tempRecieveList.append(UserManager.shared.currentUserEmail ?? "")
                UserManager.shared.updateUserData(user: user, enumField: .recievedFriendList, value: tempRecieveList)
            }
        return userFound
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
    func unFriendUser(email: String){
        guard let user = user else {return}
        var tempFriendList = user.friendList
        tempFriendList.removeAll(where: {$0 == email})
        updateUser(enumField: .friendList, value: tempFriendList)
        UserManager.shared.fetchUserByEmail(email: email) { user in
            guard let user = user else {
                print("Failed to fetch user with email: \(email)")
                return
            }
            var tempFriendList = user.friendList
            tempFriendList.removeAll(where: { $0 == UserManager.shared.currentUserEmail ?? "" })
            UserManager.shared.updateUserData(user: user, enumField: .friendList, value: tempFriendList)
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
    func sortFriendsByRank()->[User]{
        var tempFriendList = friendList
        return tempFriendList.sorted {$0.rankPoints > $1.rankPoints}
        
        
    }

        
}

