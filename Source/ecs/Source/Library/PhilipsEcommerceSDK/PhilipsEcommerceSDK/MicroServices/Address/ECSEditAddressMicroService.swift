/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSEditAddressMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func editSavedAddress(address: ECSAddress, completionHandler:@escaping ECSCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }

            guard let siteId = ECSConfiguration.shared.siteId,
                let addressId = address.addressID,
                let appInfra = ECSConfiguration.shared.appInfra,
                let locale = ECSConfiguration.shared.locale,
                let hybrisToken = ECSConfiguration.shared.hybrisToken else {
                completionHandler(false, ECSHybrisError(with: .ECSaddressId).hybrisError)
                return
            }

            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.updateAddress.rawValue,
                                                        siteId,
                                                        "current",
                                                        addressId)
            hybrisRequest?.httpMethod = .PUT
            hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]
            hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
            hybrisRequest?.bodyParameter = address.addressParameter

            ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                     with: appInfra,
                                                                     completionHandler: {(data, error) in
                if error == nil {
                    completionHandler(true, nil)
                    return
                }
                if let data = data, let errorObject = self.getHybrisError(for: data),
                    error != nil {
                    completionHandler(false, errorObject.subjectError)
                    return
                }
                completionHandler(false, error)
            })
        }
    }

    func editSavedAddress(with address: ECSAddress,
                          completionHandler:@escaping ECSAddressListCompletion) {
        editSavedAddress(address: address) { (_, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            ECSFetchAddressMicroServices().fetchSavedAddressList(completionHandler: completionHandler)
        }
    }
}

// MARK: - Helper methods
extension ECSEditAddressMicroService {

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
