///* Copyright (c) Koninklijke Philips N.V., 2018
// * All rights are reserved. Reproduction or dissemination
// * in whole or in part is prohibited without the prior written
// * consent of the copyright holder.
// */

import Foundation
import PhilipsUIKitDLS
import PhilipsIconFontDLS

protocol IAPRemoveVoucherDelegate {
    func removeSelectedVoucher(cell:IAPVoucherListCell)
}

class IAPVoucherListCell: UITableViewCell {
    
    @IBOutlet weak var discountTitleLabel: UIDLabel!
    @IBOutlet weak var percentageLabel: UIDLabel!
    @IBOutlet weak var amountLabel: UIDLabel!
    @IBOutlet weak var removeVoucher: UIDButton!
    
    var delegate: IAPRemoveVoucherDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    func updateUI() {
        removeVoucher.titleFont = UIFont.iconFont(size: 18)
        removeVoucher.setTitle(PhilipsDLSIcon.unicode(iconType: .cross), for: .normal)
    }
    
    @IBAction func removeVoucher(_ sender: Any){
        delegate?.removeSelectedVoucher(cell: self)
    }
}
