/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

class PIMMigrationRequest : PIMRequestInterface {
    
    private var url:String!
    private var accessToken:String!
    
    init(withAccessToken:String,url:String) {
        self.accessToken = withAccessToken
        self.url = url
    }
    
    func getURL() -> URL? {
        return URL(string: self.url)
    }
    
    func getMethodType() -> String {
        return PIMMethodType.POST.rawValue
    }
    
    func getHeaderContent() -> Dictionary<String, String>? {
        var headers:[String:String] = [:]
        headers[PIMConstants.Network.CONTENT_TYPE] = PIMConstants.Network.APPLICATION_JSON
        headers[PIMConstants.Network.ACCEPT] = PIMConstants.Network.APPLICATION_JSON
        headers[PIMConstants.Network.CONTENT_API_KEY] = PIMUtilities.getStaticConfig(PIMConstants.Network.API_KEY, appinfraConfig: PIMSettingsManager.sharedInstance.appInfraInstance()?.appConfig)
        headers[PIMConstants.Network.CONTENT_API_VERSION] = "1";
        return headers
    }
    
    func getBodyContent() -> Data? {
        guard let token = self.accessToken else {
            return nil
        }
        let string = "{\"data\": {\"accessToken\":\"\(token)\"}}"
        let bodyData:Data? = string.data(using: .utf8)
        return bodyData
    }
}
