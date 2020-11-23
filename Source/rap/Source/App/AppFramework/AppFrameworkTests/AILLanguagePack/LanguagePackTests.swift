/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import PlatformInterfaces

@testable import AppFramework

class LanguagePack: NSObject,AILanguagePackProtocol {
    public var status:AILPRefreshStatus
    public var activateStatus:AILPActivateStatus
    public var error:Error?
    public var localization = "test"
    public var activateCalledMessage = "Test"
    override init() {
        self.status = .refreshFailed
        self.activateStatus = .failed
        super.init()
    }
    
    func refresh(_ completionHandler: ((AILPRefreshStatus, Error?) -> Void)? = nil) {
        if let error = error {
            completionHandler?(.refreshFailed, error)
        }
        else {
            completionHandler?(status, nil)
        }
    }
    
    func activate(_ completionHandler: ((AILPActivateStatus, Error?) -> Void)? = nil) {
        activateCalledMessage = "languagepack updateActivated"
        if let error = error {
            completionHandler?(.failed, error)
        }
        else {
            completionHandler?(activateStatus, nil)
        }
    }
    
    func localizedString(forKey key: String) -> String? {
        return localization
    }
}

class Logging: NSObject, AILoggingProtocol {
    
    func getCloudLoggingConsentIdentifier() -> String! {
        return "sdasdasdasd"
    }
    
    var userUUID: String = "test user"
    
    var logSuccess = false
    var expectedLevel:AILogLevel?
    var expectedEventId:String?
    var expectedMessage:String?
    
    func createInstance(forComponent componentId: String!, componentVersion: String!) -> AILoggingProtocol! {
        return Logging()
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!) {
        if level == expectedLevel && eventId == expectedEventId && message == expectedMessage {
            logSuccess = true
        }
        else{
            print("expected log is not happened => [\(expectedMessage!)]")
        }
    }
    
    func setExpectation(level: AILogLevel, eventId: String!, message: String!) {
        self.expectedMessage = message
        self.expectedEventId = eventId
        self.expectedLevel = level
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!, dictionary: [AnyHashable : Any]!) {
        
    }
}

class LanguagePackTests: XCTestCase {
    var languagePack = LanguagePack()
    override func setUp() {
        super.setUp()
        AppInfraSharedInstance.sharedInstance.appInfraHandler = AIAppInfra.build({ (builder) in
            builder?.languagePack = self.languagePack
        })
    }
    
    func testIntializationFail() {
        let logging = Logging()
        let message = "expected error for failure"
        let eventId = "AFLanguagePack"
        let level = AILogLevel.error
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework = logging
        logging.setExpectation(level: level, eventId: eventId, message: message)
        languagePack.status = .refreshFailed
        let expectedError = NSError(domain: "lptest", code: 111, userInfo: [NSLocalizedDescriptionKey : message])
        languagePack.error = expectedError
        AppInfraSharedInstance.sharedInstance.initializeLanguagePack()
        XCTAssertTrue(logging.logSuccess)
    }
        
    func testClickStreamHandlerIdentifier()
    {
        let loggingMock = Logging()
        
        XCTAssertNotNil(loggingMock.getCloudLoggingConsentIdentifier());
    }
    
    func testIntializationPass() {
        let logging = Logging()
        let message = "languagepack updateActivated"
        let eventId = "AFLanguagePack"
        let level = AILogLevel.info
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework = logging
        logging.setExpectation(level: level, eventId: eventId, message: message)
        languagePack.error = nil
        languagePack.activateStatus = .updateActivated
        AppInfraSharedInstance.sharedInstance.initializeLanguagePack()
        XCTAssertTrue(logging.logSuccess)
    }
}
