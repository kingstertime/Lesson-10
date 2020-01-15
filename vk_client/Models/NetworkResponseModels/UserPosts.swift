import Foundation

struct UserPosts: Codable {
    
    var response: UserPostsResponse
}

struct UserPostsResponse: Codable {
    
    var count: Int
    var items: [Post]
    var profiles: [Profile]?
    var groups: [Groupe]?
}

struct Post: Codable {
    
    var id: Int
    var owner_id: Int
    var from_id: Int
    var date: Int           //В формате unixtime
    var text: String
    var likes: Likes
    var comments: Comments
    var	reposts: Reposts
    var views: Views
    var post_type: String
    var attachments: [Attachments]?
    var copy_history: [Post]?
}

struct Profile: Codable {
    
    var id: Int
    var first_name: String
    var last_name: String
    var photo_100: String
}

struct Groupe: Codable {
    
    var id: Int
    var name: String
    var photo_100: String
}

struct Attachments: Codable {
    
    var type: String
    var photo: Photo?
}

struct Photo: Codable {
    
    var id: Int
    var owner_id: Int
    var sizes: [Size]
}

struct Size: Codable {
    
    var type: String
    var url: String
    var width: Int
    var height: Int
}

struct Likes: Codable {
    
    var count: Int
    var user_likes: Int
    var can_like: Int
}

struct Comments: Codable {
    
    var count: Int
}

struct Reposts: Codable {
    
    var count: Int
}

struct Views: Codable {
    
    var count: Int
}
