/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import AdobeMobileSDK
@testable import InAppPurchaseDev

class IAPPaymentConfirmationViewControllerTests: XCTestCase {
    
    var paymentConfirmationVC : IAPPaymentConfirmationViewController!
    var orderNumber = "123"
    var paymentStatusTag = 0
    
    
    override func setUp() {
        super.setUp()
        let paymentvc = IAPPaymentConfirmationViewController.instantiateFromAppStoryboard(appStoryboard: .worldPay)
        paymentvc.loadView()
        paymentConfirmationVC = paymentvc
        paymentConfirmationVC.paymentStatusTag = self.paymentStatusTag
        paymentConfirmationVC.orderNo = self.orderNumber
        Bundle.loadSwizzler()
        ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        let componentInfoDict:Dictionary = Bundle.main.infoDictionary!
        IAPConfiguration.sharedInstance.sharedAppInfra.tagging.createInstance(
            forComponent: componentInfoDict["CFBundleName"] as? String  ?? "",
            componentVersion: componentInfoDict["CFBundleShortVersionString"] as? String ?? "")
    }
    
    override func tearDown() {
        Bundle.deSwizzle()
        paymentConfirmationVC.delegate = nil
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = nil
        super.tearDown()
    }
    
    func testShowPaymentStatus() {
        self.paymentConfirmationVC.viewWillAppear(false)
        var status = self.paymentConfirmationVC.paymentStatusString
        XCTAssert(status == "Success", "Payment status is not correct")
        
        self.paymentConfirmationVC.paymentStatusTag = 1
        self.paymentConfirmationVC.viewWillAppear(false)
        status = self.paymentConfirmationVC.paymentStatusString
        XCTAssert(status == "Failed", "Payment status is not correct")
        
        self.paymentConfirmationVC.paymentStatusTag = 2
        self.paymentConfirmationVC.viewWillAppear(false)
        status = self.paymentConfirmationVC.paymentStatusString
        XCTAssert(status == "Pending", "Payment status is not correct")
        
        self.paymentConfirmationVC.paymentStatusTag = 3
        self.paymentConfirmationVC.viewWillAppear(false)
        status = self.paymentConfirmationVC.paymentStatusString
        XCTAssert(status == "Cancel", "Payment status is not correct")
        
    }
    
    func testOrderPlacedSuccessCallback() {
        let orderFlowCallback = IAPOrderFlowCompletionProtocolDummy()
        let worldPayDelegate = WorldPayProtocolDummy()
        paymentConfirmationVC.paymentStatusTag = 2
        paymentConfirmationVC.delegate = worldPayDelegate
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = orderFlowCallback
        paymentConfirmationVC.statusButtonClicked(UIButton())
        XCTAssertTrue(orderFlowCallback.orderPlaced)
        XCTAssertFalse(orderFlowCallback.orderCancelled)
        XCTAssertTrue(worldPayDelegate.didNavigate)
    }
    
    func testOrderPlacedSuccessCallbackWithoutPop() {
        let orderFlowCallback = IAPOrderFlowCompletionProtocolDummy()
        orderFlowCallback.shouldPop = false
        let worldPayDelegate = WorldPayProtocolDummy()
        paymentConfirmationVC.paymentStatusTag = 2
        paymentConfirmationVC.delegate = worldPayDelegate
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = orderFlowCallback
        paymentConfirmationVC.statusButtonClicked(UIButton())
        XCTAssertTrue(orderFlowCallback.orderPlaced)
        XCTAssertFalse(worldPayDelegate.didNavigate)
    }
    
    func testOrderPlacedSuccessPopsByDefault() {
        let worldPayDelegate = WorldPayProtocolDummy()
        paymentConfirmationVC.paymentStatusTag = 2
        paymentConfirmationVC.delegate = worldPayDelegate
        paymentConfirmationVC.statusButtonClicked(UIButton())
        XCTAssertTrue(worldPayDelegate.didNavigate)
    }
    
    func testOrderPlacedSuccessPopsIfNotImplementedByDefault() {
        let orderFlowCallback = IAPOrderCompletionPartialImplementationDummy()
        let worldPayDelegate = WorldPayProtocolDummy()
        paymentConfirmationVC.paymentStatusTag = 2
        paymentConfirmationVC.delegate = worldPayDelegate
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = orderFlowCallback
        paymentConfirmationVC.statusButtonClicked(UIButton())
        XCTAssertTrue(worldPayDelegate.didNavigate)
    }
    
    func testOrderPlacedSuccessPopsIfNotImplemented() {
        let orderFlowCallback = IAPOrderCompletionPartialImplementationDummy()
        orderFlowCallback.shouldPop = false
        let worldPayDelegate = WorldPayProtocolDummy()
        paymentConfirmationVC.paymentStatusTag = 2
        paymentConfirmationVC.delegate = worldPayDelegate
        IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = orderFlowCallback
        paymentConfirmationVC.statusButtonClicked(UIButton())
        XCTAssertFalse(worldPayDelegate.didNavigate)
    }
}
