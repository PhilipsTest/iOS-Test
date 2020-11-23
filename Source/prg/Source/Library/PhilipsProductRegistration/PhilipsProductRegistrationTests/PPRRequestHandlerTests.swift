//
//  PPRRequestHandlerTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsPRXClient

@testable import PhilipsProductRegistrationDev

class PPRRequestHandlerTests: PPRBaseClassTests {
    
    func testGetSignedInUserWithProductWithMock() {
        let userWithProducts = PPRUserWithProducts()
        let regHelper =  PPRProductRegistrationHelperMock()
        regHelper.userWithProducts = userWithProducts
        XCTAssertEqual(regHelper.getSignedInUserWithProudcts(), userWithProducts)
    }
    
    /*func testUserLoginSuccess() {
        let error = PPRErrorHelper().createCustomError(error: PPRError.USER_NOT_LOGGED_IN)
        let delegateMock = PPRRegisterProductDelegateMock()
        let userMock = DIUserMock.sharedInstance
        let userWithProduct = PPRUserProductMock()
        userWithProduct.productStore = fakeStoreWithOneProduct(error)
        userWithProduct.getProductListRequsetMock = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        
        let regHelper = PPRProductRegistrationHelperMock()
        regHelper.userWithProducts = userWithProduct
        regHelper.user = userMock
        regHelper.delegate = delegateMock
        let expectation = self.expectation(description: "Registration")
        delegateMock.asyncExpectation = expectation
        //regHelper.getSignedInUserWithProudcts()
    
        userMock.inovkeLoginSucess()
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.USER_NOT_LOGGED_IN.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }*/
    
