/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSFetchPaymentMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func fetchPaymentDetails(completionHandler: @escaping ECSFetchPaymentCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            if let appInfra = ECSConfiguration.shared.appInfra, let siteId = ECSConfiguration.shared.siteId,
                let locale = ECSConfiguration.shared.locale, let hybrisToken = ECSConfiguration.shared.hybrisToken {
                hybrisRequest = ECSMicroServiceHybrisRequest()
                hybrisRequest?.httpMethod = .GET
                hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.fetchPaymentList.rawValue,
                                                            siteId,
                                                            "current")
                hybrisRequest?.queryParameter[ECSConstant.lang.rawValue] = locale
                hybrisRequest?.queryParameter[ECSConstant.fields.rawValue] = ECSConstant.full.rawValue
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
                            let paymentList = try jsonDecoder.decode(ECSPaymentList.self, from: data)
                            completionHandler(paymentList.payments, nil)
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
extension ECSFetchPaymentMicroService {

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
