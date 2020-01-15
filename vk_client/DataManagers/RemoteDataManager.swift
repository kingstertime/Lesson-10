import Foundation
import UIKit

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
    //Поля заполнятся после выполнения метода registerUser
    private var userID: Int!
    private var access_token: String!
    
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
                    
                    if let authResponseModel = try? JSONDecoder().decode(AuthResponseModel.self, from: data) {
                        
                        self.access_token = authResponseModel.access_token
                        self.userID = authResponseModel.user_id
                        
                        complition(authResponseModel, nil)
                        
                    } else {
                        
                        guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                            print("Cannot decode errorResponse JSON")
                            return
                        }
                        let authError = ErrorManager.getError(errorResponse: errorResponse)
                        
                        complition(nil, authError)
                    }
                }
            }
            
            task.resume()
        }
    }
    
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
                    
                    guard let profileInfoModel = try? JSONDecoder().decode(ProfileInfo.self, from: data) else {
                        
                        if let errorStringResponse = String(data: data, encoding: .utf8) {
                            print(errorStringResponse)
                        }
                        return
                    }
                    complition(profileInfoModel, nil)
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
    
    func getUserPostsResponse(complition: @escaping (UserPostsResponse?, Error?) -> Void) {
        
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
                    
                    complition(userPosts.response, nil)
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
