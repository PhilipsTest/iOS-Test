/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECCheckoutPaymentDataProvider: NSObject, MECShoppingCartTableDataProvider {

    var dataBus: MECDataBus

    init(with databus: MECDataBus) {
        dataBus = databus
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECCheckoutPaymentCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECCheckoutPaymentCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_payment_method")
        headerView.accessibilityIdentifier = "mec_payment_method_view"
        headerView.headerLabel.accessibilityIdentifier = "mec_payment_method_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let paymentCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutPaymentCell,
                                                              for: indexPath) as? MECCheckoutPaymentCell,
            let selectedPayment = dataBus.paymentsInfo?.selectedPayment else {
                return UITableViewCell()
        }

        paymentCell.configureUI()
        paymentCell.cardNumberLabel.text = selectedPayment.constructCardDetails()
        paymentCell.cardExpiryLabel.text = selectedPayment.constructPaymentValidityDetails()
        paymentCell.cardHolderNameLabel.text = selectedPayment.fetchAccountHolderName()
        paymentCell.cardAddressLabel.text(selectedPayment.billingAddress?.constructShippingAddressDisplayString() ?? "",
                                          lineSpacing: UIDSize8/2)
        return paymentCell
    }
}
