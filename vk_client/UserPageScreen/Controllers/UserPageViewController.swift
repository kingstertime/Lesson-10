import UIKit

private let profileInfoCellIdentifier = "ProfileInfoCell"

class UserPageViewController: UITableViewController {
    
    var profileInfo: ProfileInfo!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        title = profileInfo.response.first!.first_name
    }

    // MARK: - Table view
    
    func setupTableView() {
        
        let profileInfoCellNib = UINib(nibName: "ProfileInfoCell", bundle: nil)
        tableView.register(profileInfoCellNib, forCellReuseIdentifier: profileInfoCellIdentifier)
        
        //Register postCell
        
        tableView.allowsSelection = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return 0 //TODO:
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: profileInfoCellIdentifier) as! ProfileInfoCell
            cell.setup(for: profileInfo)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 165
        } else {
            return tableView.estimatedRowHeight
        }
    }
}
