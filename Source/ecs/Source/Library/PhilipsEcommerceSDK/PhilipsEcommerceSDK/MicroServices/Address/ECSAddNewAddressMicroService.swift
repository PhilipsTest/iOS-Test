/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSAddNewAddressMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func createNewAddress(address: ECSAddress, completionHandler:@escaping ECSAddressCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            if let appInfra = ECSConfiguration.shared.appInfra,
                let locale = ECSConfiguration.shared.locale,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let siteId = ECSConfiguration.shared.siteId {

                hybrisRequest = ECSMicroServiceHybrisRequest()
                hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.addresses.rawValue,
                                                            siteId,
                                                            "current")
                hybrisRequest?.httpMethod = .POST
                hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]
                hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
                hybrisRequest?.bodyParameter = address.addressParameter

                ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                         with: appInfra,
                                                                         completionHandler: {(data, error) in
                    do {
                        if let data = data {
                            if let errorObject = self.getHybrisError(for: data),
                                error != nil {
                                completionHandler(nil, errorObject.subjectError)
                                return
                            }
                            let jsonDecoder = JSONDecoder()
                            let address = try jsonDecoder.decode(ECSAddress.self, from: data)
                            completionHandler(address, nil)
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

    func createNewAddress(with address: ECSAddress, completionHandler:@escaping ECSAddressListCompletion) {
        createNewAddress(address: address) { (_, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            ECSFetchAddressMicroServices().fetchSavedAddressList(completionHandler: completionHandler)
        }
    }
}

// MARK: - Helper methods
extension ECSAddNewAddressMicroService {

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
