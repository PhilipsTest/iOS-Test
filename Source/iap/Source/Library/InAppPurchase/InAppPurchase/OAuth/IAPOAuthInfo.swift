/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOAuthInfo: NSObject, NSCoding {
    var accessToken: String!
    var refreshToken: String!
    var tokenType: String!
    
    convenience init(inDictionary: [String: AnyObject]) {
        self.init()

        if let token = inDictionary[IAPConstants.IAPOAuthAccessTokenKeys.kAccessTokenKey] as? String {
            self.accessToken    = token
        }

        if let rToken = inDictionary[IAPConstants.IAPOAuthAccessTokenKeys.kRefreshTokenKey] as? String {
            self.refreshToken    = rToken
        }
        
        if let type = inDictionary[IAPConstants.IAPOAuthAccessTokenKeys.kTokenTypeKey] as? String {
            self.tokenType    = type
        }
    }
    
    class func oAuthInfo() -> IAPOAuthInfo {
        
        let oAuthInfo: IAPOAuthInfo = IAPOAuthInfo()
        oAuthInfo.accessToken = IAPConfiguration.sharedInstance.oauthInfo?.accessToken
        oAuthInfo.refreshToken = IAPConfiguration.sharedInstance.oauthInfo?.refreshToken
        oAuthInfo.tokenType = IAPConfiguration.sharedInstance.oauthInfo?.tokenType
        return oAuthInfo
    }
    
    class func httpHeadersParameterDictForOCCRequest() -> [String: String]? {

        var dictionaryToBeReturned = [String: String]()
        guard let oauthInfo = IAPConfiguration.sharedInstance.oauthInfo else { return nil }
        dictionaryToBeReturned = [IAPConstants.IAPOAuthCoderKeys.kAuthorizationKey: String(
            format: "%@ %@", arguments: [oauthInfo.tokenType, oauthInfo.accessToken])]
    
        return dictionaryToBeReturned
    }

    func getOAuthDictionary() -> [String: AnyObject] {
        var dictionaryToReturn = [String: AnyObject]()
        if let token = self.accessToken {
            dictionaryToReturn[IAPConstants.IAPOAuthAccessTokenKeys.kAccessTokenKey] = token as AnyObject?
        }
        
        if let rToken = self.refreshToken {
            dictionaryToReturn[IAPConstants.IAPOAuthAccessTokenKeys.kRefreshTokenKey] = rToken as AnyObject?
        }
        
        if let type = self.tokenType {
            dictionaryToReturn[IAPConstants.IAPOAuthAccessTokenKeys.kTokenTypeKey] = type as AnyObject?
        }
        
        return dictionaryToReturn
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.accessToken, forKey: IAPConstants.IAPOAuthCoderKeys.kAccessTokenCoderKey)
        aCoder.encode(self.refreshToken, forKey: IAPConstants.IAPOAuthCoderKeys.kRefreshTokenCoderKey)
        aCoder.encode(self.tokenType, forKey: IAPConstants.IAPOAuthCoderKeys.kTokenTypeCoderKey)
    }

    required convenience init(coder aDecoder: NSCoder) {
        var tokenDictionary: [String: String] = [String: String]()
        if let token = aDecoder.decodeObject(forKey: IAPConstants.IAPOAuthCoderKeys.kAccessTokenCoderKey) as? String {
            tokenDictionary[IAPConstants.IAPOAuthAccessTokenKeys.kAccessTokenKey] = token
        }

        if let rToken = aDecoder.decodeObject(forKey: IAPConstants.IAPOAuthCoderKeys.kRefreshTokenCoderKey) as? String {
            tokenDictionary[IAPConstants.IAPOAuthAccessTokenKeys.kRefreshTokenKey] = rToken
        }
        if let type = aDecoder.decodeObject(forKey: IAPConstants.IAPOAuthCoderKeys.kTokenTypeCoderKey) as? String {
            tokenDictionary[IAPConstants.IAPOAuthAccessTokenKeys.kTokenTypeKey] = type
        }
        
        self.init(inDictionary: tokenDictionary as [String: AnyObject])
    }
}
