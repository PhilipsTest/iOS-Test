///* Copyright (c) Koninklijke Philips N.V., 2018
// * All rights are reserved. Reproduction or dissemination
// * in whole or in part is prohibited without the prior written
// * consent of the copyright holder.
// */
//
import UIKit
import PhilipsUIKitDLS

class IAPCartVoucherCell: UIDTableViewCell {

    @IBOutlet weak var voucherLbl: UIDLabel!
    @IBOutlet weak var arrowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    func updateUI() {
        self.arrowButton = IAPUtility.getButtonWithFontIcon(button: arrowButton,
                                                                   fontName: IAPConstants.IAPFontIconName.rightArrowIcon,
                                                                   fontColor: UIColor.color(range: .blue,
                                                                                            level: .color15)!)
        self.arrowButton.tintColor = UIColor.darkGray
    }

}
