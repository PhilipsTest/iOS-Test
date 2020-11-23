/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSAvailabilityNotificationResponse
@objcMembers private class ECSAvailabilityNotificationResponse: NSObject, Codable {
    var success: Bool?
}

// swiftlint:disable type_name
class ECSNotifyProductAvailibilityMicroservices: NSObject, ECSHybrisMicroService, ECSServiceDiscoveryURLDownloader {
// swiftlint:enable type_name
    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func registerForProductAvailability(email: String,
                                        ctn: String,
                                        completionHandler: @escaping ECSCompletion) {
        var ctnValue = ctn
        guard ctnValue.isValidCTN() else {
            completionHandler(false, ECSPILHybrisErrors(errorType: .ECSPIL_NOT_FOUND_productId).hybrisPILError)
            return
        }

        var emailValue = email
        guard emailValue.isValidEmail() == true else {
            completionHandler(false, ECSPILHybrisErrors(errorType: .ECSPIL_INVALID_PARAMETER_VALUE_Email).hybrisPILError)
            return
        }

        microServicePILError { (error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            if let appInfra = ECSConfiguration.shared.appInfra,
                let siteId = ECSConfiguration.shared.siteId {
                let replacementDict = [ServiceDiscoveryReplacementConstants.siteID.rawValue: siteId]
                fetchURLFromServiceDiscoveryFor(serviceID: ECSServiceId.notifyMe.rawValue,
                                                replacementDict: replacementDict) { (url, error) in
                    guard error == nil else {
                        completionHandler(false, error)
                        return
                    }
                    let requestBodyParameters = [ECSConstant.email.rawValue: "\(emailValue)",
                        ECSConstant.productId.rawValue: "\(ctnValue)"]
                    self.hybrisRequest = ECSMicroServiceHybrisRequest(requestType: ECSConstant.pilKey.rawValue)
                    self.hybrisRequest?.baseURL = url ?? ""
                    self.hybrisRequest?.bodyParameter = requestBodyParameters
                    self.hybrisRequest?.httpMethod = .POST
                    ECSRestClientCommunicator().performRequestAsynchronously(for: self.hybrisRequest,
                                                                             with: appInfra,
                                                                             completionHandler: {(data, error) in
                        self.parseAvailabitiyResponse(data: data, error: error, completionHandler: completionHandler)
                    })
                }
            }
        }
    }
}

// MARK: - Helper methods
extension ECSNotifyProductAvailibilityMicroservices {

    func microServicePILError(completion: ECSValidationCompletion) {
        commonPILValidation { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            guard ECSConfiguration.shared.siteId != nil else {
                completion(ECSHybrisError(with: .ECSPIL_MISSING_PARAMETER_siteId).hybrisError)
                return
            }
            completion(nil)
        }
    }

    fileprivate func parseAvailabitiyResponse(data: Data?,
                                              error: Error?,
                                              completionHandler: ECSCompletion) {
        if let availabilityData = data {
            if let errorObject = self.getPILHybrisError(for: availabilityData), error != nil {
                completionHandler(false, errorObject.hybrisPILError)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let availability = try jsonDecoder.decode(ECSAvailabilityNotificationResponse.self, from: availabilityData)
                completionHandler(availability.success ?? false, nil)
            } catch {
                ECSConfiguration.shared.ecsLogger?.log(.verbose, eventId: "ECSParsingError",
                                                       message: "\(error.fetchCatchErrorMessage())")
                completionHandler(false, ECSPILHybrisErrors().hybrisPILError)
            }
        } else {
            completionHandler(false, error ?? ECSPILHybrisErrors().hybrisPILError)
        }
    }
}
