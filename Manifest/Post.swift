import Foundation

class Post {
    var id: String
    var imageDownloadUrl: String
    
    init(id: String, imageDownloadUrl: String) {
        self.id = id
        self.imageDownloadUrl = imageDownloadUrl
    }
}
