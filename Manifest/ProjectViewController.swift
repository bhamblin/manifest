import UIKit
import Firebase

class ProjectViewController: UIViewController {
    
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var detailsView: UIView!

    var project: Project!
    
    @IBAction func handleViewChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            detailsView.isHidden = true
            imagesView.isHidden = false
        } else {
            detailsView.isHidden = false
            imagesView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if project.thumbnailUrl != nil {
            let user = FIRAuth.auth()?.currentUser
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.updateChildValues([
                "user-projects/\(user!.uid)/\(self.project.id)/title": self.project.title
            ])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.title = project!.title
        
        detailsView.isHidden = true
        imagesView.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImages" {
            if let images = segue.destination as? ImagesViewController {
                images.project = project
            }
        }
        if segue.identifier == "ShowDetails" {
            if let details = segue.destination as? DetailsViewController {
                details.project = project
            }
        }
    }

    @IBAction func deleteProject(_ sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("feed-projects/\(project.id)").removeValue()
        databaseRef.child("project-images/\(project.id)").removeValue()
        databaseRef.child("user-projects/\(user!.uid)/\(project.id)").removeValue()
        project.thumbnailUrl = nil
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
