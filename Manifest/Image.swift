import UIKit
import Firebase

class Image {
    var id: String
    var thumbnail: UIImage
    var published: Bool
    
    init(id: String, thumbnail: UIImage, published: Bool = false) {
        self.id = id
        self.thumbnail = thumbnail
        self.published = published
    }

    class func observeChildAdded(for project: Project!, with: @escaping (Image) -> Void) {
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("project-images/\(project!.id)").observe(.childAdded, with: { (snapshot) -> Void in
            let imageData = snapshot.value as! [String: AnyObject]
            let id = snapshot.key as String
            let url = URL(string: imageData["thumbnail"] as! String)
            let imageContents = try! Data(contentsOf: url!)
            let thumbnail = UIImage(data: imageContents)!
            let image = Image(id: id, thumbnail: thumbnail, published: imageData["published"] as! Bool)
            with(image)
        })
    }
}
