/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

class IAPSingleListItemCell: UITableViewCell {
    
    @IBOutlet weak var cellContextTitle: UIDLabel!
    @IBOutlet weak var rightArrowIcongray: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightArrowIcongray = IAPUtility.getButtonWithFontIcon(button: rightArrowIcongray,
                                                              fontName: IAPConstants.IAPFontIconName.rightArrowIcon,
                                                              fontColor: UIColor.color(range: .blue, level: .color15)!)
        // TODO: Should be taken care when proper image with font received ...
        rightArrowIcongray.tintColor = UIColor.darkGray
    }
    
}
