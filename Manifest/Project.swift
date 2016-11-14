import UIKit
import Firebase

class Project {
    var id: String
    var title: String
    var thumbnailUrl: String?
    var thumbnail: UIImage?
    
    init(id: String, title: String, thumbnailUrl: String? = nil) {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.thumbnail = nil
        
        self.thumbnail = self.loadImage(url: thumbnailUrl)
    }
    
    func loadImage(url: String?) -> UIImage {
        var image: UIImage
        
        if url != nil {
            let imageData = try! Data(contentsOf: URL(string: url!)!)
            image = UIImage(data: imageData)!
        } else {
            image = UIImage()
        }
        return image
    }
    
    class func all(for userId: String, with: @escaping ([String: AnyObject]) -> Void) {
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("user-projects/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
            let projects = snapshot.value as! [String: AnyObject]
            with(projects)
        })
    }
}
