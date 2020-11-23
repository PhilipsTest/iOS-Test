/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import PhilipsIconFontDLS

protocol MECContactUsDelegate: NSObjectProtocol {
    func didClickOnCallUs(cell: MECOrderDetailContactCell)
}

class MECOrderDetailContactCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UIDLabel!
    @IBOutlet weak var orderStatusLabel: UIDLabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var consumerCareInfo: UIDLabel!
    @IBOutlet weak var callusButton: UIDButton!
    @IBOutlet weak var weekdayopeningHour: UIDLabel!
    @IBOutlet weak var weekendOpeningHour: UIDLabel!

    weak var delegate: MECContactUsDelegate?

    func coonfigureUI() {
        infoLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextInfo
        infoLabel.font = UIFont.iconFont(size: 22.0)
        infoLabel.text = PhilipsDLSIcon.unicode(iconType: .infoCircle)
        orderStatusLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextInfo
        orderIdLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        weekdayopeningHour.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        weekendOpeningHour.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
    }

    @IBAction func callUsButtonClicked(_ sender: Any) {
        delegate?.didClickOnCallUs(cell: self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        weekdayopeningHour.isHidden = false
        weekendOpeningHour.isHidden = false
        consumerCareInfo.isHidden = false
        callusButton.isHidden = false
    }
}
