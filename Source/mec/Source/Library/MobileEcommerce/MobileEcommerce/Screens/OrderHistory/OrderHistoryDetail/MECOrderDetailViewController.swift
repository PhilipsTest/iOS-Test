/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import SafariServices

class MECOrderDetailViewController: MECBaseViewController {

    var presenter: MECOrderDetailPresenter?
    var tableDataSource: [MECTableDataProvider] = []

    @IBOutlet weak var bottomView: MECShoppingCartBottomView!
    @IBOutlet weak var orderDetailTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = MECLocalizedString("mec_order_details")
        bottomView.updateUIFor(viewType: .orderHistoryDetail)
        bottomView.updateUIFor(totalProductsCount: presenter?.numberOfProductInCart() ?? 0,
                               tax: presenter?.totalTax() ?? "", totalPrice: presenter?.totalPrice() ?? "")

        guard let orderDetail = presenter?.orderHistoryDetail else { return }
        tableDataSource = [MECOrderDetailShippingDataProvider(with: orderDetail),
                           MECOrderDetailDeliveryModeDataProvider(with: orderDetail),
                           MECOrderDetailPaymentDataProvider(with: orderDetail),
                           MECOrderDetailVoucherDataProvider(with: orderDetail),
                           MECOrderDetailProductDataProvider(with: orderDetail),
                           MECOrderDetailPromotionDataProvider(with: orderDetail),
                           MECOrderDetailDeliveryCostDataProvider(with: orderDetail),
                           MECOrderDetailSummaryVoucherDataProvider(with: orderDetail)]
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        orderDetailTableView.reloadData()
        presenter?.fetchCDLSDetailfor({ ( cdlsResponse ) in
            self.stopActivityProgressIndicator()
            let cdlsDataProvider = MECOrderDetailContactProvider(with: cdlsResponse, orderDetail: orderDetail)
            cdlsDataProvider.registerCell(for: self.orderDetailTableView)
            self.tableDataSource.insert(cdlsDataProvider, at: 0)
            self.orderDetailTableView.reloadData()
        })
        for tableSource in tableDataSource {
            tableSource.registerCell(for: orderDetailTableView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.orderDetail)
    }

    @IBAction func cancelOrderClicked(_ sender: Any) {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.cancelOrder,
            MECAnalyticsConstants.productListKey: prepareCartEntryListString(entries: presenter?.orderHistoryDetail.entries),
                                    MECAnalyticsConstants.transactionID: presenter?.orderHistoryDetail.orderID ?? ""])
        guard let cancelOrder = MECCancelOrderViewController.instantiateFromAppStoryboard(appStoryboard: .orderDetail) else {
            return
        }
        cancelOrder.orderDetail = presenter?.orderHistoryDetail
        cancelOrder.cdls = presenter?.cdls
        self.navigationController?.pushViewController(cancelOrder, animated: true)
    }
}

extension MECOrderDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < tableDataSource.count else { return 0 }
        return tableDataSource[section].tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section < tableDataSource.count else { return 0 }
        return tableDataSource[indexPath.section].tableView(tableView, heightForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < tableDataSource.count else { return 0 }
        return tableDataSource[section].tableView(tableView, heightForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < tableDataSource.count else { return nil }
        return tableDataSource[section].tableView(tableView, viewForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < tableDataSource.count else { return UITableViewCell() }
        let dataSource = tableDataSource[indexPath.section]
        guard let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? MECOrderDetailProductCell else {
            return dataSource.tableView(tableView, cellForRowAt: indexPath)
        }
        cell.delegate = self
        return cell
    }
}

extension MECOrderDetailViewController: MECOrderDetailProductDelegate {
    func didClickOnTrackOrderButton(cell: MECOrderDetailProductCell) {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.trackOrder,
            MECAnalyticsConstants.productListKey: prepareCartEntryListString(entries: presenter?.orderHistoryDetail.entries),
                                    MECAnalyticsConstants.transactionID: presenter?.orderHistoryDetail.orderID ?? ""])
        guard let indexPath = self.orderDetailTableView.indexPath(for: cell),
            let trackingURL = presenter?.trakinURL(at: indexPath.row) else { return }
        trackPage(pageName: MECAnalyticPageNames.trackOrder)
        let safari = SFSafariViewController(url: trackingURL)
        self.present(safari, animated: true, completion: nil)
    }
}
