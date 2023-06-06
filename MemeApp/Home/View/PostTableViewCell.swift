//
//  PostTableViewCell.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var containerV: UIView!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var scoreValue: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentValue: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerV.layer.cornerRadius = 10.0
        containerV.layer.borderWidth = 0.3
        containerV.layer.borderColor = UIColor.gray.cgColor
        containerV.backgroundColor = .white
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
