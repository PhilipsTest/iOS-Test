//
//  LoggerTableViewCell.swift
//  AppInfraMicroApp
//
//  Created by leslie on 20/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS

class LoggerTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UIDLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
