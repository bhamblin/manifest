import UIKit
import Firebase

class Project {
    var id: String
    var title: String
    var thumbnailUrl: String
    var thumbnail: UIImage?
    var newImages = 0
    var published = false
    
    init(id: String, projectData: [String: Any]) {
        self.id = id
        self.title = projectData["title"] as! String
        self.thumbnailUrl = projectData["thumbnail"] as! String
        self.thumbnail = nil
        self.newImages = projectData["newImages"] as! Int
        self.published = projectData["published"] as! Bool
        
        self.loadImage()
    }

    init(id: String, title: String, thumbnailUrl: String = "") {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.thumbnail = nil
        
        self.loadImage()
    }
    
    func loadImage() {
        if thumbnailUrl != "" {
            let imageData = try! Data(contentsOf: URL(string: self.thumbnailUrl)!)
            thumbnail = UIImage(data: imageData)!
        } else {
            thumbnail = UIImage()
        }
    }
    
//    class func all(for userId: String, with: @escaping ([String: Any]) -> Void) {
//        let databaseRef = FIRDatabase.database().reference()
//        databaseRef.child("user-projects/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
//            let projects = snapshot.value as! [String: Any]
//            with(projects)
//        })
//    }
}
