//
//  MYASettingsCell.swift
//  MyAccount
//
//  Created by Hashim MH on 10/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
class MYASettingsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UIDLabel!
    @IBOutlet weak var valueLabel: UIDLabel!
    
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

extension UITableViewCell {
    func styleCell(for selected: Bool, theme:UIDTheme?) {
        guard let theme = theme else {
            return
        }
        if selected == true {
            contentView.backgroundColor = theme.listItemDefaultOnBackground
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
}
