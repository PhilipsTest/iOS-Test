/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSFetchOrderHistoryMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func fetchOrderHistory(pageSize: Int,
                           currentPage: Int,
                           completionHandler: @escaping ECSFetchOrderHistoryCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            if let appInfra = ECSConfiguration.shared.appInfra,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let siteID = ECSConfiguration.shared.siteId {

                hybrisRequest = ECSMicroServiceHybrisRequest()
                hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.order.rawValue,
                                                             siteID,
                                                             "current")
                hybrisRequest?.httpMethod = .GET
                hybrisRequest?.queryParameter = [ECSConstant.currentPage.rawValue: "\(currentPage)",
                    ECSConstant.pageSize.rawValue: "\(pageSize)"]
                hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]

                ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                         with: appInfra,
                                                                         completionHandler: {(data, error) in
                    do {
                        if let data = data {
                            if let errorObject = self.getHybrisError(for: data), error != nil {
                                completionHandler(nil, errorObject.hybrisError)
                                return
                            }
                            let jsonDecoder = JSONDecoder()
                            let orderHistory = try jsonDecoder.decode(ECSOrderHistory.self, from: data)
                            completionHandler(orderHistory, error)
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
    }
}

// MARK: - Helper methods
extension ECSFetchOrderHistoryMicroService {

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
