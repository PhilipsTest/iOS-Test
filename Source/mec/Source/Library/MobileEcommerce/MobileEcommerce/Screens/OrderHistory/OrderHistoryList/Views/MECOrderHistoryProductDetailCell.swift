/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

class MECOrderHistoryProductDetailCell: UITableViewCell {

    @IBOutlet weak var orderStatusIconLabel: UIDLabel!
    @IBOutlet weak var orderStatusLabel: UIDLabel!
    @IBOutlet weak var orderIDLabel: UIDLabel!
    @IBOutlet weak var orderProductsStackView: UIStackView!
    @IBOutlet weak var orderAccessoryLabel: UIDLabel!
    @IBOutlet weak var orderTotalLabel: UIDLabel!
    @IBOutlet weak var orderTotalValueLabel: UIDLabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        orderProductsStackView.arrangedSubviews.forEach { (subview) in
            orderProductsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        orderStatusLabel.text = nil
        orderIDLabel.text = nil
        orderTotalValueLabel.text = nil
        orderAccessoryLabel.isHidden = false
    }
}

extension MECOrderHistoryProductDetailCell {

    func configureIcons() {
        orderStatusIconLabel.font = UIFont.iconFont(size: UIDSize16)
        orderStatusIconLabel.text = PhilipsDLSIcon.unicode(iconType: .exclamationCircle)

        orderAccessoryLabel.font = UIFont.iconFont(size: UIDSize16)
        orderAccessoryLabel.text = MECUtility.isRightToLeft ?
            PhilipsDLSIcon.unicode(iconType: .navigationLeft) :
            PhilipsDLSIcon.unicode(iconType: .navigationRight)
    }

    func customizeUI() {
        configureIcons()
        orderStatusIconLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextInfo
        orderStatusLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextInfo
        orderIDLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        orderAccessoryLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.listItemDefaultOffIcon
        orderTotalLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        orderTotalValueLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText

        orderTotalLabel.textAlignment = MECUtility.isRightToLeft ? NSTextAlignment.right : NSTextAlignment.left
        orderTotalValueLabel.textAlignment = MECUtility.isRightToLeft ? NSTextAlignment.left : NSTextAlignment.right
    }
}
