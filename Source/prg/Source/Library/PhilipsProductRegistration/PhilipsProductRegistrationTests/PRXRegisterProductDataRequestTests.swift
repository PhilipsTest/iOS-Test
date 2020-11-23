//
//  PRXRegisterProductDataRequestTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsPRXClient
import PhilipsRegistration
import PlatformInterfaces

@testable import PhilipsProductRegistrationDev

class PRXRegisterProductDataRequestTests: PPRBaseClassTests {

    var registerProductDataJsonObject: PPRRegisterProductJSONObject?
    var productInfoTests: PRXRegisterProductInfoDataTests?
    var regIno: PPRProductObject?
    let ctn  = PPRTestConstants.ctn
    let serialNum = PPRTestConstants.serialNum
    let userInterface: UserDataInterface = DIUser.getInstance()
    lazy var accessToken =  {
        return try? self.userInterface.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN]
    }
    lazy var receiveMarketingEmail =  {
        return DIUserMock.getInstance().receiveMarketingEmails
    }
    
    override func setUp() {
        super.setUp()
        registerProductDataJsonObject = PPRRegisterProductJSONObject()
        productInfoTests = PRXRegisterProductInfoDataTests()
    }
    
    func testBodyParameters() {
        let product = PPRProduct(ctn: "123", sector: DEFAULT, catalog: CONSUMER)
        let registerRequest = PRXRegisterProductRequest(product: product,
                                                        accessToken: "12345",
                                                        micrositeID: "54321",
                                                        receiveMarketingEmail: receiveMarketingEmail())
        let bodyParam:[AnyHashable : Any] = registerRequest.getBodyParameters()
        
        let dataDict:[AnyHashable : Any] = bodyParam["data"] as! [AnyHashable : Any]
        let attributeDict:[String: Any] = dataDict["attributes"] as! [String : Any]
        let userProfileDict:[String: Any] = attributeDict["userProfile"] as! [String : Any]
        
        XCTAssertTrue(bodyParam.count == 2)
        XCTAssertTrue(dataDict.count == 2)
        XCTAssertTrue(registerRequest.getRequestType() == POST)
        XCTAssertTrue(userProfileDict["optIn"] as! Bool == false)
        XCTAssertTrue(attributeDict["micrositeId"] as? String == "54321")
        XCTAssertTrue(attributeDict["productId"] as? String == "123")
        XCTAssertTrue(attributeDict["sector"] as? String == "B2C")
        XCTAssertTrue(attributeDict["catalog"] as? String == "CONSUMER")
        XCTAssertNil(attributeDict["purchased"])
    }
    
    /*func testParametersWithEmptyInfoWithAccessToken() {
        let product = PPRProduct(ctn: "", sector: DEFAULT, catalog: CONSUMER)
        let registerRequest = PRXRegisterProductRequest(product: product,
                                                        accessToken: nil,
                                                        micrositeID: nil,
                                                        receiveMarketingEmail: receiveMarketingEmail())
        let hederParam = registerRequest.getHeaderParam()
        let bodyParam = registerRequest.getBodyParameters()
        
        XCTAssertTrue((hederParam?.isEmpty)!)
        XCTAssertTrue(bodyParam?.count == 2)
        XCTAssertTrue(registerRequest.getRequestType() == POST)
    }
    
    func testHeaderParametersWithProductInfoOnly() {
        let purchasedate = Date().addingTimeInterval(-30)
        let product = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: purchasedate)
        let registerRequest = PRXRegisterProductRequest(product: product,
                                                        accessToken: nil,
                                                        micrositeID: nil,
                                                        receiveMarketingEmail: receiveMarketingEmail())
        let hederParam = registerRequest.getHeaderParam()
        let bodyParam = registerRequest.getBodyParameters()
        
        XCTAssertNotNil(hederParam)
        XCTAssertNotNil(bodyParam)
        XCTAssertTrue(registerRequest.getRequestType() == POST)
        XCTAssertEqual(bodyParam?[PPRPurchaseDate] as? String, purchasedate.stringDateWith("yyyy-MM-dd"))
        XCTAssertEqual(bodyParam?[PPRSerialNumber] as? String, serialNum)
        XCTAssertNil(bodyParam?[PPRRegistrationChannel])
        XCTAssertNil(hederParam?[PPRUserAccessToken])
    }
    
    func testRegisterProductDataRequestUrlForNLLocale() {
        let locale = "nl_NL"
        let registerProductDataRequest = fakeRegisterProductDataRequest(locale)
        registerProductDataRequest.getRequestUrl(from:  self.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
            XCTAssertEqual(serviceURL, "https://www.philips.com/prx/registration/DEFAULT/en_IN/CONSUMER/products/\(PPRTestConstants.ctn).register.type.product")
            self.verifyParameters(registerProductDataRequest)
        })
    }
    
    func testRegisterProductDataRequestUrlForENLocale() {
        let locale = "en_US"
        let registerProductDataRequest = fakeRegisterProductDataRequest(locale)
        registerProductDataRequest.getRequestUrl(from: self.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
            XCTAssertEqual(serviceURL, "https://www.philips.com/prx/registration/DEFAULT/en_IN/CONSUMER/products/\(PPRTestConstants.ctn).register.type.product")
            self.verifyParameters(registerProductDataRequest)
        })
    }
    
    func testRegisterProductDataRequestWithNilResponse() {
        let registerProductDataRequest = fakeRegisterProductDataRequest()
        let response: PRXRegisterProductResponse = registerProductDataRequest.getResponse(nil) as! PRXRegisterProductResponse
        self.verifyParameters(registerProductDataRequest)
        XCTAssertFalse(response.success)
        XCTAssertNil(response.data)
    }
    
    func testRegisterProductDataRequestWithEmptyData() {
        let registerProductDataRequest = fakeRegisterProductDataRequest()
        let dict = NSDictionary(dictionary: ["success" : true , "data": NSDictionary()])
        let response: PRXRegisterProductResponse = registerProductDataRequest.getResponse(dict) as! PRXRegisterProductResponse
        let productInfo = response.data
        self.verifyParameters(registerProductDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(productInfo != nil)
        productInfoTests?.verifyEmptyData(productInfo!)
    }
    
    func testRegisterProductDataRequestWithSuccessWithDiffrentValues() {
        let registerProductDataRequest = fakeRegisterProductDataRequest()
        let dict = registerProductDataJsonObject!.fakeValidStructureWithDifferenValues()
        let response: PRXRegisterProductResponse = registerProductDataRequest.getResponse(dict) as! PRXRegisterProductResponse
        let productInfo = response.data
        self.verifyParameters(registerProductDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(productInfo)
        productInfoTests?.verifyInValidData(productInfo!)
    }
    
    func testRegisterProductDataRequestWithValidResponseStructure() {
        let registerProductDataRequest = fakeRegisterProductDataRequest()
        let dict = registerProductDataJsonObject!.fakeValidResponse()
        let response: PRXRegisterProductResponse = registerProductDataRequest.getResponse(dict) as! PRXRegisterProductResponse
        let productInfo = response.data
        self.verifyParameters(registerProductDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(productInfo != nil)
        productInfoTests?.verifyValidData(productInfo!)
    }
    
    func verifyParameters(_ request: PRXRegisterProductRequest) {
        let registerRequest = request
        let headerParam = registerRequest.getHeaderParam()
        let param = registerRequest.getBodyParameters()
        XCTAssertNotNil(headerParam)
        XCTAssertNotNil(param)
        XCTAssertTrue(registerRequest.getRequestType() == POST)
        XCTAssertEqual(param?[PPRPurchaseDate] as? String, registerRequest.purchaseDate.stringDateWith("yyyy-MM-dd"))
        XCTAssertEqual(param?[PPRSerialNumber] as? String, serialNum)
        XCTAssertNotNil(param?[PPRRegistrationChannel] as? String, ((self.appInfra?.appIdentity.getMicrositeId())! as String))
//        XCTAssertEqual(headerParam?[PPRUserAccessToken] as? String, self.accessToken)
    }
    
    fileprivate func fakeRegisterProductDataRequest(_ locale:String)->PRXRegisterProductRequest {
        let registerProductDataRequest = fakeRegisterProductDataRequest()
//        registerProductDataRequest.setLocaleMatchResult(locale)
        return registerProductDataRequest
    }
    
    fileprivate func fakeRegisterProductDataRequest()->PRXRegisterProductRequest{
        let product = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let registerProductDataRequest = PRXRegisterProductRequest(product: product,
                                                                   accessToken: self.accessToken() as? String,
                                                                   micrositeID: ((self.appInfra?.appIdentity.getMicrositeId())! as String), receiveMarketingEmail:receiveMarketingEmail())
        return registerProductDataRequest
    }*/
}
