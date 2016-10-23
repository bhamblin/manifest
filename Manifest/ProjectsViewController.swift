import UIKit
import Firebase

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var projects = [Project]()
    
    @IBOutlet weak var projectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let databaseRef = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let projectsRef = databaseRef.child("user-projects/\(user!.uid)")
        
        projectsRef.observe(.childAdded, with: { (snapshot) -> Void in
            let projectData = snapshot.value as! [String: String]
            let project = Project(id: snapshot.key, title: projectData["title"]!, thumbnailUrl: projectData["thumbnail"])
            self.projects.append(project)
            
            self.projectsTableView.insertRows(at: [IndexPath(row: self.projects.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProject" {
            let controller = segue.destination as! ProjectViewController
            if (sender as? ProjectsTableViewCell) != nil {
                controller.project = projects[self.projectsTableView.indexPathForSelectedRow!.row]
            }
        }
    }

    
    // Table view

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectsTableViewCell", for: indexPath) as! ProjectsTableViewCell

        cell.textLabel?.text = projects[indexPath.row].title
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
