/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECOrderDetailShippingDataProvider: NSObject, MECTableDataProvider {
    var orderHistoryDetail: ECSOrderDetail
    init(with orderDetail: ECSOrderDetail) {
        orderHistoryDetail = orderDetail
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutShippingCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutShippingCell)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_order_summary_shipping")
        headerView.accessibilityIdentifier = "mec_order_history_shipping_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_order_history_shipping_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (orderHistoryDetail.deliveryMode != nil || orderHistoryDetail.deliveryAddress != nil) ? 40 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryDetail.deliveryAddress != nil ? 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MECCellIdentifier.MECCheckoutShippingCell, for: indexPath) as? MECCheckoutShippingCell else {
                return UITableViewCell()
        }
        cell.userNameLabel.text = orderHistoryDetail.deliveryAddress?.constructFullName()
        cell.shippingAddressLabel.text(orderHistoryDetail.deliveryAddress?.constructShippingAddressDisplayString() ?? "",
                                       lineSpacing: UIDSize8/2)
        cell.updateUI()
        return cell
    }
}

class MECOrderDetailDeliveryModeDataProvider: NSObject, MECTableDataProvider {
    var orderHistoryDetail: ECSOrderDetail
    init(with orderDetail: ECSOrderDetail) {
        orderHistoryDetail = orderDetail
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutDeliveryModeCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutDeliveryModeCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryDetail.deliveryMode != nil ? 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MECCellIdentifier.MECCheckoutDeliveryModeCell, for: indexPath) as? MECCheckoutDeliveryModeCell else {
                return UITableViewCell()
        }
        cell.updateUI()
        cell.deliveryModeName.text = orderHistoryDetail.deliveryMode?.deliveryModeName
        cell.deliveryModeDescriptionLabel.text = orderHistoryDetail.deliveryMode?.constructDeliveryModeDetails()
        return cell
    }
}
