//
//  MYAProfileCell.swift
//  MyAccount
//
//  Created by Hashim MH on 17/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
class MYAProfileCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UIDLabel!
    open var theme = UIDThemeManager.sharedInstance.defaultTheme
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        styleCell(for: selected, theme: theme)
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        styleCell(for: highlighted, theme: theme)
    }
}
