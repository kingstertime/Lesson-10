import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let loginStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        let authorizationVC = loginStoryboard.instantiateInitialViewController() as! AuthorizationViewController
        
        window?.rootViewController = authorizationVC
    }
}

