/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK

class MECOrderDetailPromotionDataProvider: NSObject, MECTableDataProvider {
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
        return orderHistoryDetail.appliedOrderPromotions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell,
                                                                        for: indexPath) as? MECSummaryCell,
                                        indexPath.row < (orderHistoryDetail.appliedOrderPromotions?.count ?? 0),
                                        let promotion = orderHistoryDetail.appliedOrderPromotions?[indexPath.row] else {
                                                                            return UITableViewCell()
        }
        tableCell.primaryLabel.text = promotion.promotion?.name
        tableCell.secondaryLabel.text = "- \(promotion.promotion?.promotionDiscount?.formattedValue ?? "")"
        tableCell.primaryLabel.accessibilityIdentifier = "orderPromotion_summary"
        tableCell.secondaryLabel.accessibilityIdentifier = "orderPromotion_price"
        return tableCell
    }
}
