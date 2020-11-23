/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import BVSDK
@testable import MobileEcommerceDev

class MECBazaarVoiceHandlerTests: XCTestCase {
    
    var mockBazaarVoiceHandler: BazaarVoiceHandler!
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        mockBazaarVoiceHandler = BazaarVoiceHandler()
        
        let appinfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = appinfra
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }

    override func tearDown() {
        super.tearDown()
        mockBazaarVoiceHandler = nil
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testBazaarVoiceBulkReviewsRequest() {
        swizzleBulkReviewsRequestLoadSuccessMethod()
        let expectation = self.expectation(description: "testBazaarVoiceBulkReviewsRequest")
        mockBazaarVoiceHandler.fetchBulkRatingsFor(productCTNs: ["FirstCTN/First"]) { (stats) in
            XCTAssertEqual(stats?.count, 3)
            XCTAssertEqual(stats?.contains(where: {
                if let productID = $0.productId { return productID.contains("_") }
                return false
            }), false)
            let product = stats?.first(where: { $0.productId == "FirstCTN/First" })
            let productRating = product?.reviewStatistics
            XCTAssertNotNil(product)
            XCTAssertEqual(product?.productId, "FirstCTN/First")
            XCTAssertEqual(productRating?.totalReviewCount, 200)
            XCTAssertEqual(productRating?.averageOverallRating, 3.9)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        deSwizzleBulkReviewsRequestLoadSuccessMethod()
    }
    
    func testBazaarVoiceBulkReviewsRequestError() {
        swizzleBulkReviewsRequestLoadFailureMethod()
        let expectation = self.expectation(description: "testBazaarVoiceBulkReviewsRequest")
        mockBazaarVoiceHandler.fetchBulkRatingsFor(productCTNs: ["FirstCTN/First"]) { (stats) in
            XCTAssertNil(stats)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchBulkRatingsForCTNList:bazaarVoice:The operation couldn’t be completed. ( error 123.):123")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        deSwizzleBulkReviewsRequestLoadFailureMethod()
    }
    
    func testBazaarVoiceFetchAllReviewsSuccess() {
        swizzleFetchAllReviewsRequestLoadSuccessMethod()
        let expectation = self.expectation(description: "testBazaarVoiceFetchAllReviewsSuccess")
        mockBazaarVoiceHandler.fetchAllReviewsFor(productCTN: "SecondCTN/Second", offset: 0) { (reviews, errors) in
            XCTAssertNil(errors)
            XCTAssertEqual(reviews?.count, 3)
            let review = reviews?.first(where: { $0.productId == "SecondCTN/Second" })
            XCTAssertNotNil(review)
            XCTAssertEqual(review?.userNickname, "SecondTestNickname")
            XCTAssertEqual(review?.productId, "SecondCTN/Second")
            XCTAssertEqual(review?.reviewText, "SecondTestReviewText")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        deSwizzleFetchAllReviewsRequestLoadSuccessMethod()
    }
    
    func testBazaarVoiceFetchAllReviewsFailure() {
        swizzleFetchAllReviewsRequestLoadFailureMethod()
        let expectation = self.expectation(description: "testBazaarVoiceFetchAllReviewsFailure")
        mockBazaarVoiceHandler.fetchAllReviewsFor(productCTN: "SecondCTN/Second", offset: 0) { (reviews, errors) in
            XCTAssertNotNil(errors)
            XCTAssertNil(reviews)
            XCTAssertEqual(errors?.count, 2)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchAllReviewsForCTN:bazaarVoice:The operation couldn’t be completed. ( error 123.):123")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        deSwizzleFetchAllReviewsRequestLoadFailureMethod()
    }
    
    func testBazaarVoiceConfigureForProduction() {
        swizzleBazaarVoiceConfigureMethod()
        mockBazaarVoiceHandler.configureBazaarVoice(bazaarVoiceEnvironment: .production)
        XCTAssertEqual(MockBVSDKManager.mockConfigType, BVConfigurationType.prod)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict.count, 2)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["clientId"], "philipsglobal")
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["apiKeyConversations"], "caAyWvBUz6K3xq4SXedraFDzuFoVK71xMplaDk1oO5P4E")
        deSwizzleBazaarVoiceConfigureMethod()
    }
    
    func testBazaarVoiceConfigureForStaging() {
        swizzleBazaarVoiceConfigureMethod()
        mockBazaarVoiceHandler.configureBazaarVoice(bazaarVoiceEnvironment: .staging)
        XCTAssertEqual(MockBVSDKManager.mockConfigType, BVConfigurationType.staging)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict.count, 2)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["clientId"], "philipsglobal")
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["apiKeyConversations"], "ca23LB5V0eOKLe0cX6kPTz6LpAEJ7SGnZHe21XiWJcshc")
        deSwizzleBazaarVoiceConfigureMethod()
    }
    
    func testBazaarVoiceConfigureDefault() {
        swizzleBazaarVoiceConfigureMethod()
        mockBazaarVoiceHandler.configureBazaarVoice(bazaarVoiceEnvironment: nil)
        XCTAssertEqual(MockBVSDKManager.mockConfigType, BVConfigurationType.staging)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict.count, 2)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["clientId"], "philipsglobal")
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["apiKeyConversations"], "ca23LB5V0eOKLe0cX6kPTz6LpAEJ7SGnZHe21XiWJcshc")
        deSwizzleBazaarVoiceConfigureMethod()
    }
    
    func testBazaarVoiceConfigureWithCustomValues() {
        swizzleBazaarVoiceConfigureMethod()
        MECConfiguration.shared.bazaarVoiceClientID = "TestClientID"
        MECConfiguration.shared.bazaarVoiceConversationAPIKey = "TestConversationAPIKey"
        mockBazaarVoiceHandler.configureBazaarVoice(bazaarVoiceEnvironment: .production)
        XCTAssertEqual(MockBVSDKManager.mockConfigType, BVConfigurationType.prod)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict.count, 2)
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["clientId"], "TestClientID")
        XCTAssertEqual(MockBVSDKManager.mockConfigDict["apiKeyConversations"], "TestConversationAPIKey")
        deSwizzleBazaarVoiceConfigureMethod()
    }
}

