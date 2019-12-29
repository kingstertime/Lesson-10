import UIKit

private let profileInfoCellIdentifier = "ProfileInfoCell"
private let postCellIdentifier = "PostCell"

class UserPageViewController: UITableViewController {
    
    var profileInfo: ProfileInfo!
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        title = profileInfo.response.first!.first_name
        fetchPosts()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        UserDefaultsManager.shared.removeLastUser()
        
        let loginStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        let authorizationVC = loginStoryboard.instantiateInitialViewController() as! AuthorizationViewController
        
        UIApplication.setRootView(authorizationVC)
    }
    
    
    //MARK: - Data workers
    
    func fetchPosts() {
        
        RemoteDataManager.shared.getPosts { posts, error in
            
            if error != nil {
                return
            }
            
            if let posts = posts {
                
                DispatchQueue.main.async {
                    self.posts = posts
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view
    
    func setupTableView() {
        
        let profileInfoCellNib = UINib(nibName: "ProfileInfoCell", bundle: nil)
        tableView.register(profileInfoCellNib, forCellReuseIdentifier: profileInfoCellIdentifier)
        
        let postCellNib = UINib(nibName: "PostCell", bundle: nil)
        tableView.register(postCellNib, forCellReuseIdentifier: postCellIdentifier)
        
        tableView.allowsSelection = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return posts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: profileInfoCellIdentifier) as! ProfileInfoCell
            cell.setup(for: profileInfo)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier) as! PostCell
            cell.setup(for: posts[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 165
        } else {
            
            //TODO: Переделать нормально, чтобы размер ячейки зависел от размера картинки
            return 370
        }
    }
}
