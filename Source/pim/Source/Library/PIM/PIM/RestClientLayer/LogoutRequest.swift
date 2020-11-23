/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth

class LogoutRequest: PIMRequestInterface {
    
    private var authState:OIDAuthState
    
    init(_ oidAuthState: OIDAuthState ) {
        authState = oidAuthState
    }
    func getURL() -> URL? {
        guard let urlString = authState.lastAuthorizationResponse.request.configuration.discoveryDocument?.discoveryDictionary["revocation_endpoint"] as? String else {
            return nil
        }
        return URL(string: urlString)
    }
    
    func getMethodType() -> String {
        return PIMMethodType.POST.rawValue
    }
    
    func getHeaderContent() -> Dictionary<String, String>? {
        return [PIMConstants.Network.CONTENT_TYPE:PIMConstants.Network.APPLICATION_URL_ENCODED]
    }
    
    func getBodyContent() -> Data? {
        let clientId = PIMUtilities.getStaticConfig(PIMConstants.Network.CLIENT_ID, appinfraConfig: (PIMSettingsManager.sharedInstance.appInfraInstance()?.appConfig)!)
        let accessToken = authState.lastTokenResponse?.accessToken
        let postData = NSMutableData(data: "client_id=\(clientId )".data(using: String.Encoding.utf8)!)
        postData.append("&token_type_hint=access_token".data(using: String.Encoding.utf8)!)
        postData.append("&token=\(accessToken ?? " ")".data(using: String.Encoding.utf8)!)
        return postData as Data
    }
}
