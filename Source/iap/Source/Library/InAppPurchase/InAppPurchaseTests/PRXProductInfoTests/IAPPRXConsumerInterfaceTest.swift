/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev


class IAPPRXConsumerInterfaceTest: XCTestCase {
    
    func testInterfaceCreation(){
        let consumerInterface = IAPPRXConsumerInterface(inLocale: "en_US", inCategoryCode: "INTERCARE_SU")
        let httpInterface = consumerInterface.getInterfaceForConsumerCare()
        
        XCTAssertNotNil(httpInterface,"Interface created is nil")
    }
    
    func testGetConsumerCareDetailSuccess() {
        let consumerInterface = IAPPRXConsumerInterface(inLocale: "en_US", inCategoryCode: "INTERCARE_SU")
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPPRXConsumerResponse"
        
        consumerInterface.getConsumerCareInformation(httpInterface, completionHandler: { (withConsumerCare) in
            XCTAssertNotNil(withConsumerCare, "Get Retailers returned nil")
            XCTAssert(withConsumerCare.getPhoneNumber() == "1-800-682-7664", "Phone numbers dont match")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetConsumerCareDetailFailure() {
        let consumerInterface = IAPPRXConsumerInterface(inLocale: "en_US", inCategoryCode: "INTERCARE_SU")
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPPRXConsumerResponse"
        httpInterface.isErrorToBeInvoked = true
        
        consumerInterface.getConsumerCareInformation(httpInterface, completionHandler: { (withConsumerCare) in
            XCTAssertNotNil(withConsumerCare, "Get Retailers returned nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
}
