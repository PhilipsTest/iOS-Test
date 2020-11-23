/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
import Foundation

class ECSFetchConfigMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func configureECSWithConfiguration(completionHandler: @escaping ECSGetConfigCompletion) {
        guard let appInfra = ECSConfiguration.shared.appInfra else {
            completionHandler(nil, ECSHybrisError(with: .ECSAppInfraNotFound).hybrisError)
            return
        }
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        appInfra.serviceDiscovery.getServicesWithCountryPreference([ECSConstant.baseURL.rawValue],
                                                                   withCompletionHandler: { (returnedValue, inError) in
            guard inError == nil else {
                completionHandler(nil, inError)
                return
            }

            if let serviceDiscoveryValue = returnedValue?[ECSConstant.baseURL.rawValue] {
                ECSConfiguration.shared.locale = serviceDiscoveryValue.locale
                ECSConfiguration.shared.baseURL = serviceDiscoveryValue.url
                if ECSConfiguration.shared.baseURL != nil {
                    self.fetchECSConfig(completionHandler: { (config, error) in
                        guard let config = config else {
                            let ecsConfig: ECSConfig? = ECSConfig()
                            ecsConfig?.locale = ECSConfiguration.shared.locale
                            completionHandler(ecsConfig, error)
                            return
                        }
                        completionHandler(config, error)
                    })
                } else {
                    let configData = ECSConfig()
                    configData.locale = ECSConfiguration.shared.locale
                    completionHandler(configData, ECSHybrisError(with: .ECSHybrisNotAvailable).hybrisError)
                }
            } else {
                completionHandler(nil, ECSHybrisError(with: .ECSHybrisNotAvailable).hybrisError)
            }
        }, replacement: nil)
    }
}

// MARK: - Helper methods
extension ECSFetchConfigMicroService {

    func fetchECSConfig(completionHandler: @escaping ECSGetConfigCompletion) {
        commonValidation { (error) in
            if error == nil {
                guard let appInfra = ECSConfiguration.shared.appInfra,
                    let propositionId = ECSConfiguration.shared.propositionId,
                    let locale = ECSConfiguration.shared.locale else {
                        completionHandler(nil,
                                          ECSHybrisError(with: .ECSPropositionIdNotFound).hybrisError)
                        return
                }

                hybrisRequest = ECSMicroServiceHybrisRequest()
                hybrisRequest?.microserviceEndPoint = String(format: ECSMicroServiceEndPoint.configure.rawValue,
                                                             locale,
                                                             propositionId)
                hybrisRequest?.queryParameter = [ECSConstant.lang.rawValue: locale]
                hybrisRequest?.httpMethod = .GET

                ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                         with: appInfra,
                                                                         completionHandler: { (data, error) in
                    do {
                        if let configData = data {
                            let jsonDecoder = JSONDecoder()
                            let config = try jsonDecoder.decode(ECSConfig.self, from: configData)
                            if let siteID = config.siteID,
                                let rootCategory = config.rootCategory {

                                config.locale = ECSConfiguration.shared.locale
                                config.isHybrisAvailable = true
                                ECSConfiguration.shared.siteId = siteID
                                ECSConfiguration.shared.rootCategory = rootCategory

                                completionHandler(config, nil)
                            } else {
                                completionHandler(nil,
                                                  ECSHybrisError(with: .ECSHybrisNotAvailable).hybrisError)
                            }
                        } else {
                            completionHandler(nil, error ?? ECSHybrisError().hybrisError)
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
