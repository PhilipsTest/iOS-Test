/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

class PIMMigrationAuthRequest : PIMRequestInterface {
    
    private var url:URL?
    
    init(url:URL) {
        self.url = url
    }
    
    func getURL() -> URL? {
        return self.url
    }
    
    func getMethodType() -> String {
        return PIMMethodType.GET.rawValue
    }
    
    func getHeaderContent() -> Dictionary<String, String>? {
        var headers:[String:String] = [:]
        headers[PIMConstants.Network.CONTENT_TYPE] = PIMConstants.Network.APPLICATION_URL_ENCODED
        return headers
    }
    
    func getBodyContent() -> Data? {
        return nil
    }
}
