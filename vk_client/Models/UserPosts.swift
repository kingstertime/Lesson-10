import Foundation

struct UserPosts: Codable {
    
    var response: UserPostsResponse
}

struct UserPostsResponse: Codable {
    
    var count: Int
    var items: [Post]
}

struct Post: Codable {
    
    var id: Int
    var from_id: Int
    var date: Int
    var text: String
    var likes: Likes
    var comments: Comments
    var	reposts: Reposts
    var views: Views
    var attachments: [Attachments]
}

struct Attachments: Codable {
    
    var type: String
    var photo: Photo
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
