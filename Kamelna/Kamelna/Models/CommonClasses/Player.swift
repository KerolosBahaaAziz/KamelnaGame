
import Foundation

struct Player: Identifiable, Codable {
    var id: String
    var name: String
    var seat: Int
    var hand: [String]
    var team: Int
    var score: Int
    var isReady: Bool
}
