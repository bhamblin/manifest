import UIKit
import Firebase

class Project {
    var id: String
    var title: String
    var thumbnailUrl: String
    var thumbnail: UIImage?
    var newImages = 0
    var unpublishedImages = 0
    
    init(id: String, projectData: [String: Any]) {
        self.id = id
        self.title = projectData["title"] as! String
        self.thumbnailUrl = projectData["thumbnail"] as! String
        self.thumbnail = nil
        self.newImages = projectData["newImages"] as! Int
        self.unpublishedImages = projectData["unpublishedImages"] as! Int        
        
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
}
