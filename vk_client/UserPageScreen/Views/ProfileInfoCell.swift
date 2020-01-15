import UIKit

class ProfileInfoCell: UITableViewCell {
    
    //MARK: - Properties
    
    weak var reloadDataDelegate: ReloadDataDelegate!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageAndCityLabel: UILabel!
    @IBOutlet weak var editPofileButton: UIButton!
    
    //MARK: - Setups
    
    func setup(for profileInfo: ProfileInfo) {
        
        setupUI()
        
        let profileInfoModel = profileInfo.response.first!
        
        nameLabel.text = profileInfoModel.first_name + " " + profileInfoModel.last_name
        
        let age = Helper.getAgeFromBirthDate(birthDate: profileInfoModel.bdate)
        let formattedAge = "\(age) лет"
        ageAndCityLabel.text = formattedAge + ", " + (profileInfoModel.city?.title ?? "")
        
        let imageStringURL = profileInfoModel.photo_200
        RemoteDataManager.shared.getImage(by: imageStringURL) { image, error in
            
            if error != nil {
                return
            }
            
            if let image = image {
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                    
                    //Обновляем данные в родительском контроллере
                    self.reloadDataDelegate.reloadData()
                }
            }
        }
    }
    
    func setupUI() {
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        editPofileButton.layer.cornerRadius = editPofileButton.frame.height / 2
    }
    
    //MARK: - IBActions
    
    @IBAction func moreInfoButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
    }
}
