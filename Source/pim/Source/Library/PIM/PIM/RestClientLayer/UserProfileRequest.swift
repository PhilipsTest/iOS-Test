/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth

class UserProfileRequest: PIMRequestInterface {
    private var authState:OIDAuthState
    
    init(_ oidAuthState: OIDAuthState ) {
        authState = oidAuthState
    }
    
    func getURL() -> URL? {
        return authState.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint
    }
    
    func getMethodType() -> String {
        return PIMMethodType.GET.rawValue
    }
    
    func getHeaderContent() -> Dictionary<String, String>? {
        return [PIMConstants.Network.AUTHORIZATION:"Bearer \(authState.lastTokenResponse?.accessToken ?? "")"]
    }
    
    func getBodyContent() -> Data? {
        return nil
    }
}
