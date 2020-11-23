/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev
import PhilipsPRXClient

class ECSFetchPILProductAssetsMicroServicesTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        ECSUtilityMock.requestManager = nil
    }
    
    func testFetchPILProductDetailsForBothSuccess() {
        let mock = PRXRequestManagerMock()
        mock.assetResponse = getAssetResponse()
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDetailsForBothSuccess")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssert(product.productAssets?.assets?.asset?.count == 2)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testFetchPILProductDetailsForBothFailed() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "", code: 100, userInfo: [NSLocalizedDescriptionKey: "CTN not found"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDetailsForBothFailed")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"

        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssert(error?.localizedDescription == "CTN not found")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductDetailsForBothNoData() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "", code: 100, userInfo: [NSLocalizedDescriptionKey: "We have encountered technical glitch. Please try after some time"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDetailsForBothNoData")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductDetailsForOnlyAssetsNoData() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "", code: 100, userInfo: [NSLocalizedDescriptionKey: "We have encountered technical glitch. Please try after some time"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDetailsForOnlyAssetsNoData")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductDetailsForOnlyDisclaimerNoData() {
        let mock = PRXRequestManagerMock()
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDetailsForOnlyDisclaimerNoData")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductDetailsForNoAppinfra() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.appInfra = nil
        let expectation = self.expectation(description: "testFetchPILProductDetailsForNoAppinfra")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in

            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssert(error?.localizedDescription == "Please provide app infra object")

            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductDetailsForSummaryNil() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDetailsForSummaryNil")
        let ecsproduct = ECSPILProduct()
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssert(error?.localizedDescription == "Please provide the CTN")

            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductAssetsWithInvalidJson() {
        let mock = PRXRequestManagerMock()
        ECSUtilityMock.requestManager = mock
        mock.disclaimerResponse = getDisclaimerResponse()
        mock.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey:"We have encountered technical glitch. Please try after some time"])
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductAssetsWithInvalidJson")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            XCTAssertNil(product.productAssets)
            XCTAssertNotNil(product.productDisclaimers)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductDisclaimerWithInvalidJson() {
        let mock = PRXRequestManagerMock()
        ECSUtilityMock.requestManager = mock
        mock.assetResponse = getAssetResponse()
        mock.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey:"We have encountered technical glitch. Please try after some time"])
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDisclaimerWithInvalidJson")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNil(error)
            XCTAssertNotNil(product.productAssets)
            XCTAssertNil(product.productDisclaimers)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductAssetsWithInvalidErrorJson() {
        let mock = PRXRequestManagerMock()
        ECSUtilityMock.requestManager = mock
        mock.disclaimerResponse = getDisclaimerResponse()
        mock.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey:"Expected to decode"])
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductAssetsWithInvalidErrorJson")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.debugDescription.contains("Expected to decode"), true)
            XCTAssertNil(product.productAssets)
            XCTAssertNotNil(product.productDisclaimers)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductAssetsWithPartialErrorJson() {
        let mock = PRXRequestManagerMock()
        ECSUtilityMock.requestManager = mock
        mock.disclaimerResponse = getDisclaimerResponse()
        mock.error = NSError(domain: "error", code: 404, userInfo: nil)
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductAssetsWithPartialErrorJson")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 404)
            XCTAssertNil(product.productAssets)
            XCTAssertNotNil(product.productDisclaimers)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPILProductAssetWithNilAppInfra() {
        let mock = PRXRequestManagerMock()
        ECSUtilityMock.requestManager = mock
        mock.error = NSError(domain: "error", code: 404, userInfo: [NSLocalizedDescriptionKey: "We have encountered technical glitch. Please try after some time"])
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.service = nil
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductAssetWithNilAppInfra")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertEqual(ecsproduct, product)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPILProductAssetWithPRXResponseSuccessNilData() {
        let mock = PRXRequestManagerMock()
        mock.assetResponse = getDisclaimerResponse()
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductAssetWithPRXResponseSuccessNilData")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertNil(product.productAssets)
            XCTAssertNil(product.productDisclaimers)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPILProductDisclaimerWithPRXResponseSuccessNilData() {
        let mock = PRXRequestManagerMock()
        mock.disclaimerResponse = getAssetResponse()
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchPILProductDisclaimerWithPRXResponseSuccessNilData")
        let ecsproduct = ECSPILProduct()
        ecsproduct.productPRXSummary = PRXSummaryData()
        ecsproduct.productPRXSummary?.ctn = "SCF184/13"
        
        sut.fetchECSProductDetailsFor(product: ecsproduct) { (product, error) in
            XCTAssertNil(product.productAssets)
            XCTAssertNil(product.productDisclaimers)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

extension ECSFetchPILProductAssetsMicroServicesTests {
    
        func getAssetResponse() -> PRXAssetResponse {
        let asset1 = PRXAssetAsset()
        asset1.type = ECSPermittedAssetType.RTP.rawValue
        
        let asset2 = PRXAssetAsset()
        asset2.type = ECSPermittedAssetType.APP.rawValue
        
        let assets = PRXAssetAssets()
        assets.asset = [asset1, asset2]
        
        let data = PRXAssetData()
        data.assets = assets
        let response = PRXAssetResponse()
        
        response.data = data
        response.success = true
        return response
    }
    
    func getDisclaimerResponse() -> PRXDisclaimerResponse {
        
        let disclaimer1 = PRXDisclaimer()
        let disclaimer2 = PRXDisclaimer()
        let disclaimers = PRXDisclaimers()
        disclaimers.disclaimer = [disclaimer1, disclaimer2]
        
        let data = PRXDisclaimerData()
        data.disclaimers = disclaimers
        
        let response = PRXDisclaimerResponse()
        response.data = data
        response.success = true
        return response
    }
    
    func swizzleGetPRXRequestManagerMethod() {
        let originalSelector = #selector(ECSUtility.getPRXRequestManager)
        let swizzledSelector = #selector(ECSUtilityMock.getRequestManager)
        if let originalMethod = class_getClassMethod(ECSUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(ECSUtilityMock.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func deSwizzleGetPRXRequestManagerMethod() {
        let originalSelector = #selector(ECSUtility.getPRXRequestManager)
        let swizzledSelector = #selector(ECSUtilityMock.getRequestManager)
        if let originalMethod = class_getClassMethod(ECSUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(ECSUtilityMock.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
}
