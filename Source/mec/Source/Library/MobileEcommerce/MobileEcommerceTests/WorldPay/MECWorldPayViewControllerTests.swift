/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import WebKit
@testable import MobileEcommerceDev

class MECWorldPayViewControllerTests: XCTestCase {

    var sut: MECWorldPayViewController!
    var mockTagging = MECMockTagger()
    var appInfra = MockAppInfra()
    var mockNavigationController: MockNavigationController!
    override func setUp() {
        super.setUp()
        sut = MECWorldPayViewController()
        MECConfiguration.shared.sharedAppInfra = appInfra
        MECConfiguration.shared.mecTagging = mockTagging
    }

    override func tearDown() {
        super.tearDown()
        MECConfiguration.shared.mecTagging = nil
        MECConfiguration.shared.sharedAppInfra = nil
        MECConfiguration.shared.orderFlowCompletionDelegate = nil
    }

    func testViewDidLoadLoadURLCheck() {
        sut.worldPayURL = "www.test.com"
        _ = sut.view
        let mockWebView = MockWebView()
        sut.wpWebView = mockWebView
        sut.viewDidLoad()
        XCTAssertEqual(mockWebView.loadedRequest?.url?.absoluteString, "www.test.com&successURL=https://www.philips.com/paymentsuccess&failureURL=https://www.philips.com/paymentfailure&pendingURL=https://www.philips.com/paymentpending&cancelURL=https://www.philips.com/paymentcancel")
    }

    func testDecidePolicyForNavigationActionNoURL() {
        let mockWebView = MockWebView()
        var request = URLRequest(url: URL(string: "www.test.comn")!)
        request.url = nil
        let navAction = MockNavigationAction(testRequest: request)
    
        sut.webView(mockWebView, decidePolicyFor: navAction) { (policy) in
            XCTAssertEqual(policy, WKNavigationActionPolicy.cancel)
        }
    }
    
    func testDecidePolicyForNavigationActionWorldPayURL() {
        let mockWebView = MockWebView()
        sut.worldPayURL = "www.test.com"
        let navAction = MockNavigationAction(testRequest: URLRequest(url: URL(string: "www.test.comn")!))
    
        sut.webView(mockWebView, decidePolicyFor: navAction) { (policy) in
            XCTAssertEqual(policy, WKNavigationActionPolicy.allow)
        }
    }
    
    func testDecidePolicyForNavigationActionSuccess() {
        sut.worldPayURL = "www.test.com"
        mockNavigationController = MockNavigationController(rootViewController: sut)
        mockNavigationController.viewControllers = [sut]
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = sut.view
        
        let mockWebView = MockWebView()
        
        let navAction = MockNavigationAction(testRequest: URLRequest(url: URL(string: "https://www.philips.com/paymentsuccess")!))
        
        sut.webView(mockWebView, decidePolicyFor: navAction) { (policy) in
            XCTAssertNotNil(self.mockNavigationController.pushedViewController as? MECPaymentConfirmationViewController)
            XCTAssertEqual((self.mockNavigationController.pushedViewController as? MECPaymentConfirmationViewController)?.paymentStatus, MECPaymentStates.paymentSuccess)
            XCTAssertEqual(policy, WKNavigationActionPolicy.cancel)
        }
    }
    
    func testDecidePolicyForNavigationActionPaymentPending() {
        sut.worldPayURL = "www.test.com"
        mockNavigationController = MockNavigationController(rootViewController: sut)
        mockNavigationController.viewControllers = [sut]
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = sut.view
        
        let mockWebView = MockWebView()
        
        let navAction = MockNavigationAction(testRequest: URLRequest(url: URL(string: "https://www.philips.com/paymentpending")!))
        
        sut.webView(mockWebView, decidePolicyFor: navAction) { (policy) in

            XCTAssertNotNil(self.mockNavigationController.pushedViewController as? MECPaymentConfirmationViewController)
            XCTAssertEqual((self.mockNavigationController.pushedViewController as? MECPaymentConfirmationViewController)?.paymentStatus, MECPaymentStates.paymentPending)
            XCTAssertEqual(policy, WKNavigationActionPolicy.cancel)
        }
    }
    
    func testDecidePolicyForNavigationActionFailure() {
        sut.worldPayURL = "www.test.com"
        mockNavigationController = MockNavigationController(rootViewController: sut)
        mockNavigationController.viewControllers = [sut]
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = sut.view
        
        let mockWebView = MockWebView()
        
        let navAction = MockNavigationAction(testRequest: URLRequest(url: URL(string: "https://www.philips.com/paymentfailure")!))
        
        sut.webView(mockWebView, decidePolicyFor: navAction) { (policy) in
            XCTAssertEqual(policy, WKNavigationActionPolicy.cancel)
            XCTAssertEqual((self.mockTagging.inParamDict?[MECAnalyticsConstants.paymentType] as? String), MECAnalyticsConstants.paymentTypeNew)
            XCTAssertEqual((self.mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), MECAnalyticsConstants.paymentFailure)
        }
    }
    
    func testDecidePolicyForNavigationActionCancel() {
        let completionDelegate = FlowCompletionDelegate()
        MECConfiguration.shared.orderFlowCompletionDelegate = completionDelegate
        
        sut.worldPayURL = "www.test.com"
        mockNavigationController = MockNavigationController(rootViewController: sut)
        mockNavigationController.viewControllers = [sut]
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = sut.view
        
        let mockWebView = MockWebView()
        let navAction = MockNavigationAction(testRequest: URLRequest(url: URL(string: "https://www.philips.com/paymentcancel")!))
        
        sut.webView(mockWebView, decidePolicyFor: navAction) { (policy) in
            XCTAssertEqual(policy, WKNavigationActionPolicy.cancel)
            XCTAssertEqual((self.mockTagging.inParamDict?[MECAnalyticsConstants.paymentType] as? String), MECAnalyticsConstants.paymentTypeNew)
            XCTAssertEqual((self.mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), MECAnalyticsConstants.cancelPayment)
            XCTAssertTrue(completionDelegate.didCancelOrderCalled)
        }
    }
    
    func testfinishMECFlowSuccess() {
        let completionDelegate = FlowCompletionDelegate()
        MECConfiguration.shared.orderFlowCompletionDelegate = completionDelegate
        sut.finishMECFlow()
        XCTAssertTrue(completionDelegate.didPlaceOrderCalled)
    }
    
    func testfinishMECFlowSuccessDelegateNil() {
        sut.worldPayURL = "www.test.com"
        mockNavigationController = MockNavigationController(rootViewController: sut)
        mockNavigationController.viewControllers = [sut]
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = sut.view
        
        sut.finishMECFlow()
        
        XCTAssertNotNil(mockNavigationController.viewControllersList?.first as? MECProductCatalogueViewController)
    }
    
    func testTrackPage() {
        sut.worldPayURL = "www.test.com"
        _ = sut.view
        sut.viewWillAppear(true)
        XCTAssertEqual(mockTagging.inPageName, MECAnalyticPageNames.paymentPage)
    }

}
