/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECCartProductDataProvider: NSObject, MECShoppingCartTableDataProvider {

    var dataBus: MECDataBus

    init(cartDataBus: MECDataBus) {
        dataBus = cartDataBus
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECShoppingCartProductCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECShoppingCartProductCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBus.shoppingCart?.data?.attributes?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        let itemCount = dataBus.shoppingCart?.data?.attributes?.items?.count ?? 0
        headerView.headerLabel.text = "\(itemCount) \(MECLocalizedString("mec_product_title"))"
        headerView.accessibilityIdentifier = "mec_cart_products_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_cart_products_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECShoppingCartProductCell,
                                                                        for: indexPath) as? MECShoppingCartProductCell else {
                                                                            return UITableViewCell()
        }
        return tableCell
    }
}
