//
//  AILogCoreDataStackTest.swift
//  AppInfraTests
//
//  Created by Philips on 08/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import XCTest
import CoreData
@testable import AppInfra


class AILogCoreDataStackTest: XCTestCase {
    var sut: AILogCoreDataStack?
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AILogging", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSSQLiteStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        sut = AILogCoreDataStack.shared
        initStubs()
        //Listen to the change in context
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(self)
        flushData()
        super.tearDown()
    }
    
    func initStubs(){
        sut?.managedObjectContext = mockPersistantContainer.newBackgroundContext()
    }
    
    func testManageObjectContext(){
        XCTAssertNotNil(sut?.managedObjectContext, "managedObjectContext returned is nil despite registering it with newBackgroundContext")
    }
    // Insert Operation and checking the db returning same value as inserted
    
    func testInsertOperationInContext(){
        let cloudLogger = AICloudLogger()
        // Mocked Meta Data
        cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
        // Mocked LogMessage
        let logMessageObject = updateLogMessage()
        let expectation = XCTestExpectation(description: "testInsertOperationInContext")
        cloudLogger.log(message: logMessageObject)
        sut?.perform({
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)
        let value = itemsInPersistentStore()
        XCTAssertEqual(value?.count, 1)
        if let insertedItem = value?.first{
            XCTAssertEqual(insertedItem.appsId, "TestAppID")
            XCTAssertEqual(insertedItem.appVersion, "TestVersion")
            XCTAssertEqual(insertedItem.appState, "Test")
            XCTAssertEqual(insertedItem.homeCountry, "TestCountry")
            XCTAssertEqual(insertedItem.severity, AILogUtilities.logLevel(DDLogFlag.error))
            XCTAssertEqual(insertedItem.eventID, "TestEventID")
            XCTAssertEqual(insertedItem.userUUID, "hsdpUUID_TestUUID")
            XCTAssertEqual(insertedItem.details, nil)
            XCTAssertEqual(insertedItem.logDescription, "TestMessage")
        }
        
    }
   

    func updateMockCloudMetaData() ->MockAICloudLogMetaData{
        let mockCloudMetaData = MockAICloudLogMetaData()
        mockCloudMetaData.appId = "TestAppID"
        mockCloudMetaData.appName = "TestAppName"
        mockCloudMetaData.appState = "Test"
        mockCloudMetaData.appVersion = "TestVersion"
        mockCloudMetaData.homeCountry = "TestCountry"
        mockCloudMetaData.locale = "TestLocale"
        return mockCloudMetaData
    }
    func updateMockLogMetaData() -> AILogMetaData{
        let testMetaData = AILogMetaData()
        testMetaData.component = "TestComponent"
        testMetaData.eventId = "TestEventID"
        testMetaData.networkDate = Date()
        testMetaData.originatingUser = "TestUUID"
        testMetaData.params = nil
        return testMetaData
    }
    
    func updateLogMessage() -> DDLogMessage{
        let logmessage = MockDDLogMessage()
        logmessage.message = "TestMessage"
        logmessage.flag = DDLogFlag.error
        logmessage.level = DDLogLevel.error
        logmessage.tag = updateMockLogMetaData()
        logmessage.timestamp = Date()
        return logmessage
    }
    


    func testDBShouldNotHave1000Rows(){
        let cloudLogger = AICloudLogger()
        let expectation = XCTestExpectation(description: "testDBShouldNotHave1000Rows")
        for _ in 0...1004{
            // Mocked Meta Data
            cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
            // Mocked LogMessage
            let logMessageObject = updateLogMessage()
            cloudLogger.log(message: logMessageObject)
        }
        
        sut?.perform({
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 15)
        
        if let value = itemsInPersistentStore(){
            XCTAssert(value.count == 985 && value.count < 1000,"The rows are not deleted in DB")
        }
        
    }
    
    //Note: This feature was there earlier and now its removed. So we have kept the test cases for future reference.
     /*
    func testInfoAndVerboseAreLessThan20ThenDeleteAllInfoVerbose(){
        let cloudLogger = AICloudLogger()
        let expectation = XCTestExpectation(description: "testInfoAndVerboseAreLessThan20ThenDeleteAllInfoVerbose")
        // Mocked Meta Data
            cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
        for _ in 0...10{
            // Mocked LogMessage
            let logMessageObject = updateLogMessage()
            (logMessageObject as?MockDDLogMessage)?.mockFlag = DDLogFlag.info
            cloudLogger.log(message: logMessageObject)
        }
        for _ in 0...7{
            // Mocked Meta Data
            //cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
            // Mocked LogMessage
            let logMessageObject = updateLogMessage()
            (logMessageObject as?MockDDLogMessage)?.mockFlag = DDLogFlag.verbose
            cloudLogger.log(message: logMessageObject)
        }
        // Till this point DB has 19 rows with verbo and info
        
        for _ in 0...981{
            //cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
            // Mocked LogMessage
            let logMessageObject = updateLogMessage()
            cloudLogger.log(message: logMessageObject)
        }
        let dataFetch:NSFetchRequest<AILog> = AILog.fetchRequest()
        dataFetch.predicate = NSPredicate(format: "NOT (severity CONTAINS %@) OR (severity CONTAINS %@)", argumentArray: [AILogUtilities.logLevel(DDLogFlag.error),AILogUtilities.logLevel(DDLogFlag.warning)])
        sut?.perform({
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)

        let results = try! sut?.managedObjectContext?.fetch(dataFetch)
        if let items = results{
          XCTAssert(items.count == 0, "All Info and Verbose which are less than 20 are not deleted")
        }
    }

    func testInfoAndVerboseAreMoreThan20ThenDeleteOnly20InfoVerbose(){
        let cloudLogger = AICloudLogger()
        for _ in 0...10{
            // Mocked Meta Data
            cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
            // Mocked LogMessage
            let logMessageObject = updateLogMessage()
            (logMessageObject as?MockDDLogMessage)?.mockFlag = DDLogFlag.info
            cloudLogger.log(message: logMessageObject)
        }
        for _ in 0...10{
            // Mocked Meta Data
            cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
            // Mocked LogMessage
            let logMessageObject = updateLogMessage()
            (logMessageObject as?MockDDLogMessage)?.mockFlag = DDLogFlag.verbose
            cloudLogger.log(message: logMessageObject)
        }
        // Till this point DB has 19 rows with verbo and info
        
        for _ in 0...978{
            cloudLogger.cloudLogMetaData = updateMockCloudMetaData()
            // Mocked LogMessage
            let logMessageObject = updateLogMessage()
            cloudLogger.log(message: logMessageObject)
        }
        let dataFetch :NSFetchRequest<AILog> = AILog.fetchRequest()
        dataFetch.predicate = NSPredicate(format: "NOT (severity CONTAINS %@) OR (severity CONTAINS %@)", argumentArray: [AILogUtilities.logLevel(DDLogFlag.error),AILogUtilities.logLevel(DDLogFlag.warning)])
        let results = try! sut?.managedObjectContext?.fetch(dataFetch)
        if let items = results{
            XCTAssert(items.count
                != 0, "All Info and Verbose which are more than 20 are not deleted")
        }
    }
 
    */
    
    // Delete Operation
    func flushData() {
        let fetchRequest:NSFetchRequest<AILog> = AILog.fetchRequest()
        if let objs = try! sut?.managedObjectContext?.fetch(fetchRequest){
            for case let obj as NSManagedObject in objs {
                sut?.managedObjectContext?.delete(obj)
            }
            
            try? sut?.managedObjectContext?.save()
        }
       
        
    }
    
    func itemsInPersistentStore() -> [AILog]? {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AILog")
        let results = try! sut?.managedObjectContext?.fetch(request)
        if let items = results{
            return items as? [AILog]
        }
        return nil
    }
    
}

class MockAICloudLogMetaData: AICloudLogMetadata {
    var mockAppID: String?
    var mockNetWorkType:String?
    var mockAppName:String?
    var mockAppState:String?
    var mockAppVersion:String?
    var mockHomeCountry:String?
    var mockLocale:String?
    
    
    override var appId: String? {
        
        get {
            return mockAppID
        }
        
        set {
            mockAppID = newValue
        }
    }
    
    override var networkType: String?{
        get {
            return mockAppID
        }
        
        set {
            mockAppID = newValue
        }
    }
    override var appName: String?{
        get {
            return mockAppName
        }
        
        set {
            mockAppName = newValue
        }
    }
    override var appState: String?{
        get {
            return mockAppState
        }
        
        set {
            mockAppState = newValue
        }
    }
    override var appVersion: String?{
        get {
            return mockAppVersion
        }
        
        set {
            mockAppVersion = newValue
        }
    }
    override var homeCountry: String?{
        get {
            return mockHomeCountry
        }
        
        set {
            mockHomeCountry = newValue
        }
    }
    override var locale: String?{
        get {
            return mockLocale
        }
        
        set {
            mockLocale = newValue
        }
    }
}

class MockDDLogMessage:DDLogMessage{
    var mockMessage: String?
    var mockLevel:DDLogLevel?
    var mockFlag:DDLogFlag?
    var mockTimestamp:Date?
    var mockTag:AILogMetaData?
    
    
    override var message: String {
        
        get {
            return mockMessage!
        }
        
        set {
            mockMessage = newValue
        }
    }
    
    override var level: DDLogLevel{
        get {
            return mockLevel!
        }
        
        set {
            mockLevel = newValue
        }
    }
    override var flag: DDLogFlag{
        get {
            return mockFlag!
        }
        
        set {
            mockFlag = newValue
        }
    }
    override var timestamp: Date{
        get {
            return mockTimestamp!
        }
        
        set {
            mockTimestamp = newValue
        }
    }
    
    override var tag: Any?{
        get {
            return mockTag!
        }
        
        set {
            mockTag = newValue as? AILogMetaData
        }
    }
    
}

