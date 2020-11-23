//
//  PPRUserProductTests.swift
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
@testable import PhilipsProductRegistrationDev

class PPRUserProductTests: PPRBaseClassTests {

    lazy var userProduct: PPRUserWithProducts = {
        return PPRUserWithProducts()
    }()
    
   /*func testRegisterProductWithUserNotLoggedInError() {
        let product = PPRProductObject.fakeProductWith(PPRTestConstants.ctn, serialNumber: PPRTestConstants.RegistredSerialNum, purchaseDate: Date())
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        self.userProduct.user = DIUserMock.mockDIUser(with: false, accessToken: nil)
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        let expect = self.expectation(description: "Register")
        
        self.userProduct.delegate = delegateMock
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        
        waitForExpectations(timeout: 4) { error in
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
    
    func testRegisterProductWithCTNNilError() {
        let product = PPRProductObject.fakeProductWith("", serialNumber: PPRTestConstants.RegistredSerialNum, purchaseDate: Date())
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.CTN_NOT_ENTERED.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRegisterProductWithPurchasedateGreaterThanCurrentdate() {
        let product = PPRProductObject.fakeProductWith(PPRTestConstants.ctn, serialNumber: PPRTestConstants.RegistredSerialNum, purchaseDate: Date().addingTimeInterval(60))
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.INVALID_PURCHASE_DATE.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRegisterProductWithPurchasedateLessThan2000() {
        let product = PPRProductObject.fakeProductWith(PPRTestConstants.ctn, serialNumber: PPRTestConstants.RegistredSerialNum, purchaseDate: Date.init(timeIntervalSince1970: 60))
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.INVALID_PURCHASE_DATE.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }

    func testRegisterProductWithIsAlredyRegistredError() {
        let product = PPRProductObject.fakeProductWith(PPRTestConstants.RegistredCtn, serialNumber: PPRTestConstants.RegistredSerialNum, purchaseDate: Date())
        let delegateMock = PPRRegisterProductDelegateMock()
        
        let regProduct = PPRRegisteredProduct(ctn: product.ctn, sector: product.sector, catalog: product.catalog)
        regProduct.sendEmail = product.sendEmail
        regProduct.serialNumber = product.serialNumber
        regProduct.purchaseDate = product.purchaseDate
        regProduct.error = nil
        regProduct.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([regProduct])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.PRODUCT_ALREADY_REGISTERD.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRegisterProduct() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.purchaseDate = Date()
        product.serialNumber = PPRTestConstants.RegistredSerialNum
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(true, isPurchasedataReuired: true)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        
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
    }
    
    func testRegisterProductWithInvalidSerialNumberAndPurchasedateError() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(true, isPurchasedataReuired: true)
        let delegateMock = PPRRegisterProductDelegateMock()
        
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRegisterProductWithRequiredPurchasedateError() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.serialNumber = PPRTestConstants.RegistredSerialNum
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(true, isPurchasedataReuired: true)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockResponse(self.fakeEmptyResultaData())
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
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
    }
    
    func testRegisterProductWithInvalidSerialNumberError() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.purchaseDate = Date()
        product.serialNumber = "SFJFJS"
        
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(true, isPurchasedataReuired: true)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.INVALID_SERIAL_NUMBER.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRegisterProductWithRequiredFieldsFALSE() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockResponse(self.fakeProductResultData())
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
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
    }
    
    func testRegisterProductWithUnknownError() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        self.userProduct.user = DIUserMock.mockDIUser(with: true, accessToken: nil)
        let error = PPRErrorHelper().createCustomError(domain: "Error",code: 1000,userInfo: [:])
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockError(error)
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == PPRError.PRODUCT_ALREADY_REGISTERD.rawValue || delegateMock.product?.error?.code == PPRError.UNKNOWN.rawValue else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRegisterProductWithAccessTokenError() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        let userD = UserDataInterfaceMock()
        userD.isAccessTokenRefreshed = true
        self.userProduct.user = userD
        let error = PPRErrorHelper().createCustomError(domain: "Error",code: 403,userInfo: [:])
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockError(error)
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == 403 else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRegisterProductWithRefreshFail() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let delegateMock = PPRRegisterProductDelegateMock()
        
        product.requestManager.requestManager = PRXRequestManagerMock.mockMetadataResponse(false, isPurchasedataReuired: false)
        let userD = UserDataInterfaceMock()
        userD.isAccessTokenRefreshed = false
        self.userProduct.user = userD
        let error = PPRErrorHelper().createCustomError(domain: "Error",code: 403,userInfo: [:])
        self.userProduct.requestManager.requestManager = PRXRequestManagerMock.mockError(error)
        self.userProduct.productStore = PPRRegisteredProductListStoreMock.mockListStoreWith([])
        self.userProduct.delegate = delegateMock
        
        let expect = self.expectation(description: "Register")
        delegateMock.asyncExpectation = expect
        self.userProduct.registerProduct(product)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard delegateMock.product?.error?.code == 403 else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func fakeEmptyResultaData() -> PRXProductListResponse {
        return PRXProductListResponse(withDictonary: [:])!
    }
    
    func fakeProductResultData() -> PRXProductListResponse {
        let dict = PPRRegisteredProductListJSONObject().fakeRegisteredProductList()
        return PRXProductListResponse(withDictonary: dict)!
    }*/
    
}
