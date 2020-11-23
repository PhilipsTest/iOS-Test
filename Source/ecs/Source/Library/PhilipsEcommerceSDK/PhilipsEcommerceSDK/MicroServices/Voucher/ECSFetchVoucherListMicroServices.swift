/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSFetchVoucherListMicroServices: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func fetchVoucherList(completionHandler: @escaping ECSVoucherListCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            if let appInfra = ECSConfiguration.shared.appInfra,
                let siteId = ECSConfiguration.shared.siteId,
                let locale = ECSConfiguration.shared.locale,
                let hybrisToken = ECSConfiguration.shared.hybrisToken {
            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.voucher.rawValue,
                                                        siteId,
                                                        "current",
                                                        "current")
            hybrisRequest?.httpMethod = .GET
            hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]
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
                            let voucherList = try jsonDecoder.decode(ECSVoucherList.self, from: data)
                            completionHandler(voucherList.vouchers, nil)
                        } else {
                            completionHandler(nil, ECSHybrisError().hybrisError)
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
extension ECSFetchVoucherListMicroServices {

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
