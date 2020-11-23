/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth

class PIMErrorBuilder : NSObject {
    
    static func buildErrorMessage(code:PIMMappedError,message:String) -> String {
        return message.localiseString(args:code.rawValue)
    }
    
    static func buildUserNotLoggedInError() -> NSError {
        let localisedErrorMessage = buildErrorMessage(code: PIMMappedError.PIMUserNotLoggedIn, message: "PIM_Error_Msg")
        return NSError(domain: "com.PIM.Janrain", code: PIMMappedError.PIMUserNotLoggedIn.rawValue, userInfo: [NSLocalizedDescriptionKey:localisedErrorMessage])
    }
    
    static func buildUDIUserNotLoggedInError() -> NSError {
        let localisedErrorMessage = buildErrorMessage(code: PIMMappedError.PIMUserNotLoggedIn, message: "PIM_Error_Msg")
        return PIMErrorBuilder.buildPIMError(code: .PIMUserNotLoggedIn, message: localisedErrorMessage, domain: "com.PIM.NoUserError")
    }

    static func buildPIMError(code:PIMMappedError,message:String,domain:String) -> NSError {
        let localisedErrorMessage = buildErrorMessage(code: code, message: message)
        return NSError(domain: domain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey:localisedErrorMessage])
    }
    
    static func buildPIMMigrationError() -> NSError {
        return PIMErrorBuilder.buildPIMError(code: .PIMMigrationFailedError, message: "PIM_Error_Msg",domain: "com.PIM.Migration.RedirectionFailed")
    }
    
    static func buildPIMMarketingOptinError() -> NSError {
        return PIMErrorBuilder.buildPIMError(code: .PIMMarketingOptinError, message: "PIM_Error_Msg",domain: "com.PIM.UpdateMarketingOptinFailed")
    }
    
    static func buildJRRefreshTokenError() -> NSError {
        return PIMErrorBuilder.buildPIMError(code: .PIMRefreshTokenFailed, message: "PIM_Error_Msg",domain: "com.PIM.JRRefreshTokenFailed")
    }
    
    static func buildRedirectionError() -> NSError {
        return PIMErrorBuilder.buildPIMError(code: .PIMNoRequestForRedirection, message: "PIM_Error_Msg",domain: "com.PIM.Login.RedirectionFailed")
    }
    
    static func buildRedirectionURLError() -> NSError {
        return PIMErrorBuilder.buildPIMError(code: .PIMInvalidRedirectionURL, message: "PIM_Error_Msg",domain: "com.PIM.Login.RedirectionFailed")
    }
    
    static func buildInvalidRefreshTokenError() -> NSError {
        return PIMErrorBuilder.buildPIMError(code: .PIMInvalidRefreshToken, message: "PIM_Error_Msg",domain: "com.PIM.Migration.InvalidOrNoJRToken")
    }
    
    static func buildAccessTokenExpiryError() -> NSError {
        return PIMErrorBuilder.buildPIMError(code: .PIMAccessTokenExpired, message: "PIM_Error_Msg", domain: "com.PIM.PIMAccessTokenExpired")
    }
    
    static func getNoSDURLError() -> NSError {
        let errorCode = PIMMappedError.PIMSDDownloadError
        let localisedErrorMessage = PIMErrorBuilder.buildErrorMessage(code:errorCode , message: "PIM_Error_Msg")
        return NSError(domain: "com.PIM.ServiceDiscoveryURLNotPresent", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:localisedErrorMessage])
    }
    
    static func buidNetworkError(httpCode:Int) -> NSError {
        let localisedErrorMessage = "PIM_Error_Msg".localiseString(args: httpCode);
        return NSError(domain: "com.PIM.NetworkError", code: httpCode, userInfo: [NSLocalizedDescriptionKey:localisedErrorMessage])
    }
    
    static func getOIDCDownloadError() ->NSError {
        let errorCode = PIMMappedError.PIMOIDCDownloadError
        let localisedErrorMessage = PIMErrorBuilder.buildErrorMessage(code:errorCode , message: "PIM_Error_Msg")
        return NSError(domain: "com.PIM.ConfigDownloadError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:localisedErrorMessage])
    }
    
    static func buildDiscoveryError() -> NSError {
        let errorCode = PIMMappedError.PIMOIDErrorCodeNetworkError
        let localisedErrorMessage = PIMErrorBuilder.buildErrorMessage(code: errorCode, message: "PIM_Error_Msg")
        return NSError(domain: "com.PIM.OIDDiscoveryError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:localisedErrorMessage])
    }
    
    static func buildAuthStateError(fromError:NSError?) -> NSError {
        guard let aError = fromError,aError.code != OIDErrorCode.networkError.rawValue else {
            return PIMErrorBuilder.buildDiscoveryError()
        }
        
        let codes:[String:PIMMappedError] = [
            String(Int(OIDErrorCode.safariOpenError.rawValue)) : PIMMappedError.PIMOIDErrorCodeSafariOpenError,
            String(Int(OIDErrorCode.serverError.rawValue)) : PIMMappedError.PIMOIDErrorCodeServerError,
            String(Int(OIDErrorCode.programCanceledAuthorizationFlow.rawValue)) : PIMMappedError.PIMOIDErrorCodeProgramCanceledAuthorizationFlow,
            String(Int(OIDErrorCodeOAuth.invalidRequest.rawValue)): PIMMappedError.PIMOIDErrorCodeOAuthInvalidRequest,
            String(Int(OIDErrorCodeOAuth.unauthorizedClient.rawValue)) : PIMMappedError.PIMOIDErrorCodeUserCanceledAuthorizationFlow,
            String(Int(OIDErrorCodeOAuth.unsupportedResponseType.rawValue)) : PIMMappedError.PIMOIDErrorCodeOAuthUnsupportedResponseType ,
            String(Int(OIDErrorCodeOAuth.temporarilyUnavailable.rawValue)) : PIMMappedError.PIMOIDErrorCodeOAuthTemporarilyUnavailable,
            String(Int(OIDErrorCodeOAuth.invalidGrant.rawValue)) : PIMMappedError.PIMOIDErrorCodeOAuthInvalidGrant,
            String(Int(OIDErrorCodeOAuth.unsupportedGrantType.rawValue)) : PIMMappedError.PIMOIDErrorCodeOAuthUnsupportedGrantType,
            String(Int(OIDErrorCodeOAuth.invalidRedirectURI.rawValue)) : PIMMappedError.PIMOIDErrorCodeOAuthInvalidRedirectURI,
            String(Int(OIDErrorCodeOAuth.invalidClientMetadata.rawValue)) : PIMMappedError.PIMOIDErrorCodeOAuthInvalidClientMetadata
        ]
        guard let errorCode = codes[String((aError.code))] else {
            return PIMErrorBuilder.buildPIMError(code: PIMMappedError.PIMOIDErrorCodeOAuthServerError, message: "PIM_Error_Msg", domain: "com.PIM.OIDC.error")
        }
        let localisedErrorMessage = PIMErrorBuilder.buildErrorMessage(code: errorCode, message: "PIM_Error_Msg")
        return NSError(domain: "com.PIM.OIDDiscoveryError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:localisedErrorMessage])
    }
    
    static func parsePIMError(error: Error, networkResponse: URLResponse) -> NSError? {
        let httpResponse: HTTPURLResponse = networkResponse as! HTTPURLResponse
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case .unauthorized:
            return PIMErrorBuilder.buildAccessTokenExpiryError()
        case .forbiddenAccess:
            return PIMErrorBuilder.buildAccessTokenExpiryError()
        default:
            return nil
        }
    }
}

private extension Int {
    static let unauthorized     = 401
    static let forbiddenAccess  = 403
}
