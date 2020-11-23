/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import WebKit

class MockWebView: WKWebView {
    var loadedRequest: URLRequest?
    
    override func load(_ request: URLRequest) -> WKNavigation? {
        loadedRequest = request
        return nil
    }    
}
