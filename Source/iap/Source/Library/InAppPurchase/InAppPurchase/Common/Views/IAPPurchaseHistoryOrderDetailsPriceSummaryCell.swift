/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

protocol IAPPriceSummaryCellProtocol: class{
    func userSelectedcancelButton(_ inSender:IAPPurchaseHistoryOrderDetailsPriceSummaryCell);
}

class IAPPurchaseHistoryOrderDetailsPriceSummaryCell: UITableViewCell {
    
    weak var priceSummaryCellDelegate: IAPPriceSummaryCellProtocol?
    
    @IBOutlet weak var deliveryParcelTextLabel : UIDLabel?
    @IBOutlet weak var deliveryParcelValueLabel : UIDLabel?
    @IBOutlet weak var totalTextLabel : UIDLabel?
    @IBOutlet weak var totalValueLabel : UIDLabel?
    @IBOutlet weak var vatTextLabel : UIDLabel?
    @IBOutlet weak var vatValueLabel : UIDLabel?
    @IBOutlet weak var cancelMyOrderButton: UIDButton?
    
    var orderDetail:IAPPurchaseHistoryModel!
    var orderDetailProduct: IAPProductModel!
    
    class func instanceFromNib() -> IAPPurchaseHistoryOrderDetailsPriceSummaryCell? {

        return UINib(nibName: IAPNibName.IAPPurchaseHistoryOrderDetailsPriceSummaryCell,
                     bundle: IAPUtility.getBundle()).instantiate(withOwner: nil, options: nil)[0] as?
                    IAPPurchaseHistoryOrderDetailsPriceSummaryCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelMyOrderButton?.philipsType = .secondary
        // Localized string has to be added
        deliveryParcelTextLabel?.text = IAPLocalizedString("iap_shipping_cost") ?? ""
        totalTextLabel?.text = IAPLocalizedString("iap_total")!
        vatTextLabel?.text = IAPLocalizedString("iap_including_tax")!
        cancelMyOrderButton?.isHidden = true
    }

    func updateWithUIForOrderSummary(cartInfo: IAPCartInfo) {
        deliveryParcelValueLabel?.text = cartInfo.shippingCost
        totalValueLabel?.text = cartInfo.totalPriceWithTax
        vatValueLabel?.text = cartInfo.vatTotal
        contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        isUserInteractionEnabled = false
    }

    @IBAction func cancelMyOrder(_ sender: UIDButton) {
        priceSummaryCellDelegate?.userSelectedcancelButton(self)
    }

    //This method is to update UI for shopping cart
    func updateUIForShoppingCart(cartInfo: IAPCartInfo) {
        if cartInfo.deliveryModeName != nil {
            deliveryParcelTextLabel?.isHidden = false
            deliveryParcelValueLabel?.isHidden = false
            vatTextLabel?.isHidden = false
            vatValueLabel?.isHidden = false
            deliveryParcelTextLabel?.text = IAPLocalizedString("iap_shipping_cost") ?? ""
            deliveryParcelValueLabel?.text = cartInfo.shippingCost
            vatTextLabel?.text = IAPLocalizedString("iap_including_tax")!
            vatValueLabel?.text = cartInfo.vatTotal
        } else {
            deliveryParcelTextLabel?.isHidden = true
            deliveryParcelValueLabel?.isHidden = true
            vatTextLabel?.isHidden = true
            vatValueLabel?.isHidden = true
        }
        totalTextLabel?.text = IAPLocalizedString("iap_total")!
        totalValueLabel?.text = cartInfo.totalPriceWithTax
        cancelMyOrderButton?.isHidden = true
        isUserInteractionEnabled = false
    }
}
