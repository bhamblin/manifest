import UIKit
import Firebase

class ProjectViewController: UIViewController {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var postsView: UIView!
    
    var project: Project!
    
    @IBAction func handleViewChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            detailsView.isHidden = true
            postsView.isHidden = false
        } else {
            detailsView.isHidden = false
            postsView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPosts" {
            if let posts = segue.destination as? PostsViewController {
                posts.project = project
            }
        }
        if segue.identifier == "ShowDetails" {
            print("details")
        }
    }
    
    @IBAction func deleteProject(_ sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("feed-projects/\(project.id)").removeValue()
        databaseRef.child("project-posts/\(project.id)").removeValue()
        databaseRef.child("user-projects/\(user!.uid)/\(project.id)").removeValue()
        
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
