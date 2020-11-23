/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSSetPaymentMethodMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func setPaymentDetail(paymentDetail: ECSPayment, completionHandler: @escaping ECSCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            guard let appInfra = ECSConfiguration.shared.appInfra,
                let paymentId = paymentDetail.paymentId,
                let locale = ECSConfiguration.shared.locale,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let siteId = ECSConfiguration.shared.siteId else {
                    completionHandler(false, ECSHybrisError(with: .ECSInvalidPaymentInfoError).hybrisError)
                return
            }
            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.setPaymentDetail.rawValue,
                                                        siteId,
                                                        "current",
                                                        "current")
            hybrisRequest?.httpMethod = .PUT
            hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
            hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]
            hybrisRequest?.bodyParameter = [ECSConstant.paymentDetailsId.rawValue: paymentId]
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
extension ECSSetPaymentMethodMicroService {

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
