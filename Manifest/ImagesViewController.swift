import UIKit
import Firebase

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagesCollectionView: UICollectionView!

    let imagePicker = UIImagePickerController()
    
    var project: Project!
    var images = [Image]()

    @IBAction func publish(_ sender: Any) {
        let databaseRef = FIRDatabase.database().reference()
        let postId = databaseRef.child("posts").childByAutoId().key
        for image in images {
            if !image.published {
                image.published = true
                databaseRef.child("project-images/\(project!.id)/\(image.id)/published").setValue(true)
                databaseRef.child("posts/\(postId)/images/\(image.id)").setValue(true)
                // add thumbnail
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        loadImages()
    }

    func loadImages() {
        guard project != nil else { return }
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("project-images/\(project!.id)").observe(.childAdded, with: { (snapshot) -> Void in
            let imageData = snapshot.value as! [String: AnyObject]
            let url = URL(string: imageData["thumbnail"] as! String)
            let imageContents = try! Data(contentsOf: url!)
            let image = UIImage(data: imageContents)!
            self.images.append(Image(id: snapshot.key, thumbnail: image, published: imageData["published"] as! Bool))
            self.imagesCollectionView.insertItems(at: [IndexPath(row: self.images.count-1, section: 0)])
        })
        
        databaseRef.child("project-images/\(project!.id)").observe(.childChanged, with: { (snapshot) -> Void in
            let imageData = snapshot.value as! [String: AnyObject]
            for (index, image) in self.images.enumerated() {
                if image.id == snapshot.key {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.imagesCollectionView.reloadItems(at: [indexPath])
                }
            }
        })
    }
    
    
    // CollectionView
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        cell.imageImageView?.image = images[indexPath.row].thumbnail
        cell.publishedLabel.text = images[indexPath.row].published ? "Published" : "Not published"
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
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
        
        let imageId = NSUUID().uuidString
        uploadImage(image, name: "thumbnail", imageId: imageId, withSize: CGSize(width: 375, height: 375))
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picking image")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished picking image")
    }
    
    func uploadImage(_ image: UIImage, name: String, imageId: String, withSize size: CGSize? = nil) {
        let user = FIRAuth.auth()?.currentUser
        let databaseRef = FIRDatabase.database().reference()
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageData = UIImageJPEGRepresentation(size != nil ? resizeImage(image, size!) : image, 0.1)
        let imagePath = "images/\(imageId)/\(name).jpeg"
        let imageRef = storageRef.child(imagePath)
        
        imageRef.put(imageData!, metadata: metadata) { metadata, error in
            if (error != nil) {
                print("counldn't upload image", error as Any)
            } else {
                let thumbnailUrl = metadata!.downloadURL()?.absoluteString
                if self.project == nil {
                    self.project = Project(id: NSUUID().uuidString, title: "", thumbnailUrl: thumbnailUrl)
                    self.loadImages()
                }
                
                databaseRef.updateChildValues([
                    "project-images/\(self.project!.id)/\(imageId)": [
                        "published":  false,
                        name: thumbnailUrl
                    ],
                    "user-projects/\(user!.uid)/\(self.project.id)/title": "",
                    "user-projects/\(user!.uid)/\(self.project.id)/thumbnail": thumbnailUrl,
                    "feed-projects/\(self.project.id)/thumbnail": thumbnailUrl,
                ])
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