extension MECBazaarVoiceHandlerTests {
    
    func swizzleBulkReviewsRequestLoadSuccessMethod() {
        let originalSelector = #selector(BVBulkRatingsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVBulkRatingsRequest.mockBulkReviewLoadSuccess)
        if let originalMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func swizzleBulkReviewsRequestLoadFailureMethod() {
        let originalSelector = #selector(BVBulkRatingsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVBulkRatingsRequest.mockBulkReviewLoadFailure)
        if let originalMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func swizzleFetchAllReviewsRequestLoadSuccessMethod() {
        let originalSelector = #selector(BVReviewsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVReviewsRequest.mockFetchAllReviewsLoadSuccess)
        if let originalMethod = class_getInstanceMethod(BVReviewsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVReviewsRequest.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func swizzleFetchAllReviewsRequestLoadFailureMethod() {
        let originalSelector = #selector(BVReviewsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVReviewsRequest.mockFetchAllReviewsLoadFailure)
        if let originalMethod = class_getInstanceMethod(BVReviewsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVReviewsRequest.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func swizzleBazaarVoiceConfigureMethod() {
        let originalSelector = #selector(BVSDKManager.configure(withConfiguration:configType:))
        let swizzledSelector = #selector(MockBVSDKManager.configureWithConfiguration(configDict:configType:))
        if let originalMethod = class_getClassMethod(BVSDKManager.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(MockBVSDKManager.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func deSwizzleBulkReviewsRequestLoadSuccessMethod() {
        let originalSelector = #selector(BVBulkRatingsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVBulkRatingsRequest.mockBulkReviewLoadSuccess)
        if let originalMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
    
    func deSwizzleBulkReviewsRequestLoadFailureMethod() {
        let originalSelector = #selector(BVBulkRatingsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVBulkRatingsRequest.mockBulkReviewLoadFailure)
        if let originalMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVBulkRatingsRequest.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
    
    func deSwizzleFetchAllReviewsRequestLoadSuccessMethod() {
        let originalSelector = #selector(BVReviewsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVReviewsRequest.mockFetchAllReviewsLoadSuccess)
        if let originalMethod = class_getInstanceMethod(BVReviewsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVReviewsRequest.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
    
    func deSwizzleFetchAllReviewsRequestLoadFailureMethod() {
        let originalSelector = #selector(BVReviewsRequest.load(_:failure:))
        let swizzledSelector = #selector(BVReviewsRequest.mockFetchAllReviewsLoadFailure)
        if let originalMethod = class_getInstanceMethod(BVReviewsRequest.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(BVReviewsRequest.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
    
    func deSwizzleBazaarVoiceConfigureMethod() {
        let originalSelector = #selector(BVSDKManager.configure(withConfiguration:configType:))
        let swizzledSelector = #selector(MockBVSDKManager.configureWithConfiguration(configDict:configType:))
        if let originalMethod = class_getClassMethod(BVSDKManager.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(MockBVSDKManager.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
}

extension BVBulkRatingsRequest {
    
    @objc func mockBulkReviewLoadSuccess(success: @escaping (BVBulkRatingsResponse) -> Void,
                                  failure: @escaping ConversationsFailureHandler) {
        let firstBulkReviewStatistics = BVProductStatistics()
        let firstReviewStatistics = BVReviewStatistic()
        firstReviewStatistics.averageOverallRating = 3.9
        firstReviewStatistics.totalReviewCount = 200
        firstBulkReviewStatistics.reviewStatistics = firstReviewStatistics
        firstBulkReviewStatistics.productId = "FirstCTN_First"
        
        let secondBulkReviewStatistics = BVProductStatistics()
        let secondReviewStatistics = BVReviewStatistic()
        secondReviewStatistics.averageOverallRating = 4.2
        secondReviewStatistics.totalReviewCount = 100
        secondBulkReviewStatistics.reviewStatistics = secondReviewStatistics
        secondBulkReviewStatistics.productId = "SecondCTN_Second"
        
        let thirdBulkReviewStatistics = BVProductStatistics()
        let thirdReviewStatistics = BVReviewStatistic()
        thirdReviewStatistics.averageOverallRating = 4.2
        thirdReviewStatistics.totalReviewCount = 100
        thirdBulkReviewStatistics.reviewStatistics = thirdReviewStatistics
        thirdBulkReviewStatistics.productId = "ThirdCTN_Third"
        
        let response = BVBulkRatingsResponse()
        response.results = [firstBulkReviewStatistics, secondBulkReviewStatistics, thirdBulkReviewStatistics]
        success(response)
    }
    
    @objc func mockBulkReviewLoadFailure(success: @escaping (BVBulkRatingsResponse) -> Void,
                                  failure: @escaping ConversationsFailureHandler) {
        let error = NSError(domain: "", code: 123, userInfo: nil)
        failure([error])
    }
}

extension BVReviewsRequest {
    
    @objc func mockFetchAllReviewsLoadSuccess(_ success: @escaping (BVDisplayResultsResponse<BVGenericConversationsResult>) -> Void, failure: @escaping ConversationsFailureHandler) {
        let response = BVDisplayResultsResponse()
        let firstReview = BVReview()
        firstReview.userNickname = "FirstTestNickname"
        firstReview.productId = "FirstCTN/First"
        firstReview.reviewText = "FirstTestReviewText"
        
        let secondReview = BVReview()
        secondReview.userNickname = "SecondTestNickname"
        secondReview.productId = "SecondCTN/Second"
        secondReview.reviewText = "SecondTestReviewText"
        
        let thirdReview = BVReview()
        thirdReview.userNickname = "ThirdTestNickname"
        thirdReview.productId = "ThirdCTN/Third"
        thirdReview.reviewText = "ThirdTestReviewText"
        
        response.results = [firstReview, secondReview, thirdReview]
        
        success(response)
    }
    
    @objc func mockFetchAllReviewsLoadFailure(_ success: @escaping (BVDisplayResultsResponse<BVGenericConversationsResult>) -> Void, failure: @escaping ConversationsFailureHandler) {
        let firstError = NSError(domain: "", code: 123, userInfo: nil)
        let secondError = NSError(domain: "", code: 345, userInfo: nil)
        failure([firstError, secondError])
    }
}

class MockBVSDKManager: NSObject {
    
    static var mockConfigDict: [String: String] = [:]
    static var mockConfigType: BVConfigurationType!
    
    @objc func configureWithConfiguration(configDict: [String: String], configType: BVConfigurationType) {
        MockBVSDKManager.mockConfigDict = configDict
        MockBVSDKManager.mockConfigType = configType
    }
}
