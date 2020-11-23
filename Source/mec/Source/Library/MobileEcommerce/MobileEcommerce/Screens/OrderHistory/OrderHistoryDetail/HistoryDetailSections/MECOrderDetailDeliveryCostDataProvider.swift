/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK

class MECOrderDetailDeliveryCostDataProvider: NSObject, MECTableDataProvider {
    var orderHistoryDetail: ECSOrderDetail
    init(with orderDetail: ECSOrderDetail) {
        orderHistoryDetail = orderDetail
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECSummaryCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECSummaryCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell,
                                                            for: indexPath) as? MECSummaryCell,
            let deliveryCost = orderHistoryDetail.deliveryCost else {
                return UITableViewCell()
        }
        tableCell.primaryLabel.text = MECLocalizedString("mec_shipping_cost")
        tableCell.secondaryLabel.text = deliveryCost.formattedValue ?? "0.00"
        tableCell.primaryLabel.accessibilityIdentifier = "shippingCost_summary"
        tableCell.secondaryLabel.accessibilityIdentifier = "shippingCost_price"
        return tableCell
    }
}
