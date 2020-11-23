/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class MECSummaryVoucherDataProvider: NSObject, MECShoppingCartTableDataProvider {

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
        return dataBus.shoppingCart?.data?.attributes?.appliedVouchers?.count ?? 0
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
            indexPath.row < (dataBus.shoppingCart?.data?.attributes?.appliedVouchers?.count ?? 0) else {
                                                            return UITableViewCell()
        }
        let voucher = dataBus.shoppingCart?.data?.attributes?.appliedVouchers?[indexPath.row]
        tableCell.primaryLabel.text = voucher?.name
        tableCell.secondaryLabel.text = " - \(voucher?.value?.formattedValue ?? "")"
        tableCell.primaryLabel.accessibilityIdentifier = "Voucher_summary"
        tableCell.secondaryLabel.accessibilityIdentifier = "Voucher_price"
        return tableCell
    }
}
