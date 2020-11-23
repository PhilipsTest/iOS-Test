/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPHttpInterfaceTests: XCTestCase {

    class TestHttpConnection : HttpConnection {
        var methodName: String? = "test"

        override func performRequestAsynchronously (_ url: String,
                                                    method: String,
                                                    httpHeaders: [String: String]?,
                                                    bodyParameters: [String: String]?,
                                                    success: @escaping ([String: AnyObject]) -> (),
                                                    failure: @escaping (NSError) -> ()) {
            
            methodName = method
            
        }
    }
    
    let url = ""
    let httpHeaders = ["": ""]
    let bodyParameters = ["" : ""]
    
    let http = TestHttpConnection()
    
    func testPerformGetRequest() {
        let httpInterface = IAPHttpConnectionInterface(request: url,
                                                       httpHeaders: httpHeaders,
                                                       bodyParameters: bodyParameters,
                                                       success: { (inDict: [String: AnyObject]) -> () in },
                                                       failure: { (inError: NSError) -> () in
                                                        print("error in get request")

        })

        httpInterface.setHttpConnection(http)
        httpInterface.performGetRequest()
        XCTAssertTrue(http.methodName! == "GET")
    }
    
    func testPerformOAuthRequest() {
        
        let httpInterface = IAPHttpConnectionInterface(request: url,
                                                       httpHeaders: httpHeaders,
                                                       bodyParameters: bodyParameters,
                                                       success: { (inDict: [String: AnyObject]) -> () in },
                                                       failure: { (inError: NSError) -> () in
                                                        print("error in OAuth request") })
        httpInterface.setHttpConnection(http)
        httpInterface.performOAuthRequest()
        XCTAssertTrue(http.methodName! == "POST")
    }
    
    func testPerformPutRequest() {
        let httpInterface = IAPHttpConnectionInterface(request: url,
                                                       httpHeaders: httpHeaders,
                                                       bodyParameters: bodyParameters,
                                                       success: { (inDict: [String: AnyObject]) -> () in },
                                                       failure: { (inError: NSError) -> () in
                                                        print("error in put request") })
        httpInterface.setHttpConnection(http)
        httpInterface.performPutRequest()
        XCTAssertTrue(http.methodName! == "PUT")
    }

    func testPerformPostRequest() {
        let httpInterface = IAPHttpConnectionInterface(request: url,
                                                       httpHeaders: httpHeaders,
                                                       bodyParameters: bodyParameters,
                                                       success: { (inDict: [String: AnyObject]) -> () in },
                                                       failure: { (inError: NSError) -> () in
                                                        print("error in post request") })
        
        httpInterface.setHttpConnection(http)
        httpInterface.performPostRequest()
        XCTAssertTrue(http.methodName! == "POST")
    }

    func testPerformDeleteRequest() {
        let httpInterface = IAPHttpConnectionInterface(request: url,
                                                       httpHeaders: httpHeaders,
                                                       bodyParameters: bodyParameters,
                                                       success: { (inDict: [String: AnyObject]) -> () in },
                                                       failure: { (inError: NSError) -> () in
                                                        print("error in delete request") })
        httpInterface.setHttpConnection(http)
        httpInterface.performDeleteRequest()
        XCTAssertTrue(http.methodName! == "DELETE")
    }    
}
