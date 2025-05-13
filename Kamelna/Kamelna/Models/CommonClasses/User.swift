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
   

}
