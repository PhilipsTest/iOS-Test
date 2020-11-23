/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsUIKitDLS
@testable import InAppPurchaseDev

class IAPShippingAddressSelectionViewcontrollerTests: XCTestCase {
    var iapShippingAddressSelectionViewcontroller: IAPShippingAddressSelectionViewcontroller!
    var cartInfoTest: IAPCartInfo! = IAPCartInfo()
    var productListTest: [IAPProductModel] = [IAPProductModel]()
    var cartIconDelegateTest: IAPCartIconProtocol?
    var sender: UIDButton!
    var userAddressInfo: IAPUserAddressInfo?
    
    override func setUp() {
        super.setUp()
        let dict = self.deserializeData("IAPOCCCartInfoSampleResponse")
        cartInfoTest = IAPCartInfo(inDict: dict! as NSDictionary)

        let vc = IAPShippingAddressSelectionViewcontroller.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        vc.loadView()
        iapShippingAddressSelectionViewcontroller = vc
        iapShippingAddressSelectionViewcontroller.cartInfo = cartInfoTest
        iapShippingAddressSelectionViewcontroller.productList = productListTest
        iapShippingAddressSelectionViewcontroller.cartIconDelegate = cartIconDelegateTest
        iapShippingAddressSelectionViewcontroller.viewDidLoad()
        iapShippingAddressSelectionViewcontroller.viewWillAppear(false)
        iapShippingAddressSelectionViewcontroller.viewDidAppear(false)
        
        let addressDict = self.deserializeData("IAPOCCGetAddress")
        XCTAssertNotNil(addressDict, "JSON has not been deserialsed")
        userAddressInfo = IAPUserAddressInfo(inDict: addressDict!)
    }
    
    func testCancelButtonTapped() {
        sender = UIDButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        iapShippingAddressSelectionViewcontroller.cancelButtonTapped(sender)
        XCTAssertNotNil(iapShippingAddressSelectionViewcontroller,"View controller is nil")
    }
    
    func testDidTapTryAgain() {
        iapShippingAddressSelectionViewcontroller.didTapTryAgain()
    }
    
    func testGetDefaultAddress() {
        
        iapShippingAddressSelectionViewcontroller.getDefaultAddress(userAddressInfo!)
        iapShippingAddressSelectionViewcontroller.loadDecoratorWithAddress(userAddressInfo!)
        XCTAssertNotNil(iapShippingAddressSelectionViewcontroller.addressDecorator.address != nil, "address list is noy populated")
    }
    
    func testDidSelectAddAddress() {
        let navController = IAPTestNavigationController()
        navController.pushViewController(iapShippingAddressSelectionViewcontroller, animated: false)
        iapShippingAddressSelectionViewcontroller.didSelectAddAddress((userAddressInfo?.address[0])!)
        XCTAssert(navController.pushedViewController is IAPShippingAddressEditViewController, "IAPShippingAddressEditViewController was not pushed")
    }
    
    func testDidSelectEditAddress() {
        let navController = IAPTestNavigationController()
        navController.pushViewController(iapShippingAddressSelectionViewcontroller, animated: false)
        iapShippingAddressSelectionViewcontroller.didSelectEditAddress((userAddressInfo?.address[0])!)
        XCTAssert(navController.pushedViewController is IAPShippingAddressEditViewController, "IAPShippingAddressEditViewController was not pushed")
        //IAPLocalizedString("iap_delete_item_alert_title")
    }
    
    func testDidSelectDeleteAddress() {
        iapShippingAddressSelectionViewcontroller.didSelectDeleteAddress((userAddressInfo?.address[0])!)
        XCTAssertNotNil(iapShippingAddressSelectionViewcontroller.uidAlertController?.title == IAPLocalizedString("iap_delete_item_alert_title"), "Delete pop up title is not matching")
    }
    
    func testNavigateToBillingAddressScreen() {
        let paymentDict = self.deserializeData("IAPPaymentDetailsInfo")
        XCTAssertNotNil(paymentDict, "JSON has not been deserialsed")
        
        let paymentDetails = IAPPaymentDetailsInfo(inDict: paymentDict!)
        XCTAssert (paymentDetails.arrayOfPaymentDetails.count > 0, "Payment details are not of right count")
        
        let navController = IAPTestNavigationController()
        navController.pushViewController(iapShippingAddressSelectionViewcontroller, animated: false)
        
        iapShippingAddressSelectionViewcontroller.navigateToBillingDetailsScreen([], address: (userAddressInfo?.address[0])!)
        XCTAssert(navController.pushedViewController is IAPShippingAddressEditViewController, "IAPShippingAddressEditViewController was not pushed")
        
        //navController.pushViewController(iapShippingAddressSelectionViewcontroller, animated: false)
        iapShippingAddressSelectionViewcontroller.navigateToBillingDetailsScreen(paymentDetails.arrayOfPaymentDetails, address: (userAddressInfo?.address[0])!)
        XCTAssert(navController.pushedViewController is IAPPaymentSelectionViewController, "IAPPaymentSelectionViewController was not pushed")
    }
    
    func testDidSelectDeliverToAddress() {
        iapShippingAddressSelectionViewcontroller.didSelectDeliverToAddress((userAddressInfo?.address[0])!)
    }
    
    func testSendRequestToSetDeliveryMode() {
        iapShippingAddressSelectionViewcontroller.sendRequestToSetDeliveryMode((userAddressInfo?.address[0])!)
    }
    
    func testUpdateDeliveryMode() {
        iapShippingAddressSelectionViewcontroller.updateDeliveryMode("standard-ground", inAddress: (userAddressInfo?.address[0])!)
    }
    
    func testFetchPaymentDetails() {
        iapShippingAddressSelectionViewcontroller.fetchPaymentDetails((userAddressInfo?.address[0])!)
    }
    
}
