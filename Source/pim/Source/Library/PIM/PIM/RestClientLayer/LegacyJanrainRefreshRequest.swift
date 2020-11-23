/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

class LegacyJanrainRefreshRequest: PIMRequestInterface {
    
    private var url: String
    private var bodyContent: Data
    
    init(_ baseURL: String, body: Data) {
        url = baseURL
        bodyContent = body
    }
    
    func getURL() -> URL? {
        return URL(string: "\(url)/oauth/refresh_access_token")
    }
    
    func getMethodType() -> String {
        return PIMMethodType.POST.rawValue
    }
    
    func getHeaderContent() -> Dictionary<String, String>? {
        return [PIMConstants.Network.CONTENT_TYPE:PIMConstants.Network.APPLICATION_URL_ENCODED,
                PIMConstants.Network.ACCEPT:PIMConstants.Network.APPLICATION_JSON]
    }
    
    func getBodyContent() -> Data? {
        return bodyContent
    }
}
