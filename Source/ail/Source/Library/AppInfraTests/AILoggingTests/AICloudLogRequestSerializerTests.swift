//
//  AICloudLogRequestSerializerTests.swift
//  AppInfraTests
//
//  Created by Hashim MH on 31/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import XCTest
@testable import AppInfra

class AICloudLogRequestSerializerTests: XCTestCase {

    func testNilDataForNoLogs() {
        let serializer = AppInfra.AICLoudLogRequestSerializer(productKey:"gdhd")
        XCTAssertNil(serializer.postData(logs: []))
    }

    func testNilDataForNilProductKey() {
        let serializer = AppInfra.AICLoudLogRequestSerializer(productKey:nil)
        let log = AILog(context: AILogCoreDataStack.shared.managedObjectContext!)
        XCTAssertNil(serializer.postData(logs: [log]))
        serializer.productKey = "somekey"
        XCTAssertNotNil(serializer.postData(logs: [log]))
    }

    func testLogDateFormatterCreation() {
        let logDateFormatter = AppInfra.LogDateFormatter()
        XCTAssertNotNil(logDateFormatter, "LogDateFormatter object returned is nil")
        let locale = Locale(identifier: "en_US_POSIX")
        let timeZone = TimeZone(abbreviation: "UTC")
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        XCTAssertEqual(logDateFormatter.locale, locale, "Locale values are not matching")
        XCTAssertEqual(logDateFormatter.timeZone, timeZone, "Timezone values are not matching")
        XCTAssertEqual(logDateFormatter.dateFormat, dateFormat, "Dateformat values are not matching")
    }
    
    func testEntryModelCreation() {
        let testLog = AILog(context: AILogCoreDataStack.shared.managedObjectContext!)
        let entryModel = AppInfra.Entry(log: testLog)
        XCTAssertNotNil(entryModel, "Entry struct object returned is nil")
    }
    
    func testLogDataModelCreation() {
        let testLog = AILog(context: AILogCoreDataStack.shared.managedObjectContext!)
        let testLogData = AppInfra.LogData(log: testLog)
        XCTAssertNotNil(testLogData, "LogData struct object returned is nil")
    }
    
    func testResourceModelCreation() {
        let testLog = AILog(context: AILogCoreDataStack.shared.managedObjectContext!)
        testLog.appsId = "testId"
        testLog.appState = "STAGING"
        testLog.appVersion = "1.0.0"
        testLog.component = "AppInfra"
        testLog.details = "details"
        testLog.eventID = "12345"
        testLog.homeCountry = "IN"
        testLog.locale = "en_IN"
        testLog.localTime = NSDate()
        testLog.logTime = NSDate()
        testLog.logDescription = "dummyDescription"
        testLog.logID = "123"
        testLog.networkType = "testNetwork"
        testLog.serverName = "testServer"
        testLog.severity = "testSeverity"
        testLog.transactionID = "123"
        testLog.userUUID = "123321"
        testLog.status = "testStatus"
        
        let testResourceObject = AppInfra.Resource(log: testLog)
        XCTAssertNotNil(testResourceObject, "Resource struct object returned is nil")
        XCTAssertEqual(testResourceObject.id, testLog.logID)
        XCTAssertEqual(testResourceObject.serverName, testLog.serverName)
        XCTAssertEqual(testResourceObject.eventId, testLog.eventID)
        XCTAssertEqual(testResourceObject.severity, testLog.severity)
        XCTAssertEqual(testResourceObject.applicationInstance, testLog.appsId)
        XCTAssertEqual(testResourceObject.component, testLog.component)
        XCTAssertNotNil(testResourceObject.logTime)
        XCTAssertEqual(testResourceObject.originatingUser, testLog.userUUID)
        XCTAssertEqual(testResourceObject.applicationVersion, testLog.appVersion)
        XCTAssertEqual(testResourceObject.transactionId, testLog.logID)
    }
    
    func testLogMessageModelCreation() {
        let testLog = AILog(context: AILogCoreDataStack.shared.managedObjectContext!)
        testLog.appState = "STAGING"
        testLog.homeCountry = "IN"
        testLog.locale = "en_IN"
        testLog.localTime = NSDate()
        testLog.logDescription = "dummyDescription"
        testLog.details = "testDetails"
        testLog.networkType = "testNetwork"
        
        let testLogMessage = AppInfra.LogMessage(log: testLog)
        XCTAssertNotNil(testLogMessage.devicetype, "Device type is nil")
        XCTAssertNotNil(testLogMessage.stringValue, "Logmessage stringValue is nil")
        XCTAssertNotNil(testLogMessage.base64, "Logmessage base64 is nil")
        XCTAssertEqual(testLogMessage.appstate, testLog.appState)
        XCTAssertEqual(testLogMessage.locale, testLog.locale)
        XCTAssertEqual(testLogMessage.homecountry, testLog.homeCountry)
        XCTAssertNotNil(testLogMessage.localtime, "Logmessage localTime is nil")
        XCTAssertEqual(testLogMessage.networktype, testLog.networkType)
        XCTAssertEqual(testLogMessage.description, testLog.logDescription)
        XCTAssertEqual(testLogMessage.details, testLog.details)
    }
    
    func testLogModelCreation() {
        let testLog1 = AILog(context: AILogCoreDataStack.shared.managedObjectContext!)
        testLog1.appsId = "1"
        testLog1.logDescription = "log description 1"
        let entryModel1 = AppInfra.Entry(log: testLog1)
        
        let testLog2 = AILog(context: AILogCoreDataStack.shared.managedObjectContext!)
        testLog2.appsId = "2"
        testLog2.logDescription = "log description 2"
        let entryModel2 = AppInfra.Entry(log: testLog2)
        
        let entryList = [entryModel1, entryModel2]
        let productKey = "123"
        let testLogModel = AppInfra.LogModel(entry: entryList, productKey: productKey)
        XCTAssertNotNil(testLogModel, "LogModel struct returned is nil")
        XCTAssertEqual(testLogModel.total, entryList.count, "Total number of entries are not matching")
        XCTAssertEqual(testLogModel.productKey, productKey, "Product key is not matching")
        
        let debugDescription = "productKey:123 \nresourceType:bundle \ntype:transaction \ntotal:\(entryList.count) \nentry:\(entryList)"
        XCTAssertEqual(testLogModel.debugDescription, debugDescription, "Debug description is not matching")
    }
    
}
