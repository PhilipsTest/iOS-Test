/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPConfigurationManagerTests: XCTestCase {
    
    func testConfigurationInterfaceCreation() {
        let configuarationManager = IAPConfigurationManager()
        let interfaceToBeUsed = configuarationManager.getInterfaceForConfiguration()
        XCTAssertNotNil(interfaceToBeUsed, "Interface returned is nil")
    }
    
    func testGetConfigurationForSuccess() {
        let configuarationManager = IAPConfigurationManager()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPConfigurationResponse"
        
        configuarationManager.getConfigurationDataWithInterface(httpInterface, successCompletion:{ (inData: IAPConfigurationData) in
            XCTAssertNotNil(inData, "Data returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        IAPConfiguration.sharedInstance.configuration = IAPConfigurationData()
        configuarationManager.getConfigurationDataWithInterface(httpInterface, successCompletion:{ (inData: IAPConfigurationData) in
            XCTAssertNotNil(inData, "Data returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
    }
    
    func testGetConfigurationForFailure() {
        let configuarationManager = IAPConfigurationManager()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        configuarationManager.getConfigurationDataWithInterface(httpInterface, successCompletion:{ (inData: IAPConfigurationData) in
            XCTAssertNotNil(inData, "Data returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
    }
}
