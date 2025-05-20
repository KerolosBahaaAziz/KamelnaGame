
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Cloudinary
final class UserManager{
    let currentUserEmail = Auth.auth().currentUser?.email
    let creationDate = Auth.auth().currentUser?.metadata.creationDate
    private let db = Firestore.firestore()
    private let collection = "User_Data"
    private let cloudinary: CLDCloudinary
    static let shared = UserManager()
   // static var currentUserDocId : String?
    
    private init(){
         let config = CLDConfiguration(cloudName: "dohnxmenv", secure: true)
         cloudinary = CLDCloudinary(configuration: config)
    }
    func parseUserDocument(_ document: DocumentSnapshot) -> User? {
        let data = document.data() ?? [:]
        
        guard let firstName = data["First_name"] as? String,
              let lastName = data["Last_name"] as? String,
              let email = data["email"] as? String else {
            print("Missing required fields")
            return nil
        }
        
        let profilePic = data["ProfilePic"] as? String
        let blackStars = data["Black_Stars"] as? Int ?? 0
        let brief = data["Brief"] as? String ?? ""
        let hearts = data["Hearts"] as? Int ?? 0
        let rank = data["Rank"] as? String ?? "مبتدئ"
        let rankPoints = data["Rank_Points"] as? Int ?? 0
        let medal = data["medal"] as? Int ?? 0
        let creationDate = data["creationDate"] as? String ?? ""
        return User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            profilePictureUrl: profilePic,
            blackStars: blackStars,
            brief: brief,
            hearts: hearts,
            rank: rank,
            rankPoints: rankPoints,medal: medal,creationDate: creationDate , docId : document.documentID)
    }
    
    func fetchUserByEmail(email: String, completion: @escaping (User?) -> Void) {
        let db = Firestore.firestore()
        db.collection(collection).whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error querying documents: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No user found with that email.")
                    
                    completion(nil)
                    return
                }
                
                let user = self.parseUserDocument(document)
                
                completion(user)
            }
    }
   // func fetchUserDocId()
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
            "Rank_Points": user.rankPoints ,
            "medal":user.medal,
            "creationDate":user.creationDate]
        
        db.collection(collection).addDocument(data: userData) { error in
            if let error = error {
                print("Error saving user: \(error.localizedDescription)")
            } else {
                print("User saved successfully.")
            }
        }
        
    }
    
    func userDocumentRef(for user: User) -> DocumentReference {
        
        return db.collection(collection).document(user.docId ?? "")
    }
    // remeber to add type check in the function in the future
    func updateUserData(user: User, enumField: UserFireStoreAttributes,value: Any){
      
        userDocumentRef(for: user).updateData([enumField.rawValue : value]){ error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
            } else {
                print("User updated with: \(value)")
            }
        }
    }
    func generateUrlImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
           guard let imageData = image.jpegData(compressionQuality: 0.8) else {
               completion(.failure(NSError(domain: "Invalid Image", code: 0, userInfo: nil)))
               return
           }

           let params = CLDUploadRequestParams().setUploadPreset("Kamelena")

           cloudinary.createUploader().upload(data: imageData, uploadPreset: "Kamelena", params: params)
               .response { result, error in
                   if let error = error {
                       completion(.failure(error))
                   } else if let url = result?.secureUrl {
                       completion(.success(url))
                   } else {
                       completion(.failure(NSError(domain: "Upload failed", code: 0, userInfo: nil)))
                   }
               }
       }
    
    
    
    
}
