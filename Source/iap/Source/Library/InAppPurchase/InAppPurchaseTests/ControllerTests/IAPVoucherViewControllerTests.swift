//
//  IAPVoucherViewControllerTests.swift
//  InAppPurchaseTests
//
//  Created by sameer sulaiman on 9/20/18.
//  Copyright © 2018 Rakesh R. All rights reserved.
//

import XCTest
@testable import PhilipsUIKitDLS
@testable import InAppPurchaseDev

class IAPVoucherViewControllerTests: XCTestCase {
    var iapVoucherVC: IAPVoucherViewController!
    var sender:UIDButton!
    var voucherList: [IAPVoucher]?
    
    override func setUp() {
        super.setUp()
        let vc = IAPVoucherViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        vc.loadView()
        iapVoucherVC = vc

        iapVoucherVC.viewDidLoad()
        iapVoucherVC.viewWillAppear(false)
        
        sender = UIDButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        
        // Initializing voucher obj
        let voucherDict = self.deserializeData("IAPOCCVoucher")
        XCTAssertNotNil(voucherDict, "JSON has not been deserialsed")
        let voucherListInfo = IAPVoucherList(inDict: voucherDict!)
        voucherList = voucherListInfo.voucherList
        
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    func testVoucherList(){
        XCTAssert (voucherList!.count > 0, "Voucher list are not of right count")
    }
    
    func testApplyVoucherButtonClicked() {
       // XCTAssertNotNil([self.vc appReviewButton],@"appReviewButton should be connected");
        iapVoucherVC.applyButtonClicked(sender: sender)
        XCTAssertNotNil(iapVoucherVC.voucherApplyBtn, "Apply Voucher button enabled")
        
    }
    
    func testTextField() {
        iapVoucherVC.voucherTextField?.text = "abc"
        XCTAssertTrue((iapVoucherVC.voucherTextField?.text?.length)! == 3, "voucher used is not nil")
                
        self.iapVoucherVC.voucherTextField?.text = "123"
        let result = self.iapVoucherVC.textField(self.iapVoucherVC.voucherTextField!, shouldChangeCharactersIn: NSRange(), replacementString: "a")
        XCTAssertTrue(result)
    }

    
//    func testTotalVoucherDiscount(){
//        XCTAssertNotNil(iapVoucherVC.totalDiscountValue(voucherList: self.voucherList!), "voucher total not nil")
//    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        voucherList = nil
    }
}
