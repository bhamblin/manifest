import UIKit

class Project {
    var id: String
    var title: String
    var thumbnail: UIImage
    
    init(id: String, title: String, thumbnailUrl: String? = nil) {
        self.id = id
        self.title = title
        self.thumbnail = UIImage()
        
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
}
