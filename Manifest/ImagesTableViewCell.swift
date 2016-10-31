import UIKit

class ImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var publishedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
