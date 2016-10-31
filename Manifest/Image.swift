import UIKit

class Image {
    var id: String
    var thumbnail: UIImage
    var published: Bool
    
    init(id: String, thumbnail: UIImage, published: Bool = false) {
        self.id = id
        self.thumbnail = thumbnail
        self.published = published
    }
}
