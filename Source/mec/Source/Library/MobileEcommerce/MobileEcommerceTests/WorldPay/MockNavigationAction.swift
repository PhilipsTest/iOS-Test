/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import WebKit

class MockNavigationAction: WKNavigationAction {
    
    var testRequest: URLRequest
    
    init(testRequest: URLRequest) {
        self.testRequest = testRequest
        super.init()
    }
    
    override var request: URLRequest {
        return testRequest
    }
}
