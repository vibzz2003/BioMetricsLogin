

import Foundation

enum AuthError: Error, LocalizedError {
    
    case InvalidEmail
    case WeakPassword
    case InvalidInput
    case UserAlreadyExists
    case UserNotFound
    case IncorrectPassword
    case BiometricNotEnabled
    case BiometricAuthFailed
    case StorageError
    
    var errorDescription: String? {
        switch self {
        case .InvalidEmail:
            return "Please enter a valid email address"
        case .WeakPassword:
            return "Password must be at least 6 characters long"
        case .InvalidInput:
            return "Please fill in all required fields"
        case .UserAlreadyExists:
            return "An account with this email already exists"
        case .IncorrectPassword:
            return "Incorrect password"
        case .UserNotFound:
            return "No account found with this email"
        case .BiometricNotEnabled:
            return "Biometric authentication is not enabled"
        case .BiometricAuthFailed:
            return "Biometric authentication failed"
        case .StorageError:
            return "Failed to save user data"
        }
    }
}
