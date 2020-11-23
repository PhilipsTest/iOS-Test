/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECCheckoutVoucherDataProvider: NSObject, MECShoppingCartTableDataProvider {

    var dataBus: MECDataBus

    init(with databus: MECDataBus) {
        dataBus = databus
    }

    var numberOfVouchers: Int {
        return dataBus.shoppingCart?.data?.attributes?.appliedVouchers?.count ?? 0
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutVoucherCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutVoucherCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfVouchers
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return numberOfVouchers > 0 ? 40.0 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard numberOfVouchers > 0 else { return nil }
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_accepted_codes")
        headerView.accessibilityIdentifier = "mec_accepted_codes_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_accepted_codes_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let voucherCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutVoucherCell,
                                            for: indexPath) as? MECCheckoutVoucherCell,
            indexPath.row < (dataBus.shoppingCart?.data?.attributes?.appliedVouchers?.count ?? 0),
            let voucher = dataBus.shoppingCart?.data?.attributes?.appliedVouchers?[indexPath.row] else {
                                        return UITableViewCell()
                                    }
        voucherCell.giftCodeLabel.text = voucher.voucherCode
        voucherCell.discountValueLabel.text = voucher.value?.formattedValue
        if let valueFormatted = voucher.voucherDiscount?.formattedValue {
            voucherCell.percentageDiscountLabel.text = "\(valueFormatted) \(MECLocalizedString("mec_discount")) |"
        } else {
            voucherCell.percentageDiscountLabel.text = ""
        }
        return voucherCell
    }
}
