import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var sendDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    

    func setup(for post: Post) {
        
        setupUI()
        
        fetchSenderData(for: post)
        fetchPostData(for: post)
    }
    
    func setupUI() {
        
        senderImageView.layer.cornerRadius = senderImageView.frame.height / 2
    }
    
    func fetchPostData(for post: Post) {
        
        postTextLabel.text = post.text
        
        //Получаем URL первого прикрепленного изображения самого лучшего качества ( Пока что )
        guard let mainImageStringURL = post.attachments.first?.photo.sizes.last?.url else { return }
        RemoteDataManager.shared.getImage(by: mainImageStringURL) { image, error in
            
            if error != nil {
                return
            }
            
            if let image = image {
                
                DispatchQueue.main.async {
                    
                    self.mainImageView.image = image
                }
            }
        }
    }
    
    func fetchSenderData(for post: Post) {
        
        //Fetching sender name + sender avatar
        
        let postAuthorID = String(post.from_id)
        RemoteDataManager.shared.getProfileInfo(userID: postAuthorID) { profileInfo, error in
            
            if error != nil {
                return
            }
            
            if let profileInfo = profileInfo {
                
                DispatchQueue.main.async {
                    self.senderNameLabel.text = profileInfo.response.first!.first_name + " " + profileInfo.response.first!.last_name
                }
                
                let imageURL = profileInfo.response.first!.photo_200
                RemoteDataManager.shared.getImage(by: imageURL) { image, error in
                    
                    if error != nil {
                        return
                    }
                    if let image = image {
                        DispatchQueue.main.async {
                            self.senderImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
