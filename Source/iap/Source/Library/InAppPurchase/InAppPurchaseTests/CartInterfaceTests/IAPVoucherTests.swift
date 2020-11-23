/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPVoucherTests: XCTestCase {
    
     var voucherList: [IAPVoucher]?
    
    override func setUp() {
        super.setUp()
        
        let voucherDict = self.deserializeData("IAPOCCVoucher")
        XCTAssertNotNil(voucherDict, "JSON has not been deserialsed")
        let voucherListInfo = IAPVoucherList(inDict: voucherDict!)
        voucherList = voucherListInfo.voucherList
        
        XCTAssert (voucherList!.count > 0, "Voucher list are not of right count")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        voucherList = nil
    }
    
}
