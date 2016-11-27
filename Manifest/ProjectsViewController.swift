import UIKit
import Firebase

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var projects = [Project]()
    
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var createProjectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProjectButton.layer.cornerRadius = 4;
        
        let databaseRef = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let projectsRef = databaseRef.child("user-projects/\(user!.uid)")
        
        projectsRef.observe(.childAdded, with: { (snapshot) -> Void in
            let projectData = snapshot.value as! [String: Any]
            let project = Project(id: snapshot.key, projectData: projectData)
            self.projects.append(project)
            
            self.projectsTableView.insertRows(at: [IndexPath(row: self.projects.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })

        projectsRef.observe(.childChanged, with: { (snapshot) -> Void in
            let projectId = snapshot.key as String
            for (index, project) in self.projects.enumerated() {
                if project.id == projectId {
                    let projectData = snapshot.value as! [String: Any]
                    self.projects[index] = Project(id: snapshot.key, projectData: projectData)
                    self.projectsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        })
        
        projectsRef.observe(FIRDataEventType.childRemoved, with: { (snapshot) -> Void in
            let projectId = snapshot.key as String
            for (index, value) in self.projects.enumerated() {
                if value.id == projectId {
                    self.projects.remove(at: index)
                    self.projectsTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProject" {
            let controller = segue.destination as! ProjectViewController
            if (sender as? UITableViewCell) != nil {
                controller.project = projects[self.projectsTableView.indexPathForSelectedRow!.row]
            }
        } else if segue.identifier == "CreateProject" {
            let controller = segue.destination as! ProjectViewController
            controller.project = Project(id: UUID().uuidString, title: "Project \(self.projects.count + 1)")
        }
    }

    
    // Table view

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectsTableViewCell", for: indexPath) as! ProjectsTableViewCell
        cell.thumbnailImageView.image = projects[indexPath.row].thumbnail    
        cell.titleLabel.text = projects[indexPath.row].title
        if projects[indexPath.row].unpublishedImages > 0 {
            cell.unpublishedLabel.isHidden = false
            cell.unpublishedLabel.text = "\(projects[indexPath.row].unpublishedImages) UNPUBLISHED"
        } else {
            cell.unpublishedLabel.isHidden = true
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
