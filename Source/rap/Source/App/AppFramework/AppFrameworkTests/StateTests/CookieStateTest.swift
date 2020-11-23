//
//  CookieStateTest.swift
//  AppFrameworkTests
//
//  Created by Philips on 8/23/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import XCTest
import PlatformInterfaces
@testable import AppFramework

class CookieStateTest: XCTestCase {
    
    var cookieState : CookieState?
    var viewController : UIViewController?
    
    func testCookieViewController() {
        cookieState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.CookieConsent) as? CookieState
        viewController = cookieState?.getViewController()
        XCTAssertNotNil(viewController)
    }
    
    func testCookieConsentInterfacePostCookieConsentToFalse() {
        cookieState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.CookieConsent) as? CookieState
        let appinfra = AppInfraSharedInstance.sharedInstance.appInfraHandler!
        appinfra.consentManager = AIConsentManagerProtocolmock(consent: false)
        cookieState?.cookieConsentInterface = CookieConsentInterface(withappInfra: appinfra)
        cookieState?.cookieConsentInterface?.postCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination() , withStatus: true, completion: {
            result,_  in
            XCTAssertFalse(result)
        })
    }
    
    func testCookieConsentInterfacePostCookieConsentToTrue() {
        cookieState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.CookieConsent) as? CookieState
        let appinfra = AppInfraSharedInstance.sharedInstance.appInfraHandler!
        appinfra.consentManager = AIConsentManagerProtocolmock(consent: true)
        cookieState?.cookieConsentInterface = CookieConsentInterface(withappInfra: appinfra)
        cookieState?.cookieConsentInterface?.postCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination() , withStatus: true, completion: {
            result,_  in
            XCTAssertTrue(result)
        })
    }
    
    func testCookieConsentInterfaceFetchCookieConsentToFalse() {
        cookieState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.CookieConsent) as? CookieState
        let appinfra = AppInfraSharedInstance.sharedInstance.appInfraHandler!
        appinfra.consentManager = AIConsentManagerProtocolmock(consent: false)
        cookieState?.cookieConsentInterface = CookieConsentInterface(withappInfra: appinfra)
        cookieState?.cookieConsentInterface?.fetchCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination() , completion: {
            (result,_) in
            XCTAssertEqual(result?.status, ConsentStates.rejected)
        })
    }
    
    func testCookieConsentInterfaceFetchCookieConsentToTrue() {
        cookieState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.CookieConsent) as? CookieState
        let appinfra = AppInfraSharedInstance.sharedInstance.appInfraHandler!
        appinfra.consentManager = AIConsentManagerProtocolmock(consent: true)
        cookieState?.cookieConsentInterface = CookieConsentInterface(withappInfra: appinfra)
        cookieState?.cookieConsentInterface?.fetchCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination(), completion: {
            (result,_) in
            XCTAssertEqual(result?.status, ConsentStates.active)
        })
    }
}
