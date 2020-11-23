/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

class ECSFetchOrderHistoryDetailsMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func fetchOrderDetailFor(orderDetail: ECSOrderDetail, completionHandler: @escaping ECSFetchOrderCompletion) {
        fetchOrderDetailFor(orderID: orderDetail.orderID ?? "", completionHandler: completionHandler)
    }

    func fetchOrderDetailFor(order: ECSOrder, completionHandler: @escaping ECSFetchOrderDetailsCompletion) {
        fetchOrderDetailFor(orderID: order.orderID ?? "") { (orderDetails, error) in
            if let orderDetails = orderDetails {
                order.orderDetails = orderDetails
            }
            completionHandler(order, error)
        }
    }

   // swiftlint:disable function_body_length
    func fetchOrderDetailFor(orderID: String,
                             completionHandler: @escaping ECSFetchOrderCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let appInfra = ECSConfiguration.shared.appInfra,
                let locale = ECSConfiguration.shared.locale,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let siteID = ECSConfiguration.shared.siteId,
                orderID.count > 0 else {
                    completionHandler(nil, ECSHybrisError(with: .ECSUnknownIdentifierError).hybrisError)
                    return
            }
            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.orderDetails.rawValue,
                                                        siteID, "current", orderID)
            hybrisRequest?.httpMethod = .GET
            hybrisRequest?.queryParameter = [ECSConstant.fields.rawValue: ECSConstant.full.rawValue,
                                             ECSConstant.lang.rawValue: "\(locale)"]
            hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: "\(hybrisToken)"]
            ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                     with: appInfra,
                                                                     completionHandler: {(data, error) in
                do {
                    if let data = data {
                        if let errorObject = self.getHybrisError(for: data), error != nil {
                            completionHandler(nil, errorObject.hybrisError)
                            return
                        }
                        let orderHistoryDetails = try JSONDecoder().decode(ECSOrderDetail.self, from: data)
                        if let orderHistoryEntries = orderHistoryDetails.entries, orderHistoryEntries.count > 0 {
                            let ctns: [String] = orderHistoryEntries.map({ $0.product?.ctn ?? "" })
                            ECSProductDetailsMicroServices().fetchProductSummaryFor(ctns: ctns,
                                                                        completionHandler: { (productSummaries, error) in
                                guard let summaryList = productSummaries else {
                                    completionHandler(orderHistoryDetails, error)
                                    return
                                }
                                self.setUpProductData(for: orderHistoryEntries,
                                                      with: summaryList.data as? [PRXSummaryData] ?? [])
                                completionHandler(orderHistoryDetails, nil)
                            })
                        } else {
                            completionHandler(orderHistoryDetails, nil)
                        }
                    } else {
                        completionHandler(nil, error)
                    }
                } catch {
                    ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                           eventId: "ECSParsingError",
                                                           message: "\(error.fetchCatchErrorMessage())")
                    completionHandler(nil, ECSHybrisError().hybrisError)
                }
            })
        }
    }
    // swiftlint:enable function_body_length
}

// MARK: - Helper methods
extension ECSFetchOrderHistoryDetailsMicroService {

    func setUpProductData(for orderHistoryEntries: [ECSEntry], with productSummary: [PRXSummaryData]) {
        var productSummaryData = [String: PRXSummaryData]()
        productSummary.forEach({
            if let ctn = $0.ctn {
                productSummaryData[ctn] = $0
            }
        })

        for orderEntry in orderHistoryEntries {
            if let productSummary = productSummaryData[orderEntry.product?.ctn ?? ""] {
                orderEntry.product?.productPRXSummary = productSummary
            }
        }
    }

    func microServiceError(completion: ECSValidationCompletion) {
        commonValidation { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            guard ECSConfiguration.shared.hybrisToken != nil else {
                completion(ECSHybrisError(with: .ECSOAuthNotCalled).hybrisError)
                return
            }
            guard ECSConfiguration.shared.siteId != nil else {
                completion(ECSHybrisError(with: .ECSSiteIdNotFound).hybrisError)
                return
            }
            completion(nil)
        }
    }
}
