/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSSetDeliveryAddressMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func setDeliveryAddress(address: ECSAddress,
                            isDefaultAddress: Bool,
                            completionHandler: @escaping ECSAddressListCompletion) {

        setDeliveryAddress(deliveryAddress: address,
                           isDefaultAddress: isDefaultAddress) { (_, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            let micro = ECSFetchAddressMicroServices()
            micro.fetchSavedAddressList(completionHandler: completionHandler)
        }
    }

    func setDeliveryAddress(deliveryAddress: ECSAddress,
                            isDefaultAddress: Bool,
                            completionHandler: @escaping ECSCompletion) {

        microServiceError { (error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            guard let appInfra = ECSConfiguration.shared.appInfra,
                let locale = ECSConfiguration.shared.locale,
                let siteId = ECSConfiguration.shared.siteId,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let addressId = deliveryAddress.addressID else {
                    completionHandler(false, ECSHybrisError(with: .ECSaddressId).hybrisError)
                    return
            }

            hybrisRequest = ECSMicroServiceHybrisRequest()
            hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.setDeliveryAddress.rawValue,
                                                        siteId,
                                                        "current",
                                                        "current")
            hybrisRequest?.httpMethod = .PUT
            hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]
            hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
            hybrisRequest?.bodyParameter = [ECSConstant.addressId.rawValue: addressId,
                                            ECSConstant.defaultAddress.rawValue: isDefaultAddress.description]

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
extension ECSSetDeliveryAddressMicroService {

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
