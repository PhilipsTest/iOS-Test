/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import AdobeMobileSDK

@testable import InAppPurchaseDev

class IAPAddressInterfaceTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        IAPConfiguration.sharedInstance.baseURL = "https://www.occ.shop.philips.com"
    }
    
    override class func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    func testInterfaceCreation() {
        var occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        
        var httpInterface = occInterface.getInterfaceForDefaultAddress()
        XCTAssertNotNil(occInterface,"OCC Address interface created is nil")
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for default address")
        
        httpInterface = occInterface.getInterfaceForGetAddress()
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for get address")
        
        httpInterface = occInterface.getInterfaceForAddDeliveryAddress()
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for add address")
        
        occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.withAddressID("").buildInterface()
        occInterface.defaultAddress = true
        httpInterface = occInterface.getInterfaceForUpdateAddress()
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for update address")
        
        httpInterface = occInterface.getInterfaceForDeleteAddress()
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for delete address")
        
        httpInterface = occInterface.getInterfaceForRegions("US")
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for get regions")
        
        httpInterface = occInterface.getInterfaceForSetDeliveryAddressID()
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for set address")
        
        let builder = IAPOCCAddressInterfaceBuilder(inUserID: "")
        XCTAssertNil(builder, "Builder is initialised despite user ID being 0 length")
    }
    
    func testGetDefaultAddressSuccess() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetUser"
        
        occInterface.getDefaultAddressForUserUsingInterface(httpInterface, completionHandler: { (defaultAddress) in
            XCTAssertNotNil(defaultAddress, "Default Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetDefaultAddressFailure() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetUser"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getDefaultAddressForUserUsingInterface(httpInterface, completionHandler: { (defaultAddress) in
            XCTAssertNotNil(defaultAddress, "Default Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testEmptyDefaultAddress() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        
        occInterface.getDefaultAddressForUserUsingInterface(httpInterface, completionHandler: { (defaultAddress) in
            XCTAssertNil(defaultAddress, "Default Address returned is not nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetAddressSuccess(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetAddress"
        
        occInterface.getAddressesForUser(httpInterface, completionHandler: { (addresses) in
            XCTAssertNotNil(addresses, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetAddressFailure(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetAddress"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getAddressesForUser(httpInterface, completionHandler: { (addresses) in
            XCTAssertNotNil(addresses, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testAddAddressSuccess(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCAddAddress"
        
        occInterface.addDeliveryAddressForUser(httpInterface, completionHandler: { (withAddress) in
            XCTAssertNotNil(withAddress, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testAddAddressFailure(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCAddAddress"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.addDeliveryAddressForUser(httpInterface, completionHandler: { (withAddress) in
            XCTAssertNotNil(withAddress, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testUpdateAddressSuccess(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        
        occInterface.updateDeliveryAddressForUser(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testUpdateAddressFailure(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        
        occInterface.updateDeliveryAddressForUser(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testDeleteAddressSuccess(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        
        occInterface.deleteAdress(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testDeleteAddressFailure(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        
        occInterface.deleteAdress(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetRegionsSuccess(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetRegions"
        
        occInterface.getRegionsForCountryCode(httpInterface, completionHandler: { (regions) in
            XCTAssertNotNil(regions, "Region returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetRegionsFailure(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetRegions"
        httpInterface.isErrorToBeInvoked = true
        
        
        occInterface.getRegionsForCountryCode(httpInterface, completionHandler: { (regions) in
            XCTAssertNotNil(regions, "Region returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testSetDeliveryAddressSuccess(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        
        occInterface.setDeliveryAddressIDForUser(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testSetDeliveryAddressFailure(){
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        
        occInterface.setDeliveryAddressIDForUser(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
}
