/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOCCPaymentHTTPInterfaceTests: XCTestCase {
    
    // MARK:
    // MARK: Place Order related unit tests
    // MARK:
    
    func testPaymentInterfaceCreation() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withCVV("1234").buildInterface()
        let httpInterface = occInterface.getInterfaceForPlacingOrder()
        XCTAssertNotNil(httpInterface, "Interface returned is nil")
    }
    
    func testPlaceOrderSuccess() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withCVV("1234").buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCPlaceOrder"
        
        occInterface.placeOrderForUserUsingInterface(httpInterface, completionHandler: { (withOrder) in
            XCTAssertNotNil(withOrder, "The order returned is nil")
            }) { (inError) in
                XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testPlaceOrderError() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withCVV("1234").buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.placeOrderForUserUsingInterface(httpInterface, completionHandler: { (withOrder) in
            XCTAssertNotNil(withOrder, "The order returned is nil")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }

    // MARK:
    // MARK: Get Payment details
    // MARK:
    func testInterfaceCreationForPaymentDetails() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withCVV("1234").buildInterface()
        let httpInterface = occInterface.getInterfaceForPaymentDetails()
        XCTAssertNotNil(httpInterface, "Interface returned is nil")
    }
    
    func testGetPaymentDetailsSuccess() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPPaymentDetailsInfo"
        
        occInterface.getPaymentDetailsForUserUsingInterface(httpInterface, completionHandler: { (withPayments) in
            XCTAssertNotNil(withPayments, "The order returned is nil")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetPaymentDetailsError() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getPaymentDetailsForUserUsingInterface(httpInterface, completionHandler: { (withOrder) in
            XCTAssertNotNil(withOrder, "The order returned is nil")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    // MARK:
    // MARK: Make Payment details
    // MARK:
    func testInterfaceCreationForMakePaymentDetails() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        occInterface.addressID = "12345"
        let httpInterface = occInterface.getInterfaceForMakePayment()
        XCTAssertNotNil(httpInterface, "Interface returned is nil")
    }
    
    func testMakePaymentSuccess() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCMakePayment"
        
        occInterface.makePaymentDetailsForUserUsingInterface(httpInterface,completionHandler: { (withPayments:IAPMakePaymentInfo) in
            XCTAssertNotNil(withPayments, "Payments returned are nil")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testMakePaymentError() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.makePaymentDetailsForUserUsingInterface(httpInterface,completionHandler: { (withPayments:IAPMakePaymentInfo) in
            XCTAssertNotNil(withPayments, "Payments returned are nil")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    // MARK:
    // MARK: Delivery Modes related
    // MARK:
    func testInterfaceCreationForFetchingDeliveryModes() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        let httpInterface = occInterface.getInterfaceForRetreivingDeliveryModes()
        XCTAssertNotNil(httpInterface, "Interface returned is nil")
    }
    
    func testGettingDeliveryModes() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPDeliveryMode"
        
        occInterface.getDeliveryModesUsingInterface(httpInterface, completionHandler: { (withDeliveryMode) in
            XCTAssertNotNil(withDeliveryMode, "Delivery mode is returned nil")
            }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGettingDeliveryModesError() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getDeliveryModesUsingInterface(httpInterface, completionHandler: { (withDeliveryMode) in
            XCTAssertNotNil(withDeliveryMode, "Delivery mode is returned nil")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testInterfaceCreationForSettingDeliveryModes() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        let httpInterface = occInterface.getInterfaceForSettingDeliveryMode("12345")
        XCTAssertNotNil(httpInterface, "Interface returned is nil")
    }
    
    func testSettingDeliveryMode() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        
        occInterface.setDeliveryModeForUserUsingInterface(httpInterface, completionHandler: { (inSuccess) in
            XCTAssert(inSuccess == true, "Value returned is not proper")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testSettingDeliveryModeError() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.setDeliveryModeForUserUsingInterface(httpInterface, completionHandler: { (inSuccess) in
            XCTAssert(inSuccess == true, "Value returned is not proper")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    // MARK:
    // MARK: Payment Re-Auth related
    // MARK:
    func testInterfaceCreationForReauthPayment() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        occInterface.paymentID = "12345"
        
        let httpInterface = occInterface.getInterfaceForPaymentReauth()
        XCTAssertNotNil(httpInterface, "Interface returned is nil")
    }
    
    func testSetReAuthPayment() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        occInterface.paymentID = "12345"

        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        
        occInterface.setReauthPaymentDetailsForUserUsingInterface(httpInterface, completionHandler: { (inSuccess) in
            XCTAssert(inSuccess == true, "Value returned is not proper")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testSetReAuthPaymentError() {
        let occInterface = IAPOCCPaymentInterfaceBuilder(inUserID: "1234")!.withOrderID("1234").buildInterface()
        occInterface.paymentID = "12345"

        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.setReauthPaymentDetailsForUserUsingInterface(httpInterface, completionHandler: { (inSuccess) in
            XCTAssert(inSuccess == true, "Value returned is not proper")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testAddressPaymentBaseInterface() {
        let occInterface = IAPOCCPaymentAddressBaseInterface()
        occInterface.titleCode = "Mr"
        occInterface.firstName = "First Name"
        occInterface.lastName  = "Last Name"
        occInterface.phone1    = "12345"
        occInterface.phone2    = "54321"
        occInterface.addressLine1   = "Line1"
        occInterface.addressLine2   = "Line2"
        occInterface.postalCode     = "98037"
        occInterface.countryCode    = "IN"
        occInterface.regionCode     = "KA"
        occInterface.town           = "Bangalore"
        
        let dictionary = occInterface.getAddressDictionary()
        XCTAssertNotNil(dictionary,"Dictionary returned is nil")
        
        var value = dictionary[IAPConstants.IAPOCCHeader.kTownKey]
        XCTAssert(value == occInterface.town, "town returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kTitleCodeKey]
        XCTAssert(value == occInterface.titleCode, "title code returned is not right")
        
        value = dictionary[IAPConstants.IAPOCCHeader.kPostalCodeKey]
        XCTAssert(value == occInterface.postalCode, "Postal code returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kAddressLine1]
        XCTAssert(value == occInterface.addressLine1, "Address Line 1 returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kFirstNameKey]
        XCTAssert(value == occInterface.firstName, "First name returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kLastNameKey]
        XCTAssert(value == occInterface.lastName, "Last name returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kCountryCode]
        XCTAssert(value == occInterface.countryCode, "Country code returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kAddressLine2]
        XCTAssert(value == occInterface.addressLine2, "Address Line 2 returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kPhone1]
        XCTAssert(value == occInterface.phone1, "Phone number 1 returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kPhone2]
        XCTAssert(value == occInterface.phone2, "Phone number 2 returned is not right")

        value = dictionary[IAPConstants.IAPOCCHeader.kRegionCode]
        XCTAssert(value == occInterface.regionCode, "Region code returned is not right")

    }
}
