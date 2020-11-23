/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPPaymentDetailsInfoTests: XCTestCase  {
    
    func testPaymentDetailsInfo() {
        let paymentDict = self.deserializeData("IAPPaymentDetailsInfo")
        XCTAssertNotNil(paymentDict, "JSON has not been deserialsed")
        
        let paymentDetails = IAPPaymentDetailsInfo(inDict: paymentDict!)
        XCTAssert (paymentDetails.arrayOfPaymentDetails.count > 0, "Payment details are not of right count")
        
        for paymentInfo in paymentDetails.arrayOfPaymentDetails {
            XCTAssertNotNil(paymentInfo.getAccountHolderName())
            XCTAssertNotNil(paymentInfo.getCardnumber())
            XCTAssertNotNil(paymentInfo.getCardType())
            XCTAssertNotNil(paymentInfo.getExpiryMonth())
            XCTAssertNotNil(paymentInfo.getExpiryYear())
            XCTAssertNotNil(paymentInfo.getPaymentId())
            XCTAssertNotNil(paymentInfo.getLastSuccessfulOrderDate())
            XCTAssertNotNil(paymentInfo.getDefaultPayment())
            XCTAssertNotNil(paymentInfo.getBillingAddress())
        }
    }
    
}
