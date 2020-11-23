/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class MECCheckoutStepProvider: NSObject, MECShoppingCartTableDataProvider {

    var dataBus: MECDataBus

    init(with databus: MECDataBus) {
        dataBus = databus
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECStepDetail,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECStepDetail)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stepCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECStepDetail,
                                                              for: indexPath) as? MECStepDetail else {
                                                                return UITableViewCell()
        }
        stepCell.deliveryStepView.currentDeliveryDetailsStep = .checkout
        return stepCell
    }
}
