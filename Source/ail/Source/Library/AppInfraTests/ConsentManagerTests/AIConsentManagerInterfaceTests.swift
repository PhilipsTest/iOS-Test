//
//  ConsentRegistryInterfaceTests.swift
//  ConsentAccessToolKitTests
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PlatformInterfaces

@testable import AppInfra

struct ConsentKeys{
    static let momentConsentKey = "Moment"
    static let consentKey = "consent"
}

class ConsentRegistryInterfaceTests: XCTestCase {
    private var consentInteractorToUse: AIConsentHandlerMock!
    private var registryInterfaceObject: AIConsentManager!
    private var postSuccessValue: ConsentStates!
    private var consentDefinition: ConsentDefinition!
    
    override func setUp() {
        super.setUp()
        registryInterfaceObject = AIConsentManager()
        consentInteractorToUse = AIConsentHandlerMock()
        consentInteractorToUse.indexOfStatusToReturn = 0
    }
    
    override func tearDown() {
        registryInterfaceObject.deregisterHandler(forConsentTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        postSuccessValue = ConsentStates.inactive
        super.tearDown()
    }
    
    func testConsentRegistryInterfaceRegistrationWithSingleType() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        let handler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNotNil(handler, "Handler returned is nil despite registering it")
    }
    
    func testConsentRegistryInterfaceRegistrationWithMultipleTypes() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        var handler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNotNil(handler, "Handler returned is nil despite registering it")
        
