/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class MECOrderPromotionDataProvider: NSObject, MECShoppingCartTableDataProvider {

    var dataBus: MECDataBus

    init(cartDataBus: MECDataBus) {
        dataBus = cartDataBus
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECSummaryCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECSummaryCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBus.shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell,
                                                                        for: indexPath) as? MECSummaryCell,
            indexPath.row < (dataBus.shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?.count ?? 0),
            let promotion = dataBus.shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?[indexPath.row] else {
                                                                            return UITableViewCell()
        }
        tableCell.primaryLabel.text = promotion.promotionCode
        tableCell.secondaryLabel.text = "- \(promotion.promotionDiscount?.formattedValue ?? "")"
        tableCell.primaryLabel.accessibilityIdentifier = "orderPromotion_summary"
        tableCell.secondaryLabel.accessibilityIdentifier = "orderPromotion_price"
        return tableCell
    }
}
