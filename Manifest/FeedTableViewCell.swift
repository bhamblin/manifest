//
//  FeedTableViewCell.swift
//  Manifest
//
//  Created by Bradley Hamblin on 10/23/16.
//  Copyright © 2016 Bradley Hamblin. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var projectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}