/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECApplyVoucherDataProvider: NSObject, MECShoppingCartTableDataProvider, MECAnalyticsTracking {

    var dataBus: MECDataBus

    init(cartDataBus: MECDataBus) {
        dataBus = cartDataBus
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECApplyVoucherCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECApplyVoucherCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowApplyVoucher() ? 1 : 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return shouldShowApplyVoucher() ? 40 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard shouldShowApplyVoucher() else { return nil }

        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_add_gift_codes")
        headerView.accessibilityIdentifier = "mec_add_gift_codes_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_add_gift_codes_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECApplyVoucherCell,
                                                                        for: indexPath) as? MECApplyVoucherCell,
                                                                                    shouldShowApplyVoucher() else {
                                                                            return UITableViewCell()
        }
        return tableCell
    }

    func shouldShowApplyVoucher() -> Bool {
        do {
            guard let voucherStatus = try MECConfiguration.shared.sharedAppInfra
                .appConfig.getPropertyForKey("voucherCode.enable",
                                             group: MECConstants.MECTLA) as? Int else {
                return false
            }
            return voucherStatus == 1
        } catch {
            trackTechnicalError(errorCategory: MECAnalyticErrorCategory.appError,
                                serverName: MECAnalyticServer.other, error: error)
            return false
        }
    }
}
