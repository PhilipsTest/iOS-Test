/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

class IAPRetailerTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var retailerImageView: UIImageView!
    @IBOutlet weak var retailerNameLabel: UIDLabel!
    @IBOutlet weak var retailerStockLabel: UIDLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
    }
    
    func updateUI(){
        retailerNameLabel?.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        retailerStockLabel?.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
    }

}
