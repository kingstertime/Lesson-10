import Foundation

struct ErrorResponse: Codable {
    
    var error: String
    var error_type: String
    var error_description: String
}
