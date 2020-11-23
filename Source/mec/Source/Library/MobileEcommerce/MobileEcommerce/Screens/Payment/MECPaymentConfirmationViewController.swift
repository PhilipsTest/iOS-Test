/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK

enum MECPaymentStates: String {
    case paymentSuccess
    case paymentPending
}
enum MECPaymentType: String {
    case paymentTypeNew = "New"
    case paymentTypeOld = "Old"
}

class MECPaymentConfirmationViewController: MECBaseViewController {

    @IBOutlet weak var paymentStatusLabel: UIDLabel!
    @IBOutlet weak var orderDescriptionLabel: UIDLabel!
    @IBOutlet weak var mailDetailLabel: UIDLabel!
    var paymentStatus: MECPaymentStates?
    var paymentType: MECPaymentType?
    var orderDetail: ECSOrderDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        guard paymentStatus == .paymentSuccess else { return }
        trackOrderPurchase()
    }

    @IBAction func okButtonClicked(_ sender: Any) {
        finishMECFlow()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.oredrConfirmationPage)
    }

    func trackOrderPurchase() {
        var paramData = [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.purchase,
                         MECAnalyticsConstants.productListKey: prepareCartEntryListString(entries: orderDetail?.entries),
                         MECAnalyticsConstants.transactionID: orderDetail?.orderID ?? ""]

        if let selectedPaymentType = self.paymentType?.rawValue {
            paramData.updateValue(selectedPaymentType, forKey: MECAnalyticsConstants.paymentType)
        }

        if let deliveryMode = orderDetail?.deliveryMode?.deliveryModeName {
            paramData.updateValue(deliveryMode, forKey: MECAnalyticsConstants.deliveryMethod)
        }
        if let voucherString = voucherString() {
            paramData.updateValue(MECAnalyticsConstants.voucherCodeRedeemed, forKey: MECAnalyticsConstants.voucherCodeStatus)
            paramData.updateValue(voucherString, forKey: MECAnalyticsConstants.voucherCode)
        }
        if let promotionString = promotionString() {
            paramData.updateValue(promotionString, forKey: MECAnalyticsConstants.promotion)
        }
        trackAction(parameterData: paramData)
    }

    func voucherString() -> String? {
        guard let voucherList = orderDetail?.appliedVouchers, orderDetail?.appliedVouchers?.count ?? 0 > 0 else { return nil }
        let vocherCodes = voucherList.compactMap({ $0.voucherCode })
        return vocherCodes.joined(separator: "|")
    }

    func promotionString() -> String? {
        guard let promotionList = orderDetail?.appliedOrderPromotions, orderDetail?.appliedOrderPromotions?.count ?? 0 > 0 else {return nil}
        let promotionCodes = promotionList.compactMap({
            $0.promotion?.name
        })
        return promotionCodes.joined(separator: "|")
    }
}

extension MECPaymentConfirmationViewController {

    func configureUI() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        paymentStatusLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        orderDescriptionLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        mailDetailLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        configureDisplayTexts()
    }

    func configureDisplayTexts() {
        guard let paymentStatus = paymentStatus else {
            return
        }
        switch paymentStatus {
        case .paymentSuccess:
            navigationItem.title = MECLocalizedString("mec_confirmation")
            paymentStatusLabel.text = MECLocalizedString("mec_thank_for_order")

            if let placedOrderID = orderDetail?.orderID, placedOrderID.count > 0 {
                let orderDetailText = "\(MECLocalizedString("mec_your_order_number"))\n\(placedOrderID)"
                let orderDetailAttributedText = constructAttributedTextWith(fullText: orderDetailText, highlightedText: placedOrderID)
                orderDescriptionLabel.attributedText = orderDetailAttributedText
            }

            if let emailID = MECConfiguration.shared.getUserEmailID(), emailID.count > 0 {
                let emailDetailText = "\(MECLocalizedString("mec_confirmation_email_msg")) \(emailID)"
                let emailDetailAttributedText = constructAttributedTextWith(fullText: emailDetailText, highlightedText: emailID)
                mailDetailLabel.attributedText = emailDetailAttributedText
            }
        case .paymentPending:
            navigationItem.title = MECLocalizedString("mec_payment_is_pending")
            paymentStatusLabel.text = MECLocalizedString("mec_payment_pending")
            orderDescriptionLabel.text = MECLocalizedString("mec_thank_for_order")
            if let emailID = MECConfiguration.shared.getUserEmailID(), emailID.count > 0 {
                let emailDetailText = "\(MECLocalizedString("mec_payment_pending_confirmation")) \(emailID)"
                let emailDetailAttributedText = constructAttributedTextWith(fullText: emailDetailText, highlightedText: emailID)
                mailDetailLabel.attributedText = emailDetailAttributedText
            }
        }
    }

    func finishMECFlow() {
        guard let orderFlowCompletionDelegate = MECConfiguration.shared.orderFlowCompletionDelegate else {
            popToCataloguePage(bypassDelegateCheck: true)
            return
        }
        if let orderPlacedCallback = orderFlowCompletionDelegate.didPlaceOrder {
            orderPlacedCallback()
            popToCataloguePage(bypassDelegateCheck: false)
        } else {
            popToCataloguePage(bypassDelegateCheck: false)
        }
    }

    func popToCataloguePage(bypassDelegateCheck: Bool) {
        if bypassDelegateCheck {
            navigationController?.popToProductListScreen()
        } else {
            if let shouldPopToCatalogue = MECConfiguration.shared.orderFlowCompletionDelegate?.shouldPopToProductList(),
                shouldPopToCatalogue == true {
                navigationController?.popToProductListScreen()
            }
        }
    }

    private func constructAttributedTextWith(fullText: String, highlightedText: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: fullText.attributedString(lineSpacing: 4))
        if let highlightTextRange = fullText.nsRange(of: highlightedText) {
            attributedText.addAttribute(NSAttributedString.Key.font,
                                        value: UIFont(uidFont: .bold, size: UIDSize16) ?? UIFont(),
                                        range: highlightTextRange)
            return attributedText
        }
        return attributedText
    }
}
