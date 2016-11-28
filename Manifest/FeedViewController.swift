import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var projects = [Project]()
    var projectImages = [String: [UIImage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser != nil {
            loadProjects()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser == nil {
            let signUpNavigationController = self.storyboard!.instantiateViewController(withIdentifier: "SignUpNavigationController") as! UINavigationController
            self.navigationController?.present(signUpNavigationController, animated: true)
        }
    }
    
    func loadProjects() {
        let databaseRef = FIRDatabase.database().reference()
        _ = FIRAuth.auth()?.currentUser
        let feedRef = databaseRef.child("feed-projects")
        
        feedRef.observe(.childAdded, with: { (snapshot) -> Void in
            let projectData = snapshot.value as! [String: Any]
            let project = Project(id: snapshot.key, projectData: projectData)
            self.projects.append(project)
            let index = self.projects.count-1
            self.feedTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)

            self.loadFeedImages(project: project, index: index)
        })
        
        feedRef.observe(.childChanged, with: { (snapshot) -> Void in
            let projectId = snapshot.key as String
            for (index, project) in self.projects.enumerated() {
                if project.id == projectId {
                    let projectData = snapshot.value as! [String: Any]
                    self.projects[index] = Project(id: snapshot.key, projectData: projectData)
                    self.feedTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        })

        feedRef.observe(FIRDataEventType.childRemoved, with: { (snapshot) -> Void in
            let projectId = snapshot.key as String
            for (index, value) in self.projects.enumerated() {
                if value.id == projectId {
                    self.projects.remove(at: index)
                    self.feedTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        })
    }
    

    func loadFeedImages(project: Project, index: Int) {
        let databaseRef = FIRDatabase.database().reference()
        let feedRef = databaseRef.child("project-images/\(project.id)")
        
        feedRef.observe(.childAdded, with: { (snapshot) -> Void in
            let imageData = snapshot.value as! [String: Any]
            let url = URL(string: imageData["thumbnail"] as! String)!
            let thumbnailData = try! Data(contentsOf: url)
            let thumbnail = UIImage(data: thumbnailData)!
            if self.projectImages[project.id] == nil {
                self.projectImages[project.id] = [UIImage]()
            }
            self.projectImages[project.id]?.append(thumbnail)
            self.feedTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        })
    }
    

    // TableView
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        let project = projects[indexPath.row]
        
        if self.projectImages[project.id] != nil {
            cell.images = self.projectImages[project.id]
        } else {
            cell.images = [project.thumbnail!]
        }
        cell.imagesCollectionView.reloadData()
        
        let newImages = projects[indexPath.row].newImages
        if newImages > 1 {
            cell.newImagesBackgroundView.isHidden = false
            cell.newImagesLabel.text = "+\(newImages - 1)"
        } else {
            cell.newImagesBackgroundView.isHidden = true
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    
    @IBAction func handleLogout(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        let signInViewController = self.storyboard!.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let signUpNavigationController = self.storyboard!.instantiateViewController(withIdentifier: "SignUpNavigationController") as! UINavigationController
        signUpNavigationController.pushViewController(signInViewController, animated: true)
        self.navigationController?.present(signUpNavigationController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
