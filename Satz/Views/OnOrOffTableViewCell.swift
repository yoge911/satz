//
//  OnOrOffTableViewCell.swift
//  Satz
//
//  Created by Yogesh Rokhade on 20.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class OnOrOffTableViewCell: UITableViewCell {

    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var OptionValue: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
