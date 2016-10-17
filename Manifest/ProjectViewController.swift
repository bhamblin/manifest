import UIKit
import Firebase

class ProjectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var projectId: String?
    
    @IBOutlet weak var projectTitletextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        loadProject()
//        loadPosts()
    }

    func loadProject() {
        var projectTitle = "New Project"
        
        if projectId == nil {
            let databaseRef = FIRDatabase.database().reference()
            let user = FIRAuth.auth()?.currentUser
            databaseRef.child("projects/\(user!.uid)/\(NSUUID().uuidString)/title").setValue(projectTitle)
        } else {
            projectTitle = projectId!
        }
        self.projectTitletextField!.text = projectTitle
    }
    
//    func loadPosts() {
//        let databaseRef = FIRDatabase.database().reference()
//        let projectPosts = databaseRef.child("project-posts").child(projectId!)
//        
//        projectPosts.observe(.childAdded, with: { (snapshot) -> Void in
//            let projectData = snapshot.value as! [String: String]
//            self.projects.append(projectData["title"] as! String)
//            self.projectsTableView.insertRows(at: [IndexPath(row: self.projects.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
//        })
//    }
    
    
    // Table view
    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! ProjectsTableViewCell
//        
//        cell.textLabel?.text = posts[indexPath.row]
//        return cell
//    }
//    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }

    
    // Create a post

    @IBAction func openCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("no camera :(")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.1)
        let storageRef = FIRStorage.storage().reference()
        let imageId = NSUUID().uuidString
        let imageRef = storageRef.child("posts/images/\(imageId).jpeg")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.put(data!, metadata: metadata) { metadata, error in
            if (error != nil) {
                print("counldn't upload", error)
            } else {
                print("uploaded", metadata!.downloadURL())
                let databaseRef = FIRDatabase.database().reference()
                let user = FIRAuth.auth()?.currentUser
                let postId = NSUUID().uuidString
                databaseRef.child("project-posts/\(self.projectId!)/\(postId)/imageId").setValue(imageId)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picking image")
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished picking image")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
