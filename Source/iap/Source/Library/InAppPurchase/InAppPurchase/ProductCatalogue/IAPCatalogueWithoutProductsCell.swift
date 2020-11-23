//
//  IAPCataloguewitoutProductsCell.swift
//  InAppPurchase
//
//  Created by Niharika Bundela on 7/28/17.
//  Copyright © 2017 Rakesh R. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import PhilipsIconFontDLS

class IAPCatalogueWithoutProductsCell: UITableViewCell {
    
    @IBOutlet weak var lblMessageTitle: UIDLabel!
    @IBOutlet weak var lblMessageDescription: UIDLabel!
    @IBOutlet weak var lblAlert: UIDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUIWithSearchText(searchText: String) {
        lblMessageDescription.text = IAPLocalizedString("iap_filter_productlist")
        lblAlert.textColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryFocusBackground
        lblAlert.font = UIFont.iconFont(size: 22.0)
        lblAlert.text = PhilipsDLSIcon.unicode(iconType: .infoCircle)
        layoutMargins = UIEdgeInsets.zero
        lblMessageTitle.text = IAPLocalizedString("iap_no_result")! + " " + searchText
    }
}
