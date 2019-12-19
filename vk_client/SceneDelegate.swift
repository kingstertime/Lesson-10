import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let lastUserData = UserDefaultsManager.shared.getLastUser() {
            
            let login = lastUserData.0
            let password = lastUserData.1
            RemoteDataManager.shared.registerUser(login: login, password: password) { authResponseModel, error in
                
                if error != nil {
                    return
                }
                
                if let authResponseModel = authResponseModel {
                    
                    let userID = String(authResponseModel.user_id)
                    RemoteDataManager.shared.getProfileInfo(userID: userID) { profileInfo, error in
                        
                        if error != nil {
                            return
                        }
                        if let profileInfo = profileInfo {
                            
                            DispatchQueue.main.async {
                                
                                let userPageStoryBoard = UIStoryboard(name: "UserPage", bundle: nil)
                                let navController = userPageStoryBoard.instantiateInitialViewController() as! UINavigationController
                                let userPageVC = navController.viewControllers.first! as! UserPageViewController
                                userPageVC.profileInfo = profileInfo
                                
                                UIApplication.setRootView(navController)
                            }
                        }
                    }
                }
            }
            
        } else {
            
            let loginStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
            let authorizationVC = loginStoryboard.instantiateInitialViewController() as! AuthorizationViewController
            
            window?.rootViewController = authorizationVC
        }
    }
}

