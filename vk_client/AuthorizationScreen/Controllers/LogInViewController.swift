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
        
        remoteDM.registerUser(login: login, password: password) { authResponseModel, error in
            
            if error != nil {
                //TODO: Алерт об ошибке авторизации
                return
            }
            
            if let authResponseModel = authResponseModel {
                
                //let userID = String(authResponseModel.user_id)
                let access_token = authResponseModel.access_token
                
                self.remoteDM.getProfileInfo(access_token: access_token) { profileInfo, error in
                    
                    if error != nil {
                        //TODO: Алерт об ошибке авторизации
                        return
                    }
                    
                    if let profileInfoModel = profileInfo {
                        
                        print(profileInfoModel.response)
                        //Переход на стенку пользователя, передаем profileOnfoModel
                    }
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        //TODO: Открываем URL странички в вк с восстановлением пароля
        //Или просто алерт заглушка, если будет впадлу
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
