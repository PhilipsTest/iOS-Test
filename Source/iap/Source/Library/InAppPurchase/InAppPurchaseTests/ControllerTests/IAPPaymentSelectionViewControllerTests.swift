/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import AdobeMobileSDK
@testable import InAppPurchaseDev

class IAPPaymentSelectionViewControllerTests: XCTestCase {
    var paymentSelectionVC: IAPPaymentSelectionViewController!
    override func setUp() {
        super.setUp()
        paymentSelectionVC = IAPPaymentSelectionViewController.instantiateFromAppStoryboard(appStoryboard: .worldPay)
        let paymentDict = self.deserializeData("IAPPaymentDetailsInfo")
        XCTAssertNotNil(paymentDict, "JSON has not been deserialsed")

        let paymentDetails = IAPPaymentDetailsInfo(inDict: paymentDict!)
        paymentSelectionVC!.paymentDetailsInfo = paymentDetails.arrayOfPaymentDetails

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
    
    func testProcessPaymentForUser() {
        paymentSelectionVC?.loadView()
        paymentSelectionVC?.viewDidLoad()
        paymentSelectionVC?.viewWillAppear(false)
        
        let navController = IAPTestNavigationController()
        navController.pushViewController(paymentSelectionVC!, animated: false)
        
        paymentSelectionVC!.processPaymentForUser()
        XCTAssertNotNil(paymentSelectionVC, "Payment selection view controller object should not be nil")
        XCTAssert(navController.pushedViewController is IAPShippingAddressEditViewController, "IAPShippingAddressEditViewController was not pushed")
    }
    
    func testPushToOrderSummaryScreen() {
        let navController = IAPTestNavigationController()
        navController.pushViewController(paymentSelectionVC!, animated: false)
        paymentSelectionVC?.pushToOrderSummaryScreen((paymentSelectionVC?.paymentDetailsInfo.first)!)
        XCTAssertNotNil(paymentSelectionVC, "Payment selection view controller object should not be nil")
        XCTAssert(navController.pushedViewController is IAPOrderSummaryViewController, "IAPOrderSummaryViewController was not pushed")
    }
}