        handler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.consentKey)
        XCTAssertNotNil(handler, "Handler returned is nil despite registering it")
    }
    
    func testConsentRegistryInterfaceQueryWithTwoDifferentKeys() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.consentKey])
        let handler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNil(handler, "Handler returned is nil despite registering it with different")
    }
    
    func testConsentRegistryInterfaceUnRegisteration() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        var handler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNotNil(handler, "Handler returned is nil despite registering it")
        
        registryInterfaceObject.deregisterHandler(forConsentTypes: [ConsentKeys.momentConsentKey])
        handler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNil(handler, "Handler returned is nil despite removing it")
    }
    
    func testFetchingOfConsentRegistryWithoutRegistering() {
        let handler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNil(handler, "Handler returned is not nil despite not registering it")
    }
    
    func testConsentRegistryInterfaceForDuplicateKeys() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        XCTAssertThrowsError(try registryInterfaceObject.registerHandler(handler: consentInteractorToUse, forConsentTypes: [ConsentKeys.momentConsentKey]))
    }
    
    func testConsentRegistryInterfaceWithMultipleInterfaceObjects() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.consentKey])
        register(object: AIConsentHandlerMock(), forTypes: [ConsentKeys.momentConsentKey])
        
        let momentHandler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        let consentHandler = registryInterfaceObject.getHandler(forConsentType: ConsentKeys.consentKey)
        XCTAssert(momentHandler !== consentHandler)
    }
    
    private func register(object: ConsentHandlerProtocol, forTypes: [String]) {
        do {
            try registryInterfaceObject.registerHandler(handler: object, forConsentTypes: forTypes)
        } catch _ {
            XCTFail()
        }
    }
    
    private func configureConsentInteractor(postSuccessValue: ConsentStates,error: NSError?, consentStatesToReturn: [ConsentStatus] = [], shouldReturnEmptyConsents: Bool = false) {
        consentInteractorToUse.postSuccess = postSuccessValue
        self.postSuccessValue = postSuccessValue
        consentInteractorToUse.errorToReturn = error
        consentInteractorToUse.consentStatesToUse = consentStatesToReturn
        consentInteractorToUse.shouldUseArrayOfConsentStates = !consentStatesToReturn.isEmpty
        consentInteractorToUse.shouldReturnEmptyErrorAndStatus = shouldReturnEmptyConsents
    }
    
    private func getError() -> NSError {
        return NSError(domain: "TestError", code: 10000, userInfo: nil)
    }
    
    private func checkForValues(of consentDefinitionStatus: ConsentDefinitionStatus?) {
        XCTAssert(consentDefinitionStatus?.status == self.postSuccessValue)
        XCTAssertTrue(consentDefinitionStatus?.consentDefinition == self.consentDefinition)
    }
    
    func testConsentRegistryInterfaceFetchConsentStateWithoutErrorAndPostFailure() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentState(forConsentDefinition: consentDefinition) { (definitionStatus, error) in
            self.checkForValues(of: definitionStatus)
            XCTAssertNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceFetchConsentStateWithoutErrorAndPostSuccess() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 0, locale: "en-US")

        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentState(forConsentDefinition: consentDefinition) { (definitionStatus, error) in
            self.checkForValues(of: definitionStatus)
            XCTAssertNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceFetchConsentStateWithError() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")

        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentState(forConsentDefinition: consentDefinition) { (definitionStatus, error) in
            XCTAssertNil(definitionStatus)
            self.testErrorReturned(errorToCheck: error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceFetchConsentStateWithErrorAndPostSuccess() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")

        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentState(forConsentDefinition: consentDefinition) { (definitionStatus, error) in
            self.testErrorReturned(errorToCheck: error)
            XCTAssertNil(definitionStatus)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    private func testErrorReturned(errorToCheck: NSError?) {
        let error = self.getError()
        XCTAssert(error.code == errorToCheck?.code)
        XCTAssertNotNil(errorToCheck)
    }
    
    private func waitForExpectationsFullfillment() {
        self.waitForExpectations(timeout: 10) { error in
            if (error != nil) {
                self.recordFailure(withDescription: "Failed to complete Fetching after 10 seconds.", inFile: #file, atLine: #line, expected: true)
            }
        }
    }
    
    func testConsentRegistryInterfaceFetchConsentStatesWithErrorAndPostSuccess() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition,consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            self.testErrorReturned(errorToCheck: error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceFetchConsentStatesWithErrorAndPostFailure() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition,consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            self.testErrorReturned(errorToCheck: error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceFetchConsentStatesWithoutErrorAndPostSuccess() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition,consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceFetchConsentStatesWithoutErrorAndPostFailure() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition,consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertFalse(listOfConsentDefinitionStatus!.isEmpty == true)
            XCTAssertNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceWithEmptyHandlerAndFetchConsents() {
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition,consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssert(listOfConsentDefinitionStatus!.isEmpty == true)
            XCTAssertNotNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testEmptyHandlerWithMultipleTypesAndFetchConsents() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssert(listOfConsentDefinitionStatus!.isEmpty == true)
            XCTAssertNotNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testFetchConsentStatesWithoutRegisteringHandlersOnlyForLastType() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssert(listOfConsentDefinitionStatus!.isEmpty == true)
            XCTAssertNotNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceStoreConsentStateWithOnStatusWithoutError() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssert(ConsentStates.active == self.postSuccessValue)
            XCTAssertNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceStoreConsentStateWithOffStatusWithoutError() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: false) { (value, error) in
            XCTAssert(ConsentStates.inactive == self.postSuccessValue)
            XCTAssertNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceStoreConsentStateWithOnStatusAndError() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssert(ConsentStates.active == self.postSuccessValue)
            self.testErrorReturned(errorToCheck: error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceStoreConsentStateWithOffStatusAndError() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: false) { (value, error) in
            XCTAssert(ConsentStates.inactive == self.postSuccessValue)
            self.testErrorReturned(errorToCheck: error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentRegistryInterfaceWithEmptyHandlerAndPostStatus() {
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssert(value == false)
            XCTAssertNotNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testEmptyHandlerForMultipleTypeAndPostStatus() {
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssert(value == false)
            XCTAssertNotNil(error)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchTypes_DifferentConsentTypesStatus_FirstActive() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.active, version: 1), ConsentStatus(status: ConsentStates.inactive, version: 1)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.inSync, withStatus:ConsentStates.inactive)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchTypes_DifferentConsentTypesStatus_FirstRejected() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.rejected, version: 1), ConsentStatus(status: ConsentStates.inactive, version: 1)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.inSync, withStatus:ConsentStates.rejected)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchType_DifferentConsentTypesStatus_FirstInactive() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.inactive, version: 1), ConsentStatus(status: ConsentStates.active, version: 1)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.inSync, withStatus:ConsentStates.inactive)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchType_EmptyConsentTypesStatus() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, shouldReturnEmptyConsents: true)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus?.count == 0)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchType_DifferentConsentTypesVersion_FirstHigher() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.inactive, version: 2), ConsentStatus(status: ConsentStates.active, version: 1)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.appVersionIsLower, withStatus:ConsentStates.inactive)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchType_DifferentConsentTypesStatus_FirstInactive_SecondRejected() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.inactive, version: 2), ConsentStatus(status: ConsentStates.rejected, version: 1)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.appVersionIsLower, withStatus:ConsentStates.rejected)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchType_DifferentConsentTypesVersion_FirstLower() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.inactive, version: 2), ConsentStatus(status: ConsentStates.active, version: 1)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.appVersionIsLower, withStatus:ConsentStates.inactive)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchType_DifferentConsentTypesVersion_BothEqual() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.inactive, version: 2), ConsentStatus(status: ConsentStates.active, version: 2)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.appVersionIsLower, withStatus:ConsentStates.inactive)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchType_DifferentConsentTypeVersion_BothEqual_ButLower() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.inactive, version: 2), ConsentStatus(status: ConsentStates.active, version: 2)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil, consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 3, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            XCTAssertNil(error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 1)
            self.compareConsentDefinition(consentDefinitionStatus: listOfConsentDefinitionStatus!.first!, withVersionStatus: ConsentVersionStates.appVersionIsHigher, withStatus:ConsentStates.inactive)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentDefinitionForMultipleFetchTypes_DifferentConsentTypesStatus_WithError() {
        let consentDefinitionStatus = [ConsentStatus(status: ConsentStates.active, version: 1), ConsentStatus(status: ConsentStates.inactive, version: 1)]
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: getError(), consentStatesToReturn: consentDefinitionStatus)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.fetchConsentStates(forConsentDefinitions: [consentDefinition]) { (listOfConsentDefinitionStatus, error) in
            XCTAssertNotNil(listOfConsentDefinitionStatus)
            self.testErrorReturned(errorToCheck: error)
            XCTAssert(listOfConsentDefinitionStatus!.count == 0)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testFetchConsentTypeWithSuccess() {
        configureConsentInteractor(postSuccessValue: ConsentStates.inactive, error: nil)
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey, ConsentKeys.consentKey])

        let asyncExpectation = expectation(description: "longRunningFunction")
        registerConsentDefinition(consentDefinitions: [consentDefinition]) { error in
            self.fetchSingleConsentType(consentType: ConsentKeys.momentConsentKey, asyncExpectation: asyncExpectation)
        }
        waitForExpectationsFullfillment()
    }
    
    func testFetchConsentTypeWithError() {
        XCTAssertThrowsError(try registryInterfaceObject.fetchConsentTypeState(forConsentType: "sampleType") {_,_ in })
    }
    
    private func fetchSingleConsentType(consentType: String, asyncExpectation: XCTestExpectation) {
        do {
            try registryInterfaceObject.fetchConsentTypeState(forConsentType: consentType) { (consentStatus, error) in
                XCTAssertTrue(error == nil)
                XCTAssertTrue(consentStatus != nil)
                asyncExpectation.fulfill()
            }
        } catch _ {
            XCTFail()
        }
    }
    
    private func registerConsentDefinition(consentDefinitions: [ConsentDefinition], completion: @escaping (_ error: NSError?) -> ()) {
        registryInterfaceObject.registerConsentDefinitions(consentDefinitions: consentDefinitions) { error in
            completion(error)
        }
    }
    
    private func compareConsentDefinition(consentDefinitionStatus: ConsentDefinitionStatus, withVersionStatus: ConsentVersionStates, withStatus: ConsentStates) {
        XCTAssert(consentDefinitionStatus.status == withStatus)
        XCTAssert(consentDefinitionStatus.versionStatus == withVersionStatus)
    }
}

