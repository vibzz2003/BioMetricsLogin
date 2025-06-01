
import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    private let userdefaults = UserDefaults.standard
    private let keychain = KeychainManager.shared
    
    private var currentUser: UserModel?
    
    private func IsValidEmail(email: String) -> Bool {
        let patternRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", patternRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func GetUserProfile() -> UserModel? {
        if let user = currentUser {
            return user
        }
        
        guard let email = userdefaults.string(forKey: "current_user_email"),
              let userData = keychain.Load(key: "user_\(email)") else {
            return nil
        }
            
        do {
            let user = try JSONDecoder().decode(UserModel.self, from: userData)
            self.currentUser = user
            return user
        } catch {
            return nil
        }
    }
    
    func IsLoggedIn() -> Bool {
        return currentUser != nil || GetUserProfile() != nil
    }
    
    func SignUp(email: String, password: String, username: String, fullName: String, enableBiometric: Bool, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        
        guard IsValidEmail(email: email) else {
            completion(.failure(.InvalidEmail))
            return
        }
        
        guard password.count >= 6 else {
            completion(.failure(.WeakPassword))
            return
        }
        
        guard !username.isEmpty, !fullName.isEmpty else {
            completion(.failure(.InvalidInput))
            return
        }
        
        if keychain.Load(key: "user_\(email)") != nil {
            completion(.failure(.UserAlreadyExists))
            return
        }
        
        let user = UserModel(email: email, userName: username, fullName: fullName, hasBiometricsEnabled: enableBiometric)
        
        guard let passWord = password.data(using: .utf8) else {
            return
        }
        
        do {
            let userData = try JSONEncoder().encode(user)
            _ = keychain.Save(key: "user_\(email)", value: userData)
            _ = keychain.Save(key: "password_\(email)", value: passWord)
            self.currentUser = user
            userdefaults.set(email, forKey: "current_user_email")
            completion(.success(user))
        } catch {
            completion(.failure(.StorageError))
        }
    }
    
    func SignIn(email: String, password: String, completion: @escaping(Result<UserModel, AuthError>) -> Void) {
        guard let userData = keychain.Load(key: "user_\(email)"),
              let passwordData = keychain.Load(key: "password_\(email)"),
              let passwordString = String(data: passwordData, encoding: .utf8) else {
            completion(.failure(.UserNotFound))
            return
        }
         
        guard password == passwordString else {
            completion(.failure(.IncorrectPassword))
            return
        }
        
        do {
            let user = try JSONDecoder().decode(UserModel.self, from: userData)
            self.currentUser = user
            userdefaults.set(email, forKey: "current_user_email")
            completion(.success(user))
        } catch {
            completion(.failure(.StorageError))
        }
    }
    
    func SignOut() {
        currentUser = nil
        userdefaults.removeObject(forKey: "current_user_email")
    }
    
    func SignInWithBiometrics(completion: @escaping(Result<UserModel, AuthError>) -> Void) {
        guard let email = userdefaults.string(forKey: "current_user_email"),
              let userData = keychain.Load(key: "user_\(email)"),
              let user = GetUserProfile(),
              user.hasBiometricsEnabled else {
            completion(.failure(.BiometricNotEnabled))
            return
        }
        
        BiometricClass.shared.AuthenticateUsingBiometrics() { success, error in
            if success {
                self.currentUser = user
                completion(.success(user))
            } else {
                completion(.failure(.BiometricAuthFailed))
            }
        }
    }
    
    func UpdateBiometricsSetting(biometricEnabled: Bool, completion: @escaping(Result<UserModel, AuthError>) -> Void) {
        guard var user = self.currentUser else {
            completion(.failure(.UserNotFound))
            return
        }
        
        let updatedUser = UserModel(email: user.email, userName: user.userName, fullName: user.fullName, hasBiometricsEnabled: biometricEnabled)
        
        do {
            let userData = try JSONEncoder().encode(updatedUser)
            _ = keychain.Save(key: "user_\(user.email)", value: userData)
            self.currentUser = updatedUser
            completion(.success(updatedUser))
        } catch {
            completion(.failure(.StorageError))
        }
    }
}
