/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev
@testable import PhilipsUIKitDLS

class IAPPurchaseHistoryOrderDetailsPriceSummaryCellTests: XCTestCase {
    
    weak var delegate:IAPPriceSummaryCellProtocol?
    var priceSummaryCell: IAPPurchaseHistoryOrderDetailsPriceSummaryCell?
    var priceSummaryCellDelegateTest: IAPPurchaseHistoryOrderDetailsPriceSummaryCellTest!
    
    override func setUp() {
        super.setUp()
        priceSummaryCellDelegateTest = IAPPurchaseHistoryOrderDetailsPriceSummaryCellTest()
        priceSummaryCell = IAPPurchaseHistoryOrderDetailsPriceSummaryCell.instanceFromNib()
    }
    
    func testCancelMyButtonPressed() {
        let sender:UIDButton = UIDButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        priceSummaryCell?.priceSummaryCellDelegate = priceSummaryCellDelegateTest
        priceSummaryCell?.cancelMyOrder(sender)
        XCTAssertTrue(priceSummaryCellDelegateTest.cancelMyOrderMethodInvoked == true, "Try Again Button is not tapped")
    }
    
    func testSetSelected() {
        priceSummaryCell?.setSelected(true, animated: false)
        XCTAssertNotNil(priceSummaryCell, "Cell is not available")
    }
}

class IAPPurchaseHistoryOrderDetailsPriceSummaryCellTest: IAPPriceSummaryCellProtocol {
    var cancelMyOrderMethodInvoked = false

    func userSelectedcancelButton(_ inSender: IAPPurchaseHistoryOrderDetailsPriceSummaryCell) {
        cancelMyOrderMethodInvoked = true
    }
}
