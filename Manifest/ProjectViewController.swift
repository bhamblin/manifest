import UIKit
import Firebase

class ProjectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var projectTitletextField: UITextField?
    
    let imagePicker = UIImagePickerController()
    
    var project: Project?
    var posts = [Post]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        loadProject()
        loadPosts()
    }

    func loadProject() {
        var projectTitle = "New Project"
        
        if project == nil {
            project = Project(id: NSUUID().uuidString, title: projectTitle)
            let databaseRef = FIRDatabase.database().reference()
            let user = FIRAuth.auth()?.currentUser
            databaseRef.child("user-projects/\(user!.uid)/\(project!.id)/title").setValue(projectTitle)
        } else {
            projectTitle = project!.title
        }
        self.projectTitletextField!.text = projectTitle
    }
    
    func loadPosts() {
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("project-posts/\(project!.id)").observe(.childAdded, with: { (snapshot) -> Void in
            let postData = snapshot.value as! [String: AnyObject]
            let imageUrl = postData["imageDownloadUrl"] as! String
            self.posts.append(Post(id: snapshot.key, imageDownloadUrl: imageUrl))
            self.postsTableView.insertRows(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })
    }
    
    
    // TableView
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! PostsTableViewCell
        let url = URL(string: posts[indexPath.row].imageDownloadUrl)
        let data = try! Data(contentsOf: url!)
        cell.imageView?.image = UIImage(data: data)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    // ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.1)
        let storageRef = FIRStorage.storage().reference()
        let postId = NSUUID().uuidString
        let imagePath = "posts/\(postId)/image.jpeg"
        let imageRef = storageRef.child(imagePath)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.put(data!, metadata: metadata) { metadata, error in
            if (error != nil) {
                print("counldn't upload", error)
            } else {
                print("uploaded")
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("project-posts/\(self.project!.id)/\(postId)/imageDownloadUrl").setValue(metadata!.downloadURL()?.absoluteString)
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
    
    @IBAction func openCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("no camera :(")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
