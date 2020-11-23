/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

enum MECBottomViewType {
    case shoppingCart
    case orderSummary
    case orderHistoryDetail
}

class MECShoppingCartBottomView: UIView {
    @IBOutlet weak var containerView: UIDView!
    @IBOutlet weak var continueShoppingButton: UIDButton!
    @IBOutlet weak var continueCheckoutButton: UIDButton!
    @IBOutlet weak var cartPriceView: UIStackView!
    @IBOutlet weak var totalProductCountLable: UIDLabel!
    @IBOutlet weak var taxLable: UIDLabel!
    @IBOutlet weak var totalPriceLabel: UIDLabel!

    func configureUI() {
        totalProductCountLable.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        totalPriceLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        taxLable.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            containerView.apply(dropShadow: UIDDropShadow(level: .level3, theme: theme))
        }
    }

    func updateUIFor(viewType: MECBottomViewType) {
        configureUI()
        if viewType == .shoppingCart {
            continueShoppingButton.setTitle(MECLocalizedString("mec_continue_shopping"), for: .normal)
            continueCheckoutButton.setTitle(MECLocalizedString("mec_continue_checkout"), for: .normal)
        } else if viewType == .orderSummary {
            continueShoppingButton.setTitle(MECLocalizedString("mec_back_shoppingCart"), for: .normal)
            continueCheckoutButton.setTitle(MECLocalizedString("mec_order_pay"), for: .normal)
        } else if viewType == .orderHistoryDetail {
            continueShoppingButton.setTitle(MECLocalizedString("mec_cancel_order"), for: .normal)
            continueCheckoutButton.isHidden = true
        }
    }

    func updateViewForEmptyCart() {
        continueCheckoutButton.philipsType = .secondary
        continueShoppingButton.philipsType = .primary
        continueCheckoutButton.isEnabled = false
        cartPriceView.isHidden = true
    }

    func updateUIFor(totalProductsCount: Int, tax: String, totalPrice: String) {
        cartPriceView.isHidden = false
        continueCheckoutButton.philipsType = .primary
        continueShoppingButton.philipsType = .secondary
        continueCheckoutButton.isEnabled = true
        totalProductCountLable.text =
        "\(MECLocalizedString("mec_cart_total")) (\(totalProductsCount) \(MECLocalizedString("mec_product_title")))"
        taxLable.text = String(format: MECLocalizedString("mec_cart_tax_message"), tax)
        totalPriceLabel.text = totalPrice
    }
}
