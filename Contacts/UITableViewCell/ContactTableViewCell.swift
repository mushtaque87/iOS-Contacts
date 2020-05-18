//
//  ArticleTableViewCell.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 12/22/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //profileImageView.layer.borderColor = UIColor.black.cgColor
        //profileImageView.layer.borderWidth = 1.0
        profileImageView.image = UIImage(named: "placeholder_photo")
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
