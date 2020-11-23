/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSFetchRetailersMicroService: NSObject, ECSWTBMicroService, ECSServiceDiscoveryURLDownloader {

    var retailerRequest: ECSMicroServiceWTBRequest?

    func fetchRetailerDetailsFor(productCtn: String, completionHandler: @escaping ECSRetailerListCompletion) {
        microServiceError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let locale = ECSConfiguration.shared.locale,
                let appInfra = ECSConfiguration.shared.appInfra,
                productCtn.count > 0 else {
                    completionHandler(nil, ECSHybrisError(with: .ECSUnknownIdentifierError).hybrisError)
                    return
            }
            let replacementDictionary = [ECSConstant.locale.rawValue: locale,
                                         ECSConstant.ctn.rawValue: productCtn]
            fetchURLFromServiceDiscoveryFor(serviceID: ECSServiceId.productRetailers.rawValue,
                                            replacementDict: replacementDictionary) { (url, error) in
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                self.retailerRequest = ECSMicroServiceWTBRequest()
                self.retailerRequest?.baseURL = url ?? ""
                self.retailerRequest?.httpMethod = .GET
                ECSRestClientCommunicator().performRequestAsynchronously(for: self.retailerRequest,
                                                                         with: appInfra,
                                                                         completionHandler: { (data, error) in
                    if let data = data {
                        if let wtbError = self.getWTBError(for: data) {
                            completionHandler(nil, wtbError)
                            return
                        }
                        do {
                            let jsonDecoder = JSONDecoder()
                            let retailerData = try jsonDecoder.decode(ECSRetailerList.self, from: data)
                            completionHandler(retailerData, nil)
                        } catch {
                            ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                                   eventId: "ECSParsingError",
                                                                   message: "\(error.fetchCatchErrorMessage())")
                            completionHandler(nil, ECSHybrisError().hybrisError)
                        }
                    } else {
                        completionHandler(nil, error ?? ECSHybrisError().hybrisError)
                    }
                })
            }
        }
    }
}

// MARK: - Helper methods
extension ECSFetchRetailersMicroService {

    func microServiceError(completionHandler: ECSValidationCompletion) {
        assert(ECSConfiguration.shared.locale != nil,
               "Please call `configureECSWithConfiguration:` method")
        guard ECSConfiguration.shared.appInfra != nil else {
            completionHandler(ECSHybrisError(with: .ECSAppInfraNotFound).hybrisError)
            return
        }
        guard ECSConfiguration.shared.locale != nil else {
            completionHandler(ECSHybrisError(with: .ECSLocaleNotFound).hybrisError)
            return
        }
        completionHandler(nil)
    }
}
