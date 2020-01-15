import Foundation

class ErrorManager {
    
    static func getError(errorResponse: ErrorResponse) -> Error {
        
        if errorResponse.error_type == "username_or_password_is_incorrect" {
            return AuthErrors.incorrectUser
        }
        
        return AuthErrors.unknownError
    }
}

enum AuthErrors: Error {
    
    case incorrectUser
    case unknownError
}

extension AuthErrors: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .incorrectUser:
            return NSLocalizedString("Неправильный логин или пароль", comment: "Invalid_Client")
            
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "Unknown_Error")
        }
    }
}
