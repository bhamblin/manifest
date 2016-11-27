import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var projects = [Project]()
    
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
            self.feedTableView.insertRows(at: [IndexPath(row: self.projects.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
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
    
    
    // TableView
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.projectImageView.image = projects[indexPath.row].thumbnail
        let newImages = String(projects[indexPath.row].newImages)
        cell.newImagesLabel.text = "+\(newImages)"
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
