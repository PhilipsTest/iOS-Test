/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK

class MECOrderDetailSummaryVoucherDataProvider: NSObject, MECTableDataProvider {
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
        return orderHistoryDetail.appliedVouchers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell,
                                                            for: indexPath) as? MECSummaryCell,
                                                indexPath.row < (orderHistoryDetail.appliedVouchers?.count ?? 0) else {
                                                            return UITableViewCell()
        }
        let voucher = orderHistoryDetail.appliedVouchers?[indexPath.row]
        tableCell.primaryLabel.text = voucher?.name
        tableCell.secondaryLabel.text = " - \(voucher?.appliedValue?.formattedValue ?? "")"
        tableCell.primaryLabel.accessibilityIdentifier = "Voucher_summary"
        tableCell.secondaryLabel.accessibilityIdentifier = "Voucher_price"
        return tableCell
    }
}