//Test cases for Registering Consent Callbacks

extension ConsentRegistryInterfaceTests {
    
    func testRegisterConsentCallBack() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBack = getMockConsentCallback()
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { [weak self] (value, error) in
            XCTAssertEqual(consentCallBack.callBackReceived, 1)
            XCTAssertEqual(consentCallBack.consentDefinition, self?.consentDefinition)
            XCTAssertNil(consentCallBack.error)
            XCTAssertEqual(consentCallBack.status, true)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testRegisterConsentCallBackReturnsError() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: getError())
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBack = getMockConsentCallback()
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { [weak self] (value, error) in
            XCTAssertEqual(consentCallBack.callBackReceived, 1)
            XCTAssertEqual(consentCallBack.consentDefinition, self?.consentDefinition)
            self?.testErrorReturned(errorToCheck: consentCallBack.error)
            XCTAssertEqual(consentCallBack.status, true)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentCallBackRegisterRegisterOnlyOnce() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBack = getMockConsentCallback()
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { [weak self] (value, error) in
            XCTAssertEqual(consentCallBack.callBackReceived, 1)
            XCTAssertEqual(consentCallBack.consentDefinition, self?.consentDefinition)
            XCTAssertNil(consentCallBack.error)
            XCTAssertEqual(consentCallBack.status, true)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentCallBackRegisterForMutipleObjects() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBackFirst = getMockConsentCallback()
        let consentCallBackSecond = getMockConsentCallback()
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBackFirst)
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBackSecond)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssertEqual(consentCallBackFirst.callBackReceived, 1)
            XCTAssertEqual(consentCallBackFirst.status, true)
            XCTAssertEqual(consentCallBackSecond.callBackReceived, 1)
            XCTAssertEqual(consentCallBackSecond.status, true)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentCallBackDeRegister() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBack = getMockConsentCallback()
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        deRegisterConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssertEqual(consentCallBack.callBackReceived, 0)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentCallBackDeRegisterDoesnotAffectOtherRegisteredCallbacks() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBackFirst = getMockConsentCallback()
        let consentCallBackSecond = getMockConsentCallback()
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBackFirst)
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBackSecond)
        deRegisterConsentCallBack(for: consentDefinition, consentCallback: consentCallBackFirst)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssertEqual(consentCallBackFirst.callBackReceived, 0)
            XCTAssertEqual(consentCallBackSecond.callBackReceived, 1)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentCallBackDeRegisterWithoutRegister() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBack = getMockConsentCallback()
        deRegisterConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { (value, error) in
            XCTAssertEqual(consentCallBack.callBackReceived, 0)
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment()
    }
    
    func testConsentCallBackRegisterForMutipleConsentDefintions() {
        configureConsentInteractor(postSuccessValue: ConsentStates.active, error: nil)
        register(object: consentInteractorToUse, forTypes: [ConsentKeys.momentConsentKey])
        consentDefinition = ConsentDefinition(types: [ConsentKeys.momentConsentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentDefinitionSecond = ConsentDefinition(types: [ConsentKeys.consentKey], text: "SampleTest", helpText: "SampleHelpText", version: 1, locale: "en-US")
        let consentCallBack = getMockConsentCallback()
        registerConsentCallBack(for: consentDefinition, consentCallback: consentCallBack)
        registerConsentCallBack(for: consentDefinitionSecond, consentCallback: consentCallBack)
        let asyncExpectation = expectation(description: "longRunningFunction")
        registryInterfaceObject.storeConsentState(consent: consentDefinition, withStatus: true) { [weak self] (value, error) in
            XCTAssertEqual(consentCallBack.callBackReceived, 1)
            XCTAssertEqual(consentCallBack.consentDefinition, self?.consentDefinition)
            XCTAssertEqual(consentCallBack.status, true)
            self?.registryInterfaceObject.storeConsentState(consent: consentDefinitionSecond, withStatus: false) { (value, error) in
                XCTAssertEqual(consentCallBack.callBackReceived, 2)
                XCTAssertEqual(consentCallBack.consentDefinition, consentDefinitionSecond)
                XCTAssertEqual(consentCallBack.status, false)
                asyncExpectation.fulfill()
            }
        }
        waitForExpectationsFullfillment()
    }
    
    fileprivate func registerConsentCallBack(for consentDefinition: ConsentDefinition, consentCallback: AIConsentStatusChangeProtocol) {
        registryInterfaceObject.addConsentStatusChanged(delegate: consentCallback, for: consentDefinition)
    }
    
    fileprivate func deRegisterConsentCallBack(for consentDefinition: ConsentDefinition, consentCallback: AIConsentStatusChangeProtocol) {
        registryInterfaceObject.removeConsentStatusChanged(delegate: consentCallback, for: consentDefinition)
    }
    
    fileprivate func getMockConsentCallback() -> MockConsentRegisterCallback {
        return MockConsentRegisterCallback()
    }
}

class MockConsentRegisterCallback: NSObject, AIConsentStatusChangeProtocol {
    
    var callBackReceived: Int = 0
    var error: NSError?
    var status: Bool!
    var consentDefinition: ConsentDefinition!
    
    func consentStatusChanged(for consentDefinition: ConsentDefinition, error: NSError?, requestedStatus: Bool) {
        callBackReceived += 1
        self.error = error
        self.status = requestedStatus
        self.consentDefinition = consentDefinition
    }
}
