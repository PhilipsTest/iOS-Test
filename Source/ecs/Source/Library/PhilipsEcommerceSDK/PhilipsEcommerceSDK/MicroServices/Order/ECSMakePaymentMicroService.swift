/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSMakePaymentMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func makePayment(for order: ECSOrderDetail,
                     billingAddress: ECSAddress,
                     completionHandler: @escaping ECSMakePaymentCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let appInfra = ECSConfiguration.shared.appInfra,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let siteId = ECSConfiguration.shared.siteId, let orderId = order.orderID else {
                    completionHandler(nil, ECSHybrisError(with: .ECSorderIdNil).hybrisError)
                    return
            }

            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.httpMethod = .POST
            hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.makePayment.rawValue, siteId,
                                                        "current",
                                                        orderId)
            hybrisRequest?.bodyParameter = billingAddress.addressParameter
            ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                     with: appInfra,
                                                                     completionHandler: {(data, error) in
                do {
                    if let data = data {
                        if let errorObject = self.getHybrisError(for: data), error != nil {
                            completionHandler(nil, errorObject.subjectError)
                            return
                        }
                        let jsonDecoder = JSONDecoder()
                        let paymentDetail = try jsonDecoder.decode(ECSPaymentProvider.self, from: data)
                        completionHandler(paymentDetail, nil)
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

// MARK: - Helper methods
extension ECSMakePaymentMicroService {

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
