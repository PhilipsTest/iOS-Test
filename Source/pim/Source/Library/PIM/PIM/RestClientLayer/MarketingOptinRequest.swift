/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth

class MarketingOptinRequest: PIMRequestInterface {
    
    private var isOptedIn: Bool
    private var authState: OIDAuthState
    private var marketingOptinURL: URL
    
    init(_ optedIn: Bool, oidAuthState: OIDAuthState, optinURL: URL) {
        isOptedIn = optedIn
        authState = oidAuthState
        marketingOptinURL = optinURL
    }
    
    func getURL() -> URL? {
        return marketingOptinURL
    }
    
    func getMethodType() -> String {
        return PIMMethodType.PATCH.rawValue
    }
    
    func getHeaderContent() -> Dictionary<String, String>? {
        var headerDict: [String: String] = [:]
        headerDict[PIMConstants.Network.CONTENT_API_VERSION] = "1"
        headerDict[PIMConstants.Network.ACCEPT_ENCODING] = PIMConstants.Network.GZIP_ENCODING
        headerDict[PIMConstants.Network.ACCEPT] = PIMConstants.Network.APPLICATION_JSON
        headerDict[PIMConstants.Network.CONTENT_TYPE] = PIMConstants.Network.APPLICATION_JSON
        headerDict[PIMConstants.Network.AUTHORIZATION] = "Bearer \(authState.lastTokenResponse?.accessToken ?? "")"
        headerDict[PIMConstants.Network.CONTENT_API_KEY] = PIMUtilities.getStaticConfig(PIMConstants.Network.MARKETING_OPTIN_API_KEY, appinfraConfig: PIMSettingsManager.sharedInstance.appInfraInstance()!.appConfig)
        return headerDict
    }
    
    func getBodyContent() -> Data? {
        let localeValue = PIMSettingsManager.sharedInstance.getLocale() ?? ""
        let bodyParams = "{\"data\": {\"type\": \"user\", \"attributes\": {\"consentEmailMarketing\": {\"optedIn\": \(isOptedIn)}, \"locale\": \"\(localeValue)\"}}}"
        let bodyData:Data? = bodyParams.data(using: .utf8)
        
        return bodyData
    }
}
