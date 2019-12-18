import Foundation
import UIKit

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
    //TODO: Отвратительно, переделать
    var userID: Int!
    var access_token: String!
    
    func getProfileInfo(userID: String, complition: @escaping (ProfileInfo?, Error?) -> Void ) {
        
        let methodName = "users.get"
        let params = "user_ids=\(userID)&fields=online,sex,bdate,city,photo_200"
        let urlString = "https://api.vk.com/method/\(methodName)?\(params)&access_token=\(access_token!)&v=5.103"
        
        if let url = URL(string: urlString) {
        
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    complition(nil, error)
                    
                } else {
                    
                    guard let data = data else { return }
                    
                    let profileInfoModel = try! JSONDecoder().decode(ProfileInfo.self, from: data)
                    complition(profileInfoModel, nil)
                }
            }
            task.resume()
        }
    }
    
    //Авторизовывает пользователя, и возвращает access_token и id юзера
    func registerUser(login: String, password: String, complition: @escaping (AuthResponseModel?, Error?) -> ()) {
        
        let clientID = "3140623"
        let clientSecret = "VeWdmVclDCtn6ihuP1nt"
        
        let urlString = "https://oauth.vk.com/token?grant_type=password&client_id=\(clientID)&client_secret=\(clientSecret)&username=\(login)&password=\(password)&v=5.103&2fa_supported=0"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    complition(nil, error)
                    
                } else {
                    
                    guard let data = data else { return }
                    
                    let authResponseModel = try! JSONDecoder().decode(AuthResponseModel.self, from: data)
                    
                    //
                    self.access_token = authResponseModel.access_token
                    self.userID = authResponseModel.user_id
                    //
                    
                    complition(authResponseModel, nil)
                }
            }
            
            task.resume()
        }
    }
    
    func getImage(by stringURL: String, complition: @escaping (UIImage?, Error?) -> Void) {
        
        if let url = URL(string: stringURL) {
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    complition(nil, error)
                    
                } else {
                    
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else { return }
                    complition(image, nil)
                }
            }
            
            task.resume()
        }
    }
    
    func getPosts(complition: @escaping ([Post]?, Error?) -> Void) {
        
        let methodName = "wall.get"
        let params = "owner_id=\(userID!)&count=100&filter=all"
        let stringURL = "https://api.vk.com/method/\(methodName)?\(params)&access_token=\(access_token!)&v=5.103"
        
        if let url = URL(string: stringURL) {
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    complition(nil, error)
                    
                } else {
                    
                    guard let data = data else { return }
                    let userPosts = try! JSONDecoder().decode(UserPosts.self, from: data)
                    let formattedPosts = userPosts.response.items
                    
                    complition(formattedPosts, nil)
                }
            }
            
            task.resume()
        }
    }
    
    func getUserImage(for ownerID: String, complition: @escaping ([Post]?, Error?) -> Void) {
        
        let methodName = "wall.get"
        let params = "owner_id=\(ownerID)&count=100&filter=all"
        let stringURL = "https://api.vk.com/method/\(methodName)?\(params)&access_token=\(access_token!)&v=5.103"
        
        if let url = URL(string: stringURL) {
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    complition(nil, error)
                    
                } else {
                    
                    guard let data = data else { return }
                    let userPosts = try! JSONDecoder().decode(UserPosts.self, from: data)
                    let formattedPosts = userPosts.response.items
                    
                    complition(formattedPosts, nil)
                }
            }
            
            task.resume()
        }
    }
}
