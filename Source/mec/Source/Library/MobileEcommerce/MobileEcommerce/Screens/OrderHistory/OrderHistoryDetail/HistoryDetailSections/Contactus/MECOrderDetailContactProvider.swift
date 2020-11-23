/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import PhilipsEcommerceSDK
import PhilipsPRXClient

class MECOrderDetailContactProvider: NSObject, MECTableDataProvider, MECAnalyticsTracking {

    var cdlsData: PRXCDLSResponse?
    var orderHistoryDetail: ECSOrderDetail

    init(with cdls: PRXCDLSResponse?, orderDetail: ECSOrderDetail) {
        cdlsData = cdls
        orderHistoryDetail = orderDetail
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(UINib.init(nibName: MECNibName.MECOrderDetailContactCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECOrderDetailContactCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        if let orderDate = orderHistoryDetail.created {
            headerView.headerLabel.text = MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate: orderDate)
        }
        headerView.accessibilityIdentifier = "mec_order_history_contact"
        headerView.headerLabel.accessibilityIdentifier = "mec_order_history_contact_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECOrderDetailContactCell,
                                                              for: indexPath) as? MECOrderDetailContactCell else {
                                                                return UITableViewCell()
        }
        contactCell.coonfigureUI()
        contactCell.delegate = self
        contactCell.orderStatusLabel.text = String(format: MECLocalizedString("mec_order_state"), orderHistoryDetail.statusDisplay ?? "")
        contactCell.orderIdLabel.text = String(format: MECLocalizedString("mec_order_number_msg"), orderHistoryDetail.orderID ?? "")

        guard let cdlsResponse = cdlsData else {
            contactCell.weekdayopeningHour.isHidden = true
            contactCell.weekendOpeningHour.isHidden = true
            contactCell.consumerCareInfo.isHidden = true
            contactCell.callusButton.isHidden = true
            return contactCell
        }

        contactCell.weekdayopeningHour?.text = cdlsResponse.data?.contactPhone?.first?.openingHoursWeekdays
        if let openingHour = cdlsResponse.data?.contactPhone?.first?.openingHoursSaturday {
            contactCell.weekendOpeningHour?.text = openingHour
        } else {
            contactCell.weekendOpeningHour?.text = cdlsResponse.data?.contactPhone?.first?.openingHoursSunday
        }

        if let phoneNumber = cdlsResponse.data?.contactPhone?.first?.phoneNumber {
            updateCallUsButton(phoneNumber, contactCell: contactCell)
            updateConsumerCareInfo(phoneNumber, contactCell: contactCell)
        }
        return contactCell
    }

    func updateCallUsButton(_ phoneNumber: String, contactCell: MECOrderDetailContactCell) {
        contactCell.callusButton.setTitle("\(MECLocalizedString("mec_call"))  \(phoneNumber)", for: .normal)
    }

    func updateConsumerCareInfo(_ phoneNumber: String, contactCell: MECOrderDetailContactCell) {
        contactCell.consumerCareInfo.text = String(format: MECLocalizedString("mec_contact_philips_consumer_care"), phoneNumber)
    }
}

extension MECOrderDetailContactProvider: MECContactUsDelegate {
    func didClickOnCallUs(cell: MECOrderDetailContactCell) {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.callCustomerCare,
                                     MECAnalyticsConstants.productListKey: prepareCartEntryListString(entries: orderHistoryDetail.entries),
                                    MECAnalyticsConstants.transactionID: orderHistoryDetail.orderID ?? ""])

        guard let url = MECUtility.getPhoneNumberURL(inPhoneNumber: cdlsData?.data?.contactPhone?.first?.phoneNumber) else { return }
        #if targetEnvironment(simulator)
            // Alert for Simulator
        #else
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        #endif
    }
}
