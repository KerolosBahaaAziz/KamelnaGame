//
//  User.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 12/05/2025.
//

struct User {
    let firstName : String
    let lastName : String
    let email : String
    var profilePictureUrl: String?
    var safeEmail : String {
        self.email.replacingOccurrences(of: ".", with: "-")
    }
    var blackStars = 0
    var brief = ""
    var hearts = 0
    var rank = "مبتدئ"
    var rankPoints = 0
    var medal = 0
    var creationDate : String
    var docId : String?

}
enum UserFireStoreAttributes: String {
    case firstName = "First_name"
    case lastName = "Last_name"
    case email = "email"
    case profilePictureUrl = "ProfilePic"
    case blackStars = "Black_Stars"
    case brief = "Brief"
    case hearts = "Hearts"
    case rank = "Rank"
    case rankPoints = "Rank_Points"
    case medal = "medal"
    case creationDate = "creationDate"
}

