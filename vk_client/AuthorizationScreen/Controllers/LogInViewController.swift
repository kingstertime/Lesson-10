import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: CustomButton!
    
    let remoteDM = RemoteDataManager.shared
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let login = loginTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //Авторизовываем пользователя и получаем его токен и ID страницы
        remoteDM.registerUser(login: login, password: password) { authResponseModel, error in
            
            if error != nil {
                
                DispatchQueue.main.async {
                    AlertService.presentInfoAlert(on: self, title: "Error", message: error!.localizedDescription)
                    return
                }
            }
            
            if let authResponseModel = authResponseModel {
                
                let userID = String(authResponseModel.user_id)
                
                //После получения токена, получаем модель данных страницы пользователя
                self.remoteDM.getProfileInfo(userID: userID) { profileInfo, error in
                    
                    if let error = error {
                        AlertService.presentInfoAlert(on: self, title: "Error", message: error.localizedDescription)
                        return
                    }
                    
                    //Получаем данные профиля
                    if let profileInfoModel = profileInfo {
                        
                        //Сохраняем логин и пароль пользователя в UserDefaults
                        UserDefaultsManager.shared.saveUser(login: login, password: password)
                        
                        DispatchQueue.main.async {
                            
                            //Подготавливаем UserPageViewController и переходим на него 
                            let userPageStoryBoard = UIStoryboard(name: "UserPage", bundle: nil)
                            let navController = userPageStoryBoard.instantiateInitialViewController() as! UINavigationController
                            let userPageVC = navController.viewControllers.first! as! UserPageViewController
                            userPageVC.profileInfo = profileInfoModel
                            
                            UIApplication.setRootView(navController)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        guard let url = URL(string: "https://static.vk.com/restore/#/resetPassword") else { return }
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextFields()
        setupAuthVuew()
        signUpButton.isUserInteractionEnabled = false
    }
    
    func setupAuthVuew() {
        authView.layer.cornerRadius = Constants.buttonCornerRadius
        authView.layer.borderWidth = 1
        authView.layer.borderColor = UIColor(named: "separatorColor")?.cgColor
        authView.clipsToBounds = true
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func setupTextFields() {
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        loginTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    @objc func textFieldValueChanged() {
        
        if loginTextField.text != "" && passwordTextField.text != "" {
            
            signUpButton.backgroundColor = UIColor(named: "vkColor")
            signUpButton.isUserInteractionEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor(named: "disabledButtonColor")
            signUpButton.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
