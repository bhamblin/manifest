import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var newImagesLabel: UILabel!
    @IBOutlet weak var newImagesBackgroundView: UIView!
    
    var images: [UIImage]!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        newImagesBackgroundView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func reloadData() {
        imagesCollectionView.reloadData()
    }
    // CollectionView
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedImagesCollectionViewCell", for: indexPath) as! FeedImagesCollectionViewCell
        cell.projectImageView.image = images[indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let size = imagesCollectionView.frame.size.width
        return CGSize(width: size, height: size)
    }
    
    //Use for interspacing
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
