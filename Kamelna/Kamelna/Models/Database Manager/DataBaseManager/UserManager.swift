
import Foundation
import FirebaseCore
import FirebaseFirestore

class UserManager: ObservableObject {
    @Published var currentUser : User?
    private let db = Firestore.firestore()
    private let collection = "User_Data"

    static let shared = UserManager()

   

    
    func saveUser(user : User) {
       
            let userData: [String: Any] = [
                "First_name": user.firstName,
                "Last_name": user.lastName,
                "email": user.email,
                "ProfilePic": user.profilePictureUrl ?? "",
                "Black_Stars": user.blackStars,
                "Brief": user.brief,
                "Hearts": user.hearts,
                "Rank": user.rank,
                "Rank_Points": user.rankPoints
            ]
        
        db.collection(collection).addDocument(data: userData) { error in
            if let error = error {
                print("Error saving user: \(error.localizedDescription)")
            } else {
                print("User saved successfully.")
            }
        }
        
    }

}
