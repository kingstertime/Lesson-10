import Foundation
import UIKit

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
    //Авторизовывает пользователя, и возвращает access_token и id юзера
    func registerUser(login: String, password: String, complition: (String, String) -> ()) {
        
        let clientID = "3140623"
        let clientSecret = "VeWdmVclDCtn6ihuP1nt"
        
        let urlString = "https://oauth.vk.com/token?grant_type=password&client_id=\(clientID)&client_secret=\(clientSecret)&username=\(login)&password=\(password)&v=5.103&2fa_supported=0"
        
        print("URL: \(urlString)")
        
        if let url = URL(string: urlString) {
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    print(error?.localizedDescription as Any)
                    
                } else {
                    
                    guard let data = data else { return }
                    
                    guard let stringData = String(data: data, encoding: .utf8) else { return }
                    print("Data: \(stringData)")
                    
                    let authResponseModel = try! JSONDecoder().decode(AuthResponseModel.self, from: data)
                    
                    print("access_token: \(authResponseModel.access_token)")
                    print("user_id: \(authResponseModel.user_id)")
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.openURL(NSURL(string:"http://www.vk.com/id\(authResponseModel.user_id)")! as URL)
                    }
                }
            }
            
            task.resume()
        }
    }
}
