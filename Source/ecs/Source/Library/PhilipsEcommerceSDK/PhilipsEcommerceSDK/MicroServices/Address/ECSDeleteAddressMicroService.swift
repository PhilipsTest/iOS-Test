/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSDeleteAddressMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func deleteAddress(address: ECSAddress, completionHandler: @escaping ECSAddressListCompletion) {

        deleteAddress(savedAddress: address) { (_, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            let micro = ECSFetchAddressMicroServices()
            micro.fetchSavedAddressList(completionHandler: completionHandler)
        }
    }

    func deleteAddress(savedAddress: ECSAddress, completionHandler: @escaping ECSCompletion) {

        microServiceError { (error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            guard let appInfra = ECSConfiguration.shared.appInfra,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let addressId = savedAddress.addressID,
                let siteId = ECSConfiguration.shared.siteId else {
                    completionHandler(false, ECSHybrisError(with: .ECSaddressId).hybrisError)
                    return
            }
            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.updateAddress.rawValue,
                                                        siteId,
                                                        "current",
                                                        addressId)
            hybrisRequest?.httpMethod = .DELETE
            hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]

            ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                     with: appInfra,
                                                                     completionHandler: {(data, error) in
                if error == nil {
                    completionHandler(true, nil)
                    return
                }

                if let data = data,
                    let errorObject = self.getHybrisError(for: data) {
                    completionHandler(false, errorObject.subjectError)
                    return
                } else {
                    completionHandler(false, error)
                }
            })
        }
    }
}

// MARK: - Helper methods
extension ECSDeleteAddressMicroService {

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
