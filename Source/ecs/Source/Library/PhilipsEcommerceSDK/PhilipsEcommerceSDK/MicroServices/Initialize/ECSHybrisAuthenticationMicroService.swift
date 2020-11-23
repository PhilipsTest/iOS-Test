/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

private let invalidGrant = "invalid_grant"

class ECSHybrisAuthenticationMicroService: NSObject, ECSHybrisMicroService {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func authenticateWithHybrisWith(hybrisOAuthData: ECSOAuthProvider,
                                    completionHandler: @escaping ECSHybrisOAuthCompletion) {
        if let hybrisOAuthError = hybrisOAuthData.verifyOAuthData() {
            completionHandler(nil, hybrisOAuthError)
        } else {
            let oauthParams: [String: String] = constructOauthParameters(oauthData: hybrisOAuthData)
            sendHybrisOAuthRequest(with: oauthParams, completionHandler: completionHandler)
        }
    }

    func refreshHybrisLoginWith(hybrisOAuthData: ECSOAuthProvider, completionHandler: @escaping ECSHybrisOAuthCompletion) {
        if let hybrisOAuthError = hybrisOAuthData.verifyOAuthData() {
            completionHandler(nil, hybrisOAuthError)
        } else {
            let refreshOauthParams: [String: String] = constructRefreshOauthParameters(oauthData: hybrisOAuthData)
            sendHybrisOAuthRequest(with: refreshOauthParams, completionHandler: completionHandler)
        }
    }
}

// MARK: - Helper methods
extension ECSHybrisAuthenticationMicroService {

    func sendHybrisOAuthRequest(with queryParameters: [String: String],
                                completionHandler: @escaping ECSHybrisOAuthCompletion) {
        commonValidation { (error) in
            if error == nil {
                if let appInfra = ECSConfiguration.shared.appInfra {
                    hybrisRequest = ECSMicroServiceHybrisRequest()
                    hybrisRequest?.microserviceEndPoint = ECSMicroServiceEndPoint.hybrisOAuth.rawValue
                    hybrisRequest?.queryParameter = queryParameters
                    hybrisRequest?.httpMethod = .POST
                    ECSRestClientCommunicator().performRequestAsynchronously(for: hybrisRequest,
                                                                             with: appInfra,
                     completionHandler: { (data, error) in
                        do {
                            if let data = data {
                                if let errorObject = self.getHybrisError(for: data), error != nil {
                                    completionHandler(nil, errorObject.hybrisError)
                                    return
                                }
                                let jsonDecoder = JSONDecoder()
                                let hybrisOAuthData = try jsonDecoder.decode(ECSOAuthData.self, from: data)
                                if let tokenType = hybrisOAuthData.tokenType,
                                    let accessToken = hybrisOAuthData.accessToken {
                                    ECSConfiguration.shared.hybrisToken = "\(tokenType)" + " " + "\(accessToken)"
                                    completionHandler(hybrisOAuthData, nil)
                                    return
                                }
                                completionHandler(nil, ECSHybrisError().hybrisError)
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
            } else {
                completionHandler(nil, error)
            }
        }
    }
}

extension ECSHybrisAuthenticationMicroService {

    func constructOauthParameters(oauthData: ECSOAuthProvider) -> [String: String] {
        let requestParameter: [String: String] = [oauthData.grantType.rawValue: oauthData.token,
                                                  ECSConstant.clientID.rawValue: oauthData.clientID.rawValue,
                                                  ECSConstant.clientSecret.rawValue: oauthData.clientSecret,
                                                  ECSConstant.grantType.rawValue: oauthData.grantType.rawValue]

        return requestParameter
    }

    func constructRefreshOauthParameters(oauthData: ECSOAuthProvider) -> [String: String] {
        let requestParameter: [String: String] = [ECSConstant.refreshTokenType.rawValue: oauthData.token,
                                                  ECSConstant.clientID.rawValue: oauthData.clientID.rawValue,
                                                  ECSConstant.clientSecret.rawValue: oauthData.clientSecret,
                                                  ECSConstant.grantType.rawValue: ECSConstant.refreshTokenType.rawValue]
        return requestParameter
    }
}
