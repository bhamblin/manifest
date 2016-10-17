import UIKit
import Firebase

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var projects = [String]()
    
    @IBOutlet weak var projectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRef = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let projectsRef = databaseRef.child("projects/\(user!.uid)")
        
        projectsRef.observe(.childAdded, with: { (snapshot) -> Void in
            let projectData = snapshot.value as! [String: AnyObject]
            self.projects.append(projectData["title"] as! String)
            
            self.projectsTableView.insertRows(at: [IndexPath(row: self.projects.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProject" {
            let controller = segue.destination as! ProjectViewController
            if (sender as? ProjectsTableViewCell) != nil {
                controller.projectId = projects[self.projectsTableView.indexPathForSelectedRow!.row]
            }
        }
    }

    
    // Table view

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectsTableViewCell", for: indexPath) as! ProjectsTableViewCell

        cell.textLabel?.text = projects[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
