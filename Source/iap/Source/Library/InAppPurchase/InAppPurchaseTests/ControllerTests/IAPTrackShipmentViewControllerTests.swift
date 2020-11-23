//
//  IAPTrackShipmentViewControllerTests.swift
//  InAppPurchase
//
//  Created by Chittaranjan Sahu on 11/23/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

import XCTest
import AppInfra
import AdobeMobileSDK
@testable import InAppPurchaseDev

class IAPTrackShipmentViewControllerTests: XCTestCase {

    var trackWebViewController: IAPTrackShipmentViewController?
    override func setUp() {
        super.setUp()
        trackWebViewController = IAPTrackShipmentViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        
        Bundle.loadSwizzler()
        ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        let componentInfoDict: Dictionary = Bundle.main.infoDictionary!
        IAPConfiguration.sharedInstance.sharedAppInfra.tagging.createInstance(
            forComponent: componentInfoDict["CFBundleName"] as? String ?? "",
            componentVersion: componentInfoDict["CFBundleShortVersionString"] as? String ?? "")
    }
    
    override func tearDown() {
        Bundle.deSwizzle()
        super.tearDown()
    }
    
    /*func testTrackShipmentWebView() {
        trackWebViewController?.trackShipmentURL = "https://www.occ.shop.philips.com"
        trackWebViewController?.loadView()
        trackWebViewController?.viewDidLoad()
        trackWebViewController?.viewWillAppear(false)
        trackWebViewController?.didTapTryAgain()
        trackWebViewController?.webViewDidStartLoad((trackWebViewController?.trackShipmentWebView)!)
        trackWebViewController?.webViewDidFinishLoad((trackWebViewController?.trackShipmentWebView)!)
        let errorTemp = NSError(domain: "", code: -999, userInfo: nil)
        trackWebViewController?.webView((trackWebViewController?.trackShipmentWebView)!,
                                        didFailLoadWithError: errorTemp)
        XCTAssertNotNil(trackWebViewController, "object is nil")
    }*/
}
