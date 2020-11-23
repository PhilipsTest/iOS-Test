/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MECOrderHistoryPresenter: MECBasePresenter {

    var paginationHandler: MECPaginationHelper
    var orderDisplayDates: [String]?
    var placedOrders: [String: [ECSOrder]]?

    override init() {
        paginationHandler = MECPaginationHelper()
        orderDisplayDates = []
        placedOrders = [:]
        super.init()
    }
}

extension MECOrderHistoryPresenter {

    func fetchOrderHistory(completionHandler: @escaping (_ error: Error?) -> Void) {
        let productDetailsGroupDownload = DispatchGroup()
        paginationHandler.isDataFetching = true
        MECConfiguration.shared.ecommerceService?.fetchOrderHistory(currentPage: paginationHandler.getNextPage(),
                                                                    completionHandler: { [weak self] (orderHistory, error) in
            guard error == nil else {
                self?.paginationHandler.isDataFetching = false
                error?.handleOauthError(completion: { (handled, error) in
                    if handled == true {
                        self?.fetchOrderHistory(completionHandler: completionHandler)
                    } else {
                        completionHandler(error)
                    }
                })
                return
            }
            self?.paginationHandler.paginationModel = orderHistory?.pagination
            guard let orders = orderHistory?.orders else {
                self?.paginationHandler.isDataFetching = false
                completionHandler(nil)
                return
            }
            orders.forEach { (order) in
                self?.updatePlacedOrderListWith(order: order)
                productDetailsGroupDownload.enter()
                self?.fetchDetailsForOrder(order: order, completionHandler: {
                    productDetailsGroupDownload.leave()
                })
            }
            productDetailsGroupDownload.notify(queue: DispatchQueue.main) {
                self?.paginationHandler.isDataFetching = false
                completionHandler(nil)
            }
        })
    }

    func fetchDetailsForOrder(order: ECSOrder, completionHandler: @escaping () -> Void) {
        MECConfiguration.shared.ecommerceService?.fetchOrderDetailsFor(order: order, completionHandler: { (_, error) in
            guard error == nil else {
                error?.handleOauthError(completion: { [weak self] (handled, _) in
                    if handled == true {
                        self?.fetchDetailsForOrder(order: order, completionHandler: completionHandler)
                    } else {
                        completionHandler()
                    }
                })
                return
            }
            completionHandler()
        })
    }

    func fetchTotalNumberOfOrders() -> Int {
        return orderDisplayDates?.count ?? 0
    }

    func fetchNumberOfOrderFor(section: Int) -> Int {
        if let orderDateToDisplay = orderDisplayDates?[section] {
            return placedOrders?[orderDateToDisplay]?.count ?? 0
        }
        return 0
    }

    func fetchOrderFor(indexPath: IndexPath) -> ECSOrder? {
        if let orderDateToDisplay = orderDisplayDates?[indexPath.section] {
            return placedOrders?[orderDateToDisplay]?[indexPath.row]
        }
        return nil
    }

    func fetchOrderDisplayDateFor(section: Int) -> String {
        return orderDisplayDates?[section] ?? ""
    }

    func fetchProductImageURLFor(orderEntry: ECSEntry) -> String {
        if let imageURLString = orderEntry.product?.productPRXSummary?.imageURL {
            return "\(imageURLString)?wid=40&hei=40&$pnglarge$&fit=fit,1"
        }
        return ""
    }

    func shouldLoadMoreOrders() -> Bool {
        return paginationHandler.haveMoreProductsToLoad()
    }

    func updatePlacedOrderListWith(order: ECSOrder) {
        guard let orderPlacedString = order.placedDateString else {
            return
        }
        let formattedOrderPlacedString = MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate: orderPlacedString)
        if orderDisplayDates?.contains(formattedOrderPlacedString) == false {
            orderDisplayDates?.append(formattedOrderPlacedString)
        }
        var orderPlacedValue = placedOrders?[formattedOrderPlacedString]
        if orderPlacedValue != nil {
            orderPlacedValue?.append(order)
            placedOrders?[formattedOrderPlacedString] = orderPlacedValue
        } else {
            var newOrders: [ECSOrder] = []
            newOrders.append(order)
            placedOrders?[formattedOrderPlacedString] = newOrders
        }
    }
}
