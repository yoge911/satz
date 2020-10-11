//
//  ItemDisplayTableViewCell.swift
//  Satz
//
//  Created by Yogesh Rokhade on 20.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class ItemDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var ItemSubText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ItemImage.layer.cornerRadius = 23
        ItemImage.layer.masksToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
