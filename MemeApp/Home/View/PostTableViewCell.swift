//
//  PostTableViewCell.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var scoreValue: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
