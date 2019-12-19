import Foundation

enum UserDefaultKeys {
    
    static let login = "login"
    static let password = "password"
}

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    func saveUser(login: String, password: String) {
        
        UserDefaults.standard.set(login, forKey: UserDefaultKeys.login)
        UserDefaults.standard.set(password, forKey: UserDefaultKeys.password)
    }
    
    func getLastUser() -> (String, String)? {
        
        guard let login = UserDefaults.standard.string(forKey: UserDefaultKeys.login) else { return nil }
        guard let password = UserDefaults.standard.string(forKey: UserDefaultKeys.password) else { return nil}
        
        return (login, password)
    }
    
    func removeLastUser() {
        
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.login)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.password)
    }
}
