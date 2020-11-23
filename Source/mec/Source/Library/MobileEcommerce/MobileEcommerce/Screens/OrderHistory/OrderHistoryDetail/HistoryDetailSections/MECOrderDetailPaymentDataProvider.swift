/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECOrderDetailPaymentDataProvider: NSObject, MECTableDataProvider {

    var orderHistoryDetail: ECSOrderDetail
    init(with orderDetail: ECSOrderDetail) {
        orderHistoryDetail = orderDetail
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutPaymentCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutPaymentCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryDetail.paymentInfo != nil ? 1 : 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return orderHistoryDetail.paymentInfo != nil ? 40.0 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_payment_method")
        headerView.accessibilityIdentifier = "mec_orderHistory_payment_method_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_orderHistory_payment_method_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let paymentCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutPaymentCell,
                                                              for: indexPath) as? MECCheckoutPaymentCell,
            let selectedPayment = orderHistoryDetail.paymentInfo else {
                return UITableViewCell()
        }

        paymentCell.configureUI()
        paymentCell.cardNumberLabel.text = selectedPayment.constructCardDetails()
        paymentCell.cardExpiryLabel.text = selectedPayment.constructPaymentValidityDetails()
        paymentCell.cardHolderNameLabel.text = selectedPayment.fetchAccountHolderName()
        paymentCell.cardAddressLabel.text(selectedPayment.billingAddress?.constructShippingAddressDisplayString() ?? "",
                                          lineSpacing: UIDSize8/2)
        return paymentCell
    }
}
