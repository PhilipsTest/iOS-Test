/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import PhilipsUIKitDLS

class MECCheckoutProductDataProvider: NSObject, MECShoppingCartTableDataProvider {

    var dataBus: MECDataBus

    init(with databus: MECDataBus) {
        dataBus = databus
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutProductCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutProductCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBus.shoppingCart?.data?.attributes?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_order_summary")
        headerView.accessibilityIdentifier = "mec_order_summary_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_order_summary_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutProductCell,
                                                              for: indexPath) as? MECCheckoutProductCell,
            indexPath.row < (dataBus.shoppingCart?.data?.attributes?.items?.count ?? 0),
            let entry = dataBus.shoppingCart?.data?.attributes?.items?[indexPath.row] else {
                return UITableViewCell()
        }
        productCell.productNameLabel.text = entry.title
        productCell.productQuantityLabel.text = "\(MECLocalizedString("mec_quantity")): \(entry.quantity ?? 0)"
        productCell.productPriceLabel.text = entry.totalPrice?.formattedValue
        if let imageURL = entry.image,
            let url = URL(string: imageURL) {
            productCell.productImageView.setImageWith(url, placeholderImage: nil)
        }
        return productCell
    }
}
