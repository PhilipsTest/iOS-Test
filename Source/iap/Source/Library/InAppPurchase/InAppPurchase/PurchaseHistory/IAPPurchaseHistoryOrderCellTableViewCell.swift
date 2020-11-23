/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class IAPPurchaseHistoryOrderCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNumberTextLabel : UIDLabel!
    @IBOutlet weak var orderStateLabel : UIDLabel!
    @IBOutlet weak var statusImage: UIDLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    } 
}



