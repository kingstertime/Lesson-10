import Foundation
import UIKit

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
    func getProfileInfo(access_token: String, complition: @escaping (ProfileInfo?, Error?) -> Void ) {
        
        let methodName = "users.get"
        let params = "user_ids=63046388&fields=online,sex,bdate,city,photo_200"
        let urlString = "https://api.vk.com/method/\(methodName)?\(params)&access_token=\(access_token)&v=5.103"
        
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
                    complition(authResponseModel, nil)
                }
            }
            
            task.resume()
        }
    }
}
