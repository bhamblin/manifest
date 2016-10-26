import UIKit
import Firebase

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var testlabel: UILabel!

    let imagePicker = UIImagePickerController()
    
    var project: Project!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        if project == nil {
            createProject()
        }
        loadPosts()
    }

    
    func createProject() {
        project = Project(id: NSUUID().uuidString, title: "")
        let databaseRef = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        databaseRef.child("user-projects/\(user!.uid)/\(project.id)/title").setValue(project.title)

    }
    
    func loadPosts() {
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("project-posts/\(project!.id)").observe(.childAdded, with: { (snapshot) -> Void in
            let postData = snapshot.value as! [String: AnyObject]
            let url = URL(string: postData["thumbnail"] as! String)
            let imageData = try! Data(contentsOf: url!)
            let image = UIImage(data: imageData)!
            self.posts.append(Post(id: snapshot.key, thumbnail: image))
            self.postsTableView.insertRows(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })
    }
    
    
    // TableView
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! PostsTableViewCell
        cell.postImageView?.image = posts[indexPath.row].thumbnail
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    // ImagePicker
    
    @IBAction func addImage(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("no camera :(")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let postId = NSUUID().uuidString
        uploadImage(image, name: "original", postId: postId)
        uploadImage(image, name: "thumbnail", postId: postId, withSize: CGSize(width: 375, height: 375))
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picking image")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished picking image")
    }
    
    func uploadImage(_ image: UIImage, name: String, postId: String, withSize size: CGSize? = nil) {
        let databaseRef = FIRDatabase.database().reference()
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageData = UIImageJPEGRepresentation(size != nil ? resizeImage(image, size!) : image, 0.1)
        let imagePath = "posts/\(postId)/\(name).jpeg"
        let imageRef = storageRef.child(imagePath)
        
        imageRef.put(imageData!, metadata: metadata) { metadata, error in
            if (error != nil) {
                print("counldn't upload original", error)
            } else {
                databaseRef.child("project-posts/\(self.project!.id)/\(postId)/\(name)").setValue(metadata!.downloadURL()?.absoluteString)
                databaseRef.child("feed-projects/\(self.project!.id)/thumbnail").setValue(metadata!.downloadURL()?.absoluteString)
                databaseRef.child("feed-projects/\(self.project!.id)/title").setValue(self.project?.title)
            }
        }
    }
    
    func resizeImage(_ image: UIImage, _ targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}