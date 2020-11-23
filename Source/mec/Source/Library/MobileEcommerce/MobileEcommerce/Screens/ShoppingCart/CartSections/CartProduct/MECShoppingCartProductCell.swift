/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

protocol MECShoppingCartProductDelegate: NSObjectProtocol {
    func didClickOnChangeQuantity(productCell: MECShoppingCartProductCell)
}

class MECDiscountView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomRight, .topRight], radius: self.bounds.height/2)
    }
}

class MECShoppingCartProductCell: UITableViewCell {

    @IBOutlet weak var containerView: UIDView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var ratingBar: UIDRatingBar!
    @IBOutlet weak var reviewCount: UIDLabel!
    @IBOutlet weak var productTitle: UIDLabel!
    @IBOutlet weak var productCTN: UIDLabel!
    @IBOutlet weak var productDiscountedPrice: UIDLabel!
    @IBOutlet weak var productActualPrice: UIDLabel!
    @IBOutlet weak var productQuantityButton: UIDButton!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var quantityContainerView: UIView!
    @IBOutlet weak var discountView: MECDiscountView!
    @IBOutlet weak var discountLabel: UIDLabel!
    @IBOutlet weak var discountBaseView: UIView!
    @IBOutlet weak var lowStockWarningLabel: UIDLabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var suggestedRetailerPriceLabel: UIDLabel!

    weak var delegate: MECShoppingCartProductDelegate?
    var swipeHintDistance: CGFloat = 80

    func configureUI() {
        self.reviewCount.textColor = UIDThemeManager.sharedInstance.defaultTheme?.ratingBarDefaultOnText
        productCTN.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        suggestedRetailerPriceLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        productTitle.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        productActualPrice.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        productDiscountedPrice.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText

        quantityContainerView.layer.cornerRadius = 3.0
        quantityContainerView.layer.borderWidth = 1
        quantityContainerView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground?.cgColor

        productQuantityButton.philipsType = .quiet
        leftButton.titleLabel?.font = UIFont.mecIconFont(size: UIDSize24) ?? UIFont()
        rightButton.titleLabel?.font = UIFont.mecIconFont(size: UIDSize24) ?? UIFont()
        leftButton.setTitle(MECIconFont.unicode(iconType: .delete), for: .normal)
        rightButton.setTitle(MECIconFont.unicode(iconType: .delete), for: .normal)
        productQuantityButton.titleLabel?.font = UIFont.mecIconFont(size: UIDSize16)
        productQuantityButton.setTitleColor(UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText, for: .normal)
        productQuantityButton.contentEdgeInsets = .zero

        productQuantityLabel.font = UIFont.mecIconFont(size: UIDSize12)
        productQuantityLabel.text = MECIconFont.unicode(iconType: .downArrow)
        productQuantityLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText

        discountLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        discountView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.ratingBarDefaultOnText
        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            discountBaseView.apply(dropShadow: UIDDropShadow(level: .level2, theme: theme))
        }
        lowStockWarningLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.ratingBarDefaultOnIcon
        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            discountView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }

    @IBAction func quantityButtonTapped(_ sender: Any) {
        delegate?.didClickOnChangeQuantity(productCell: self)
    }

    func animateSwipeHint() {
        slideInFromRight()
    }

    private func slideInFromRight() {
        UIView.animate(withDuration: 0.4, delay: 0.4, options: [.curveEaseOut], animations: {
            self.containerView.transform = CGAffineTransform(translationX: -self.swipeHintDistance, y: 0)
        }, completion: {(_) in
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
                self.containerView.transform = CGAffineTransform(translationX: self.swipeHintDistance, y: 0)
            }, completion: {(_) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveLinear], animations: {
                    self.containerView.transform = .identity
                }, completion: nil)
            })
        })
    }
}
