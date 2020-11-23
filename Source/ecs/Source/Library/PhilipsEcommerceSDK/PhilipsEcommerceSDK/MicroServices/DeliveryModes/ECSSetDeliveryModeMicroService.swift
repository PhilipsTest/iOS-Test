/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSSetDeliveryModeMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func setDeliveryMode(deliveryMode: ECSDeliveryMode, completionHandler: @escaping ECSCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            guard let appInfra = ECSConfiguration.shared.appInfra,
                let deliveryModeID = deliveryMode.deliveryModeId,
                let siteId = ECSConfiguration.shared.siteId,
                let hybrisToken = ECSConfiguration.shared.hybrisToken else {
                    completionHandler(false,
                                      ECSHybrisError(with: .ECSUnsupportedDeliveryModeError).hybrisError)
                    return
            }

            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.setDeliveryMode.rawValue,
                                                        siteId,
                                                        "current",
                                                        "current")
            hybrisRequest?.httpMethod = .PUT
            hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
            hybrisRequest?.bodyParameter = [ECSConstant.deliveryModeId.rawValue: deliveryModeID]

            ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                     with: appInfra,
                                                                     completionHandler: {(data, error) in
                if error == nil {
                    completionHandler(true, nil)
                    return
                }

                if let data = data,
                    let errorObject = self.getHybrisError(for: data) {
                    completionHandler(false, errorObject.hybrisError)
                    return
                } else {
                    completionHandler(false, error)
                }
            })
        }
    }
}

// MARK: - Helper methods
extension ECSSetDeliveryModeMicroService {

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
