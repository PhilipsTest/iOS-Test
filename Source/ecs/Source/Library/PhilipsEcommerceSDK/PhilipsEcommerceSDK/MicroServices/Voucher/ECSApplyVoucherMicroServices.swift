/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSApplyVoucherMicroServices: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func applyVoucher(voucherID: String, completionHandler: @escaping ECSVoucherListCompletion) {
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
                hybrisRequest?.httpMethod = .POST
                hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]
                hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
                hybrisRequest?.bodyParameter = [ECSConstant.voucherId.rawValue: voucherID]

                ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                         with: appInfra,
                                                                         completionHandler: {(data, error) in
                    if let data = data,
                        let errorObject = self.getHybrisError(for: data),
                        error != nil {
                        completionHandler(nil, errorObject.hybrisError)
                        return
                    }
                    if error == nil {
                        ECSFetchVoucherListMicroServices().fetchVoucherList(completionHandler: completionHandler)
                    } else {
                        completionHandler(nil, error)
                    }
                })
            }
        }
    }
}

// MARK: - Helper methods
extension ECSApplyVoucherMicroServices {

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
