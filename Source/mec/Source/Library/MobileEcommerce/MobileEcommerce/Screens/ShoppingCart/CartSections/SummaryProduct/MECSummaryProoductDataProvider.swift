/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECSummaryProoductDataProvider: NSObject, MECShoppingCartTableDataProvider {

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
        return dataBus.shoppingCart?.data?.attributes?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_cart_summary")
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell,
                                                                        for: indexPath) as? MECSummaryCell,
            indexPath.row < dataBus.shoppingCart?.data?.attributes?.items?.count ?? 0,
            let entry = dataBus.shoppingCart?.data?.attributes?.items?[indexPath.row] else {
                                                                            return UITableViewCell()
        }
        tableCell.primaryLabel.text = "\(entry.quantity ?? 0) x \(entry.title ?? "")"
        tableCell.secondaryLabel.text = "\(entry.totalPrice?.formattedValue ?? "")"
        tableCell.primaryLabel.accessibilityIdentifier = "product_summary"
        tableCell.secondaryLabel.accessibilityIdentifier = "product_price"
        return tableCell
    }
}
