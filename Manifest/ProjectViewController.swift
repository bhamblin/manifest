import UIKit
import Firebase

class ProjectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()

    @IBAction func openCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("no camera :(")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished picking image")
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
                databaseRef.child("posts/\(user!.uid)/\(NSUUID().uuidString)/imageId").setValue(imageId)
            }
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picking image")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
