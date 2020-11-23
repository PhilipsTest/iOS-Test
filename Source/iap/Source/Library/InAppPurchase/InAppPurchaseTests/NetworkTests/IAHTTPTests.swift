/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAHTTPTests: XCTestCase {
    
    fileprivate func provideRequest() -> HttpRequest {
        let aUrl:String = "https://www.youtube.com"
        let headerDict = ["hkey":"hvalue"]
        let bodyDict = ["bkey":"bvalue"]
        let httpRequest:HttpRequest = HttpRequest.init(httMethod: "post", url:aUrl, httpHeaders: headerDict, bodyParameters: bodyDict)
        return httpRequest;
    }
    
    func testURLRequestMethod() {
        let httpRequest:HttpRequest = self.provideRequest()
        let httpResponse =  httpRequest.urlRequest()
        XCTAssert(httpResponse is NSMutableURLRequest)
        let fields: [String: String] = httpResponse.allHTTPHeaderFields!
        XCTAssert(fields["hkey"] == "hvalue")
        XCTAssert(httpResponse.timeoutInterval == HTTPTIMEOUT)
    }
    
    func testBodyContent() {
        let httpRequest:HttpRequest = self.provideRequest()
        let httpResponse =  httpRequest.urlRequest()
        XCTAssert(httpResponse is NSMutableURLRequest)
        
        let bodyDict = ["b1key":"b1value","b2key":"b2value","b3key":"b3value"]
        httpResponse.setBodyContent(bodyDict)
        XCTAssertNotNil(httpResponse.httpBody, "Body is not set right")
        
        XCTAssertNotNil(HTTPResponse(), "Response created is nil")
    }
    
    
//    func testHTTPClassrequestMethod() {
//        stub(isHost("https://www.youtube.com"), response: { _ in OHHTTPStubsResponse.init()})
//        let httpRequest = self.provideRequest()
//        
//        let httpConnection = HTTP.init()
//        let response:AnyObject = httpConnection.request(httpRequest)
//        XCTAssert(response.isKindOfClass(OHHTTPStubsResponse))
//    }

}
