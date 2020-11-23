/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOAuthDownloadManagerTests: XCTestCase {

  func testDownloadManagerInitialisation() {
        let janrainToken = "12345"
        var downloadManager = IAPOAuthDownloadManager(janRainAccessToken: janrainToken)
        XCTAssertNotNil(downloadManager,"Download manager was initialised inspite of invalid credentials")
        
        XCTAssert(downloadManager?.getJanRainAccessToken() == janrainToken,"Janrain token is not same")
        XCTAssert(downloadManager?.getOAuthGrantType() == IAPConstants.IAPOAuthParameterKeys.kOAuthGrantTypeJanrain,"OAuth grant type is not same")
        XCTAssert(downloadManager?.getReOAuthGrantType() == IAPConstants.IAPOAuthParameterKeys.kReOAuthGrantType,"Re oauth grant type is not same")
        
        downloadManager = IAPOAuthDownloadManager(janRainAccessToken: "")
        XCTAssertNil(downloadManager, "Download manager is initialised despite empty janrain")
    }
    
    func testDownloadManagerDictCreation() {
        let janrainToken = "12345"
        let downloadManager = IAPOAuthDownloadManager(janRainAccessToken: janrainToken)
        
        let dict = downloadManager?.authorisationParameterForOAuth()
        XCTAssertNotNil(dict,"Dictionary returned is nil")
        
        var url = downloadManager?.getBaseURL()
        XCTAssertNotNil(url, "Base url returned is nil")
        
        url = downloadManager?.constructedOAuthURL()
        XCTAssertNotNil(url, "Oauth url returned is nil")
        
        let oauth = IAPOAuthInfo.oAuthInfo()
        oauth.refreshToken = "12345"
        IAPConfiguration.sharedInstance.oauthInfo = oauth
        url = downloadManager?.constructReOAuthUrl()
        XCTAssertNotNil(url, "Re-Oauth url returned is nil")

    }
    
    func testDownloadManagerInterfaceCreation() {
        let oauthDonwloadManager = IAPOAuthDownloadManager(janRainAccessToken: "12345")
        let httpInterface = oauthDonwloadManager?.getInterfaceForOAuth()
        XCTAssertNotNil(httpInterface,"Interface returned is nil")
        
        let httpInterface2 = oauthDonwloadManager?.getInterfaceForOAuth(true)
        XCTAssertNotNil(httpInterface2,"Interface returned is nil")
    }
    
    func testDownloadManagerDownloadSuccess() {
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOAuthInfoTests"
        
        let oauthDonwloadManager = IAPOAuthDownloadManager(janRainAccessToken: "12345")
        oauthDonwloadManager?.getOAuthTokenWithInterface(httpInterface, successCompletion: { (info: IAPOAuthInfo) in
            XCTAssertNotNil(info, "OAuth Info returned is nil")
            }, errorFailure: { (inError: NSError) in
                XCTAssertNotNil(inError, "Error returned is nil")
        })
    }
    
    func testDownloadManagerDownloadFailure() {
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOAuthInfoTests"
        httpInterface.isErrorToBeInvoked = true
        
        let oauthDonwloadManager = IAPOAuthDownloadManager(janRainAccessToken: "12345")
        oauthDonwloadManager?.getOAuthTokenWithInterface(httpInterface, successCompletion: { (info: IAPOAuthInfo) in
            XCTAssertNotNil(info, "OAuth Info returned is nil")
            }, errorFailure: { (inError: NSError) in
                XCTAssertNotNil(inError, "Error returned is nil")
        })
    }

}
