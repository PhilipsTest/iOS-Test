/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import AdobeMobileSDK
@testable import InAppPurchaseDev

class IAPWorldPayViewControllerTests: XCTestCase {
    var worldpayVC:IAPWorldPayViewController?
    
    override func setUp() {
        super.setUp()
        worldpayVC = IAPWorldPayViewController.instantiateFromAppStoryboard(appStoryboard: .worldPay)
        worldpayVC?.worldPayURL = "https://www.philips.com/paymentsuccess"
        Bundle.loadSwizzler()
        ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        let componentInfoDict:Dictionary = Bundle.main.infoDictionary!
        IAPConfiguration.sharedInstance.sharedAppInfra.tagging.createInstance(
            forComponent: componentInfoDict["CFBundleName"] as? String ?? "" ,
            componentVersion: componentInfoDict["CFBundleShortVersionString"] as? String ?? "")
        
//        worldpayVC?.viewDidLoad()
//        worldpayVC?.viewWillAppear(false)
//        worldpayVC?.didTapTryAgain()
    }
    
    override func tearDown() {
        Bundle.deSwizzle()
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = nil
        super.tearDown()
    }
    
    /*func testShouldStartLoadWithRequest() {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        var request = URLRequest(url: URL(string: "https://www.philips.com/paymentsuccess")!)
        var isLoading:Bool = (worldpayVC?.webView(webView, shouldStartLoadWith: request, navigationType: .reload))!
        
        XCTAssert(isLoading == true, "true value should be returned as it contains the string")
        
        worldpayVC?.worldPayURL = "https://www.philips.com/paymentsuccess/abcde"
        request = URLRequest(url: URL(string: "https://www.philips.com/paymentsuccess")!)
        isLoading = (worldpayVC?.webView(webView, shouldStartLoadWith: request, navigationType: .reload))!
        
        XCTAssert(isLoading == false, "false value should be returned")
        
        worldpayVC?.worldPayURL = "https://www.philips.com/paymentsuccess/abcde"
        request = URLRequest(url: URL(string: "https://www.philips.com/paymentpending")!)
        isLoading = (worldpayVC?.webView(webView, shouldStartLoadWith: request, navigationType: .reload))!
        
        XCTAssert(isLoading == false, "false value should be returned")
        
        worldpayVC?.worldPayURL = "https://www.philips.com/paymentsuccess/abcde"
        request = URLRequest(url: URL(string: "https://www.philips.com/paymentcancel")!)
        isLoading = (worldpayVC?.webView(webView, shouldStartLoadWith: request, navigationType: .reload))!
        
        XCTAssert(isLoading == false, "false value should be returned")
        
        worldpayVC?.worldPayURL = "https://www.philips.com/paymentsuccess/abcde"
        request = URLRequest(url: URL(string: "https://www.philips.com/paymentfailure")!)
        isLoading = (worldpayVC?.webView(webView, shouldStartLoadWith: request, navigationType: .reload))!
        
        XCTAssert(isLoading == false, "false value should be returned")
    }*/
    
    func testOrderCancelCallback() {
        let orderFlowCallback = IAPOrderFlowCompletionProtocolDummy()
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = orderFlowCallback
        worldpayVC?.finishIAPFlow()
        XCTAssertFalse(orderFlowCallback.orderPlaced)
        XCTAssertTrue(orderFlowCallback.orderCancelled)
    }
    
    func testOrderCancelCallbackDoesnotCallByDefault() {
        let orderFlowCallback = IAPOrderFlowCompletionProtocolDummy()
        worldpayVC?.finishIAPFlow()
        XCTAssertFalse(orderFlowCallback.orderPlaced)
        XCTAssertFalse(orderFlowCallback.orderCancelled)
    }
    
    func testOrderCancelCallbackDow() {
        let orderFlowCallback = IAPOrderFlowCompletionProtocolDummy()
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = orderFlowCallback
        worldpayVC?.finishIAPFlow()
        XCTAssertFalse(orderFlowCallback.orderPlaced)
        XCTAssertTrue(orderFlowCallback.orderCancelled)
    }
}
