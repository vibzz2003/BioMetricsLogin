
import Foundation

struct UserModel: Codable {
    let id: String
    let email: String
    let userName: String
    let fullName: String
    let hasBiometricsEnabled: Bool
    
    init(email: String, userName: String, fullName: String, hasBiometricsEnabled: Bool) {
        self.id = UUID().uuidString //that shi cause it has to be unique y'all
        self.email = email
        self.userName = userName
        self.fullName = fullName
        self.hasBiometricsEnabled = hasBiometricsEnabled
    }
}
