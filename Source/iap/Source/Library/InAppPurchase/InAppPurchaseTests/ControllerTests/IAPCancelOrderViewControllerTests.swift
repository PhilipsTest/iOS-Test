/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsUIKitDLS
@testable import InAppPurchaseDev

class IAPCancelOrderViewControllerTests: XCTestCase {
    
    var iapCancelOrderVC = IAPCancelOrderViewController()
    var orderNumber: String!
    var consumerModelTest: IAPPRXConsumerModel!
    var orderDetail: IAPPurchaseHistoryModel!
    var consumerCareInfo: IAPPRXConsumerModel!
    
    override func setUp() {
        super.setUp()
        let orderDict = self.deserializeData("IAPGetOrdersResponse")

        if let orderList = orderDict!["orders"] as? [[String: AnyObject]] {
            let order = orderList[0]
            orderDetail = IAPPurchaseHistoryModel(inDictionary: order)
            let orderDetailDict = self.deserializeData("IAPGetOrderDetailResponse")
            orderDetail.initialiseOrderDetails(orderDetailDict!)
            let consumerDict = self.deserializeData("IAPPRXConsumerResponse")
            consumerModelTest = IAPPRXConsumerModel(inDict: consumerDict!)
        } else {
            assertionFailure("order list creation failed")
        }
        let orderVC = IAPCancelOrderViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        orderVC.loadView()
        iapCancelOrderVC = orderVC
        iapCancelOrderVC.orderNumber = orderDetail.getOrderID()
        iapCancelOrderVC.consumerModel = consumerModelTest
        iapCancelOrderVC.viewDidLoad()
        iapCancelOrderVC.viewWillAppear(false)
    }
    
    func testCallButtonClicked() {
        let sender: UIDButton = UIDButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        iapCancelOrderVC.callButtonClicked(sender)
        XCTAssertNotNil(iapCancelOrderVC.consumerModel.getPhoneNumber(), "Phone number is nil")
    }
}
