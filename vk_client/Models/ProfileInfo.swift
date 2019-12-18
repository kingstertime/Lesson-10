import Foundation

struct ProfileInfo: Codable {
    
    var response: [Response]
}

struct Response: Codable {
    
    var photo_200: String
    var first_name: String
    var last_name: String
    var sex: Int
    var bdate: String
    var online: Int
    var city: City
}

///Helper struct for UserModel
struct Country: Codable {
    
    var id: Int
    var title: String
}

///Helper struct for UserModel
struct City: Codable {
    
    var id: Int
    var title: String
}

