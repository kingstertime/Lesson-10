import UIKit

class PostCell: UITableViewCell {
    
    //MARK: - Properties
    weak var postCellParentDelegate: PostCellParentDelegate!
    weak var reloadDataDelegate: ReloadDataDelegate!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var sendDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    //Extended View ( If post is reposted )
    @IBOutlet weak var reposterImageView: UIImageView!
    @IBOutlet weak var reposterNameLabel: UILabel!
    @IBOutlet weak var reposterSendDateLabel: UILabel!
    
    
    //MARK: - Setups

    func setup(for post: Post) {
        
        setupUI()
        setupBasePostInfo(for: post)
        
        if let attachments = post.attachments {
            
            setupAttachment(for: attachments)
        }
        
        if let repostedPost = post.copy_history?.first {
            
            setupReposterInfo(for: repostedPost)
            
        } else {
            
            reposterSendDateLabel.text = nil
            reposterNameLabel.text = nil
            reposterImageView.image = nil
        }
    }
    
    func setupBasePostInfo(for post: Post) {
        
        senderNameLabel.text = postCellParentDelegate.getUserName(by: post.owner_id)
        sendDateLabel.text = String(post.date) //Пока что в формате unixtime
        postTextLabel.text = post.text
        
        let imageURL = postCellParentDelegate.getProfileImageURL(by: post.owner_id)
        DispatchQueue.global().async {
            
            RemoteDataManager.shared.getImage(by: imageURL) { image, error in
                
                if let image = image {
                    
                    DispatchQueue.main.async {
                        self.mainImageView.image = image
                    }
                } else {
                    fatalError()
                }
            }
        }
    }
    
    func setupReposterInfo(for post: Post) {
        
        reposterNameLabel.text = postCellParentDelegate.getUserName(by: post.from_id)
        
        let imageURL = postCellParentDelegate.getProfileImageURL(by: post.from_id)
        DispatchQueue.global().async {
            RemoteDataManager.shared.getImage(by: imageURL) { (image, error) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.reposterImageView.image = image
                    }
                } else {
                    fatalError()
                }
            }
        }
    }
    
    func setupAttachment(for attachments: [Attachments]) {
        
        //В приложении учитываем что прикрепления только картинки
        //И если прикрепленных картинок несколько, то показываем только первую
        
        for attachment in attachments {
            
            if attachment.type == "photo" {
                
                let photo = attachment.photo!
                let photoHeight = photo.sizes.last!.height
                let photoWidth = photo.sizes.last!.width
                
                let compressCoefficient = photoWidth / Int(self.frame.width)
                let newWidth = Int(self.frame.width)
                let newHeight = photoHeight / compressCoefficient
                
                mainImageView.sizeThatFits(CGSize(width: newWidth, height: newHeight))
                mainImageView.contentMode = .scaleAspectFill
                
                let photoStringURL = photo.sizes.last!.url
                RemoteDataManager.shared.getImage(by: photoStringURL) { image, error in
                    
                    if let image = image {
                        
                        DispatchQueue.main.async {
                            self.mainImageView.image = image
                        }
                    } else {
                        fatalError()
                    }
                }
                break
            }
            return
        }
    }
    
    func setupUI() {
        
        senderImageView.layer.cornerRadius = senderImageView.frame.height / 2
        reposterImageView.layer.cornerRadius = reposterImageView.frame.height / 2
    }
}
