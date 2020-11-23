/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSSubmitOrderMicroServices: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func submitOrder(cvvCode: String? = nil, completionHandler: @escaping ECSubmitOrderCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            if let appInfra = ECSConfiguration.shared.appInfra,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let siteId = ECSConfiguration.shared.siteId {

                hybrisRequest = ECSMicroServiceHybrisRequest()
                hybrisRequest?.httpMethod = .POST
                hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
                hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.order.rawValue, siteId,
                                                            "current")
                if let cvvCodeText = cvvCode, cvvCodeText.count > 0 {
                    hybrisRequest?.bodyParameter[ECSConstant.securityCode.rawValue] = cvvCodeText
                }
                hybrisRequest?.bodyParameter[ECSConstant.cartId.rawValue] = "current"

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
                            let orderDetail = try jsonDecoder.decode(ECSOrderDetail.self, from: data)
                            completionHandler(orderDetail, nil)

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
extension ECSSubmitOrderMicroServices {

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
