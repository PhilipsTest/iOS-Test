/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECCheckoutShippingDataProvider: NSObject, MECShoppingCartTableDataProvider {

    var dataBus: MECDataBus

    init(with databus: MECDataBus) {
        dataBus = databus
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutDeliveryModeCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutDeliveryModeCell)
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutShippingCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutShippingCell)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_order_summary_shipping")
        headerView.accessibilityIdentifier = "mec_order_summary_shipping_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_order_summary_shipping_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MECCellIdentifier.MECCheckoutShippingCell, for: indexPath) as? MECCheckoutShippingCell else {
               return UITableViewCell()
            }
            cell.userNameLabel.text = dataBus.shoppingCart?.data?.attributes?.deliveryAddress?.constructFullName()
            cell.shippingAddressLabel.text(dataBus.shoppingCart?.data?.attributes?.deliveryAddress?
                .constructShippingAddressDisplayString() ?? "",
                                           lineSpacing: UIDSize8/2)
            cell.updateUI()
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MECCellIdentifier.MECCheckoutDeliveryModeCell, for: indexPath) as? MECCheckoutDeliveryModeCell else {
               return UITableViewCell()
            }
            cell.updateUI()
            cell.deliveryModeName.text = dataBus.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeName
            cell.deliveryModeDescriptionLabel.text = dataBus.shoppingCart?.data?.attributes?.deliveryMode?.constructDeliveryModeDetails()
            return cell
        }
        return UITableViewCell()
    }
}
