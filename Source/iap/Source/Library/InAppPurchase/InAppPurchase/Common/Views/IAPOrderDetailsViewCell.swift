/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

class IAPOrderDetailsViewCell: UITableViewCell {
    
    @IBOutlet weak var orderDetailsNameLabel: UIDLabel!
    @IBOutlet weak var orderDetailsValueLabel: UIDLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
    }
    
}
