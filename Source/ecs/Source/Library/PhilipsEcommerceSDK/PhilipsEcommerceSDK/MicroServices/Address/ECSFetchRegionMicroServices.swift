/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSFetchRegionMicroServices: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func fetchRegions(for countryISO: String, completionHandler: @escaping ECSRegionsCompletion) {
        guard countryISO.count > 0 else {
            completionHandler(nil, ECSHybrisError(with: .ECScountryCodeNotGiven).hybrisError)
            return
        }

        commonValidation { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            if let appInfra = ECSConfiguration.shared.appInfra,
                let locale = ECSConfiguration.shared.locale {

                hybrisRequest = ECSMicroServiceHybrisRequest()
                hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.fetchRegions.rawValue,
                                                            countryISO)
                hybrisRequest?.httpMethod = .GET
                hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]

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
                            let regionList = try jsonDecoder.decode(ECSRegionList.self, from: data)
                            completionHandler(regionList.regions, nil)
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
