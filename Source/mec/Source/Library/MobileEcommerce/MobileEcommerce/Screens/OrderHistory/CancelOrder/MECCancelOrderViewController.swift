/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import PhilipsPRXClient
import PhilipsEcommerceSDK

class MECCancelOrderViewController: MECBaseViewController {

    @IBOutlet weak var cancelOrderTitleLabel: UIDLabel!
    @IBOutlet weak var cancelOrderMessage: UIDLabel!
    @IBOutlet weak var referenceTitleLabel: UIDLabel!
    @IBOutlet weak var weekDayLabel: UIDLabel!
    @IBOutlet weak var weekendLabel: UIDLabel!
    @IBOutlet weak var callUsButton: UIDButton!

    var orderDetail: ECSOrderDetail?
    var cdls: PRXCDLSResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = MECLocalizedString("mec_cancel_your_order")
        cancelOrderMessage.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        weekDayLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        weekendLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        referenceTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText

        cancelOrderTitleLabel.text = "\(MECLocalizedString("mec_cancel_order_number")) \(orderDetail?.orderID ?? "")"
        cancelOrderMessage.text(MECLocalizedString("mec_cancel_order_dls_msg"), lineSpacing: UIDSize8/2)

        let referenceMessage = String(format: MECLocalizedString("mec_cancel_order_dls_for_your_ref_sg"),
                                      orderDetail?.orderID ?? "")
        let attributedText = NSMutableAttributedString(attributedString: referenceMessage.attributedString(lineSpacing: 4))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont(uidFont: .bold, size: UIDSize16) ?? UIFont()],
                                     range: referenceMessage.nsRange(of: orderDetail?.orderID ?? "") ?? NSRange())
        referenceTitleLabel.attributedText = attributedText

        // Hidding all the controls related to CDLS
        guard let cdls = cdls else {
            weekendLabel.isHidden = true
            weekDayLabel.isHidden = true
            callUsButton.isHidden = true
            return
        }
        weekDayLabel.text = cdls.data?.contactPhone?.first?.openingHoursWeekdays
        if let openingHour = cdls.data?.contactPhone?.first?.openingHoursSaturday {
            weekendLabel?.text = openingHour
        } else {
            weekendLabel?.text = cdls.data?.contactPhone?.first?.openingHoursSunday
        }
        guard let phoneNumber = cdls.data?.contactPhone?.first?.phoneNumber else {
            callUsButton.setTitle(MECLocalizedString("mec_call"), for: .normal)
            return
        }
        callUsButton.setTitle("\(MECLocalizedString("mec_call"))  \(phoneNumber)", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.cancelOrder)
    }

    @IBAction func callUsButtonClicked(_ sender: Any) {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.callCustomerCare,
                                    MECAnalyticsConstants.productListKey: prepareCartEntryListString(entries: orderDetail?.entries),
                                    MECAnalyticsConstants.transactionID: orderDetail?.orderID ?? ""])

        guard let url = MECUtility.getPhoneNumberURL(inPhoneNumber: cdls?.data?.contactPhone?.first?.phoneNumber) else { return }
        #if targetEnvironment(simulator)
            // Alert for Simulator
        #else
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        #endif
    }
}
