//
//  AICloudLoggerRestClientTest.swift
//  AppInfraTests
//
//  Created by Philips on 5/22/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import XCTest
@testable import AppInfra

class AIRESTClientInterface {
    private func serviceURL(withServiceID serviceID: String?, preference: AIRESTServiceIDPreference, pathComponent: String?, completion completionHandler: @escaping (_ serviceURL: String?, _ error: Error?) -> Void) {
    }
}

class AIRESTServiceIDTests: XCTestCase {
    var restClient: AIRESTClientInterface?
}

class AICloudLoggerRestClientTest: XCTestCase {
    var appInfra: AIAppInfra!
    var objCloudRestBag: CloudRestClientMock!
    private var consentExpectation: XCTestExpectation!

    class func sharedAppInfra() -> Any? {
        var time: Int = 0
        var _sharedObject: AIAppInfra? = nil
        if (time == 0) {
            _sharedObject = AIAppInfra.build(nil)
        }
        time = 1
        return _sharedObject
    }
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        self.appInfra = AICloudLoggerRestClientTest.sharedAppInfra() as! AIAppInfra
        self.objCloudRestBag = CloudRestClientMock(appinfra: self.appInfra, sharedKey: "asdasd", secretKey: "sadasda")
    }
    
    override func tearDown() {
    	Bundle.deSwizzele()
        super.tearDown()
    }
       
    func testCloudRestClientForNil() {
        let cloudRestClient = AICloudLoggerRestClient(appinfra: self.appInfra, sharedKey: "asdasd", secretKey: "sadasdas")
        XCTAssertNotNil(self.objCloudRestBag)
        XCTAssertNotNil(cloudRestClient)
    }
    
    func testUploadClientToReturnSuccess() {
        consentExpectation = expectation(description: "Upload log function return success")
        let str = "test string"
        let data = NSKeyedArchiver.archivedData(withRootObject: str)
        
        objCloudRestBag.uploadLog(logData: data, success: {[weak self] in
            self?.consentExpectation.fulfill()
        }) { (shouldRetry,error) in
            
        }
        waitForExpectations(timeout: 10)
    }
    
}