    /*func testUserRegistrationSuccess() {
        let error = PPRErrorHelper().createCustomError(error: PPRError.USER_NOT_LOGGED_IN)
        let delegateMock = PPRRegisterProductDelegateMock()
        let userMock = DIUserMock.sharedInstance
        let userWithProduct = PPRUserProductMock()
        userWithProduct.productStore = fakeStoreWithOneProduct(error)
        userWithProduct.getProductListRequsetMock = PRXRequestManagerMock.mockResponse(PPRProductListResponse(data: nil))
        
        let regHelper = PPRProductRegistrationHelperMock()
        regHelper.userWithProducts = userWithProduct
        regHelper.user = userMock
        regHelper.delegate = delegateMock
        let expectation = self.expectation(description: "Registration")
        delegateMock.asyncExpectation = expectation
        regHelper.getSignedInUserWithProudcts()
        
        userMock.inovkeRegistrationSucess()
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.USER_NOT_LOGGED_IN.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }*/
    
    
    func  testRegisterProductWithUserNotLoggedinError() {
        let product = PPRProductMock(ctn: PPRTestConstants.RegistredCtn, sector: B2C, catalog: CONSUMER)
        product.serialNumber = PPRTestConstants.serialNum
        
        let userMock = DIUserMock.sharedInstance
        userMock.isUserLoggedIn = false
        let userProductMock = PPRUserProductMock()
        let delegateMock = PPRRegisterProductDelegateMock()
        
        
        let requestHandler = PPRProductRegistrationHelperMock()
        requestHandler.delegate = delegateMock
        let expectation = self.expectation(description: "Registration")
        delegateMock.asyncExpectation = expectation
        requestHandler.user = userMock
        requestHandler.userWithProducts = userProductMock
        
        let userProduct = requestHandler.getSignedInUserWithProudcts()
        userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
    
            guard delegateMock.product?.error?.code == PPRError.USER_NOT_LOGGED_IN.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    /*func  testRegisterProductWithRequiredPurchasedateError() {
        let product = PPRProductMock(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.serialNumber = PPRTestConstants.RegistredSerialNum
        
        let userMock = DIUserMock.mockDIUser(with: true, accessToken: nil)
        product.requestManagerMock = PRXRequestManagerMock.mockMetadataResponse(true, isPurchasedataReuired: true)
        let productListMock = PRXRequestManagerMock()
        productListMock.response = fakeProductResultData()
        let userProductMock = PPRUserProductMock()
        userProductMock.getProductListRequsetMock = productListMock
        let delegateMock = PPRRegisterProductDelegateMock()
        
        let requestHandler = PPRProductRegistrationHelperMock()
        requestHandler.delegate = delegateMock
        let expectation = self.expectation(description: "Registration")
        delegateMock.asyncExpectation = expectation
        requestHandler.user = userMock
        requestHandler.userWithProducts = userProductMock
        
        let userProduct = requestHandler.getSignedInUserWithProudcts()
        userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.REQUIRED_PURCHASE_DATE.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }*/
    
    /*func  testRegisterProduct() {
        let product = PPRProductMock(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        
        let userMock = DIUserMock.mockDIUser(with: true, accessToken: nil)
        product.requestManagerMock = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        let userProductMock = PPRUserProductMock()
        userProductMock.getProductListRequsetMock = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        userProductMock.registerRequestMock = PRXRequestManagerMock.mockResponse(self.fakeRegisterProduct())
        let delegateMock = PPRRegisterProductDelegateMock()
        
        let requestHandler = PPRProductRegistrationHelperMock()
        requestHandler.delegate = delegateMock
        let expectation = self.expectation(description: "Registration")
        delegateMock.asyncExpectation = expectation
        requestHandler.user = userMock
        requestHandler.userWithProducts = userProductMock
        
        let userProduct = requestHandler.getSignedInUserWithProudcts()
        userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error == nil else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }*/
    
    func  testGetListOfRegisterProducts() {
        let product = PPRProductMock(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        
        let userMock = DIUserMock.mockDIUser(with: true, accessToken: nil)
        product.requestManagerMock = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        let userProductMock = PPRUserProductMock()
        userProductMock.getProductListRequsetMock = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        
        let requestHandler = PPRProductRegistrationHelperMock()
        requestHandler.user = userMock
        let expect = self.expectation(description: "Register")
        requestHandler.userWithProducts = userProductMock
        
        let userProduct = requestHandler.getSignedInUserWithProudcts()
        userProduct.getRegisteredProducts({ (data) in
            XCTAssertNotNil(data)
            expect.fulfill()
        }) { (error) in
            XCTAssertNotNil(error)
        }
        self.waitForExpectations(timeout: PPRTestConstants.Timeout, handler: nil)
    }
    
    func fakeProductResultData() -> PPRProductListResponse {
        let dict = PPRRegisteredProductListJSONObject().fakeRegisteredProductList()
        let prxResponse = PRXProductListResponse(withDictonary: dict)!
        return PPRProductListResponse.productListResponseFrom(prxResponse: prxResponse, userUUID: nil)
    }
    
    func fakeRegisterProduct() -> PRXRegisterProductResponse {
        let dict = PPRRegisterProductJSONObject().fakeValidResponse()
        return PRXRegisterProductResponse(withDictonary: dict)!
    }
    
    fileprivate func fakeStoreWithOneProduct(_ error: NSError?) -> PPRRegisteredProductListStoreMock {
        let product = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn,
                                                 serialNum: PPRTestConstants.RegistredSerialNum,
                                                 date: nil,
                                                 sector: B2C,
                                                 catalog: CONSUMER,
                                                 error: error,
                                                 endWarrenty: Date(),
                                                 uuid: nil,
                                                 locale: nil,
                                                 emailStatus: "Email sending was successful")
        return PPRRegisteredProductListStoreMock.mockListStoreWith([product])
    }
    
    fileprivate func fakeRegisteredProduct(_ ctn: String?,
                                       serialNum: String!,
                                       date: Date!,
                                       sector: Sector,
                                       catalog: Catalog,
                                       error:NSError?,
                                       endWarrenty: Date!,
                                       uuid: String!,
                                       locale: String!,
                                       emailStatus: String!) -> PPRRegisteredProduct
    {
        let product = PPRRegisteredProduct(ctn: ctn!, sector: sector, catalog: catalog)
        product.purchaseDate = date
        product.serialNumber = serialNum
        product.error = error
        product.endWarrantyDate = endWarrenty
        product.userUuid = uuid
        product.registeredLocale = locale
        product.emailStatus = emailStatus
        return product
    }
    
}
