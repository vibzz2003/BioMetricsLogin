
enum BiometricType {
    case Touch
    case Face
    case None
    
    var displayName: String { // cant keep computed properties as enums should not have stored properties, also why cant use Self???
        // cause here Self refers to the type - got it
        switch self {
        case .Face:
            return "Face ID"
        case .Touch:
            return "Touch ID"
        case .None:
            return "None"
        }
    }
    
    var icon: String {
        switch self {
        case .Face:
            return "faceid"
        case .Touch:
            return "touchid"
        case .None:
            return "person.crop.circle"
        }
    }
}
