/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECOrderDetailProductDataProvider: NSObject, MECTableDataProvider {
    var orderHistoryDetail: ECSOrderDetail

    init(with orderDetail: ECSOrderDetail) {
        orderHistoryDetail = orderDetail
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECOrderDetailProductCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECOrderDetailProductCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryDetail.entries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_order_summary")
        headerView.accessibilityIdentifier = "mec_order_history_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_order_history_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECOrderDetailProductCell,
                                                              for: indexPath) as? MECOrderDetailProductCell,
            indexPath.row < (orderHistoryDetail.entries?.count ?? 0),
            let entry = orderHistoryDetail.entries?[indexPath.row] else {
                return UITableViewCell()
        }
        productCell.configureUI()
        productCell.productNameLabel.text = entry.product?.productPRXSummary?.productTitle
        productCell.productQuantityLabel.text = "\(MECLocalizedString("mec_quantity")): \(entry.quantity ?? 0)"
        productCell.productPriceLabel.text = entry.totalPrice?.formattedValue
        if let imageURL = entry.product?.productPRXSummary?.imageURL,
            let url = URL(string: imageURL) {
            productCell.productImageView.setImageWith(url, placeholderImage: nil)
        }
        if let entry = orderHistoryDetail.consignments?.first?.entries?[indexPath.row],
            entry.trackAndTraceUrls?.first != nil {
            productCell.trackOrderButton.isEnabled = true
        } else {
            productCell.trackOrderButton.isEnabled = false
        }
        return productCell
    }
}
