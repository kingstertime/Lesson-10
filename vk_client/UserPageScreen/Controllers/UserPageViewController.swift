import UIKit

private let profileInfoCellIdentifier = "ProfileInfoCell"
private let postCellIdentifier = "PostCell"

class UserPageViewController: UITableViewController {
    
    //MARK: - Properties
    
    var profileInfo: ProfileInfo!
    
    var posts: [Post] = []
    var profiles: [Profile] = [] //Профили, упомянутые на стене
    var groups: [Groupe] = [] //Группы, упомянутые на стене
    
    //MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        title = profileInfo.response.first!.first_name
        fetchPosts()
    }
    
    //MARK: - IBActions
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        UserDefaultsManager.shared.removeLastUser()
        
        let loginStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        let authorizationVC = loginStoryboard.instantiateInitialViewController() as! AuthorizationViewController
        
        UIApplication.setRootView(authorizationVC)
    }
    
    //MARK: - Data workers
    
    //TODO: Пагинация
    func fetchPosts() {
        
        RemoteDataManager.shared.getUserPostsResponse { userPostsResponse, error in
            
            if let error = error {
                AlertService.presentInfoAlert(on: self, title: "Error", message: error.localizedDescription)
                return
            }
            
            if let userPostsResponse = userPostsResponse {
                
                DispatchQueue.main.async {
                    self.posts = userPostsResponse.items
                    if let profiles = userPostsResponse.profiles {
                        self.profiles = profiles
                    }
                    if let groups = userPostsResponse.groups {
                        self.groups = groups
                    }
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
        tableView.rowHeight = UITableView.automaticDimension
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
            cell.reloadDataDelegate = self
            cell.setup(for: profileInfo)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier) as! PostCell
            cell.postCellParentDelegate = self
            cell.reloadDataDelegate = self
            cell.setup(for: posts[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 165
        } else {

            //TODO: Пофиксить размер изображения
            //Сделать что-то вроде пропорциональной масштабизации

            return UITableView.automaticDimension
        }
    }
}

//MARK: - ReloadDataDelegate

extension UserPageViewController: ReloadDataDelegate {
    
    func reloadData() {
        
        tableView.reloadData()
    }
}

//MARK: - PostCellParentDelegate

extension UserPageViewController: PostCellParentDelegate {
    
    func getProfileImageURL(by id: Int) -> String {
        if id > 0 {
            
            if let profile = profiles.first(where: { $0.id == id }) {
                
                let imageURL = profile.photo_100
                return imageURL
                
            } else {
                
                let imageURL = profileInfo.response.first!.photo_200
                return imageURL
            }
            
        } else {
            
            guard let group = groups.first(where: { $0.id == id }) else { fatalError() }
            let imageURL = group.photo_100
            return imageURL
        }
    }
    
    func getUserName(by id: Int) -> String {
        
        if id > 0 {
            
            //Если id принадлежит пользователю
            
            guard let profile = profiles.first(where: { $0.id == id }) else {
                
                //В таком случае автором поста являемся мы сами
                let first_name = profileInfo.response.first!.first_name
                let second_name = profileInfo.response.first!.last_name
                return first_name + " " + second_name
            }
            return profile.first_name
            
        } else {
            
            //Если id принадлежит группе
            
            guard let group = groups.first(where: { $0.id == id }) else {
                return "Error"
            }
            return group.name
        }
    }
}
