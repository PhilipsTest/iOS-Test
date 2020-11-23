//
//  ConsentRegistryTests.swift
//  ConsentRegistryTests
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PlatformInterfaces

@testable import AppInfra

class ConsentRegistryMapperTests: XCTestCase {
    private var consentManager: AIConsentManager!
    private var consentHandlerMock: AIConsentHandlerMock!
    private var fetchedConsentStatus: ConsentStates!
    private var fetchedVersionStatus: ConsentVersionStates!
    private var fetchedConsentDefinitionStatuses: [ConsentDefinitionStatus]!
    private var foundHandler: ConsentHandlerProtocol!
    private var errorRegisteringConsentDefinitions: Bool!
    private var errorReturned: NSError!
    
    override func setUp() {
        super.setUp()
        self.consentManager = AIConsentManager()
        self.consentHandlerMock = AIConsentHandlerMock()
    }
    
    override func tearDown() {
        self.consentManager.deregisterHandler(forConsentTypes: [ConsentKeys.consentKey, ConsentKeys.momentConsentKey])
        self.errorReturned = nil
        self.fetchedConsentDefinitionStatuses = nil
        self.fetchedConsentStatus = nil
        self.fetchedVersionStatus = nil
        super.tearDown()
    }
    
    func testConsentRegistryCreation() {
        XCTAssertNotNil(consentManager, "Registry object is not created")
        
        let duplicateRegistryObject = AIConsentManager()
        XCTAssertNotNil(duplicateRegistryObject, "Registry object is not created")
        XCTAssert(consentManager !== duplicateRegistryObject, "The objects are not the same as expected.")
    }
    
    func testRegistrationWithConsentRegistry() {
        let consentHandler = AIConsentHandlerMock()
        do {
            try consentManager.registerHandler(handler: consentHandler, forConsentTypes: [ConsentKeys.momentConsentKey])
        } catch _ {
            XCTFail()
        }
        
        let handler = consentManager.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNotNil(handler, "Handler returned is nil despite registering it")
    }
    
    func testFetchHandler_returnsNil_whenTheHandlerIsNotRegistered() {
        whenGettingHandler(forConsentType: ConsentKeys.momentConsentKey)
        thenFoundHandlerIsNil()
    }
    
    func testFetchConsent_returnsInactive_whenBackendVersionIsLowerThanAppVersion() {
        givenBackendReturns(ConsentStates.active, forVersion: 0)
        givenHandler(consentHandlerMock, ["moment"])
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 1))
        thenNoErrorIsReturned()
        thenFoundStatusIs(ConsentStates.inactive)
    }
    
    func testFetchConsent_returnsBackendStatus_whenBackendVersionIsHigherThanAppVersion() {
        givenBackendReturns(ConsentStates.active, forVersion: 2)
        givenHandler(consentHandlerMock, ["moment"])
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 1))
        thenNoErrorIsReturned()
        thenFoundStatusIs(ConsentStates.active)
    }
    
    func testFetchConsent_returnsBackendStatus_whenBackendVersionIsSameAsAppVersion() {
        givenHandler(consentHandlerMock, ["moment"])
        
        givenBackendReturns(ConsentStates.active, forVersion: 2)
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 2))
        thenNoErrorIsReturned()
        thenFoundStatusIs(ConsentStates.active)
        
        givenBackendReturns(ConsentStates.rejected, forVersion: 2)
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 2))
        thenNoErrorIsReturned()
        thenFoundStatusIs(ConsentStates.rejected)
    }
    
    func testFetchConsent_returnsAppVersionHigherStatus_whenAppVersionIsHigherThanBackendVersion() {
        givenBackendReturns(ConsentStates.active, forVersion: 0)
        givenHandler(consentHandlerMock, ["moment"])
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 1))
        thenNoErrorIsReturned()
        thenFoundConsentVersionStatusIs(ConsentVersionStates.appVersionIsHigher)
    }
    
    func testFetchConsent_returnsAppVersionLowerStatus_whenAppVersionIsLowerThanBackendVersion() {
        givenBackendReturns(ConsentStates.active, forVersion: 2)
        givenHandler(consentHandlerMock, ["moment"])
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 1))
        thenNoErrorIsReturned()
        thenFoundConsentVersionStatusIs(ConsentVersionStates.appVersionIsLower)
    }
    
    func testFetchConsent_returnsIsSyncStatus_whenAppVersionIsSameAsBackendVersion() {
        givenBackendReturns(ConsentStates.active, forVersion: 2)
        givenHandler(consentHandlerMock, ["moment"])
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 2))
        thenNoErrorIsReturned()
        thenFoundConsentVersionStatusIs(ConsentVersionStates.inSync)
    }
    
    func testUnregisteringOfConsentTypes() {
        givenHandler(consentHandlerMock, ["moment"])
        let handler = consentManager.getHandler(forConsentType: "moment")
        XCTAssertNotNil(handler, "Returned object is nil")
        
        consentManager.deregisterHandler(forConsentTypes: [ConsentKeys.momentConsentKey])
        let handlerReturned = consentManager.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNil(handlerReturned, "Handler returned is not nil despite removing it")
    }
    
    func testRegisteringOfEmptyConsentTypes() {
        givenHandler(consentHandlerMock, [])
        let handler = consentManager.getHandler(forConsentType: ConsentKeys.momentConsentKey)
        XCTAssertNil(handler, "Handler returned is not nil despite not registering it")
    }
    
    func testUnRegisteringOfEmptyConsentTypes() {
        givenHandler(consentHandlerMock, ["moment"])
        consentManager.deregisterHandler(forConsentTypes: [])
        let handler = consentManager.getHandler(forConsentType: "moment")
        XCTAssertNotNil(handler, "Handler returned is nil")
    }
    
    func testRegisteringOfHandlerWithSameType() {
        givenHandler(consentHandlerMock, ["moment"])
        givenHandler(consentHandlerMock, ["moment"], failWhenNoException: true)
    }
    
    func testConsentDefinitionRegistration() {
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "moment text", helpText: "moment help text", version: 1, locale: "en-US")
        let coachingConsentDefinition = ConsentDefinition(type: "coaching", text: "coaching text", helpText: "coaching help text", version: 1, locale: "en-US")
        givenRegisteredConsentDefinition([momentConsentDefinition, coachingConsentDefinition])
     
        var consentDefinition = self.consentManager.getConsentDefinition(forConsentType: "moment")
        XCTAssertTrue(momentConsentDefinition == consentDefinition)
        
        consentDefinition = self.consentManager.getConsentDefinition(forConsentType: "coaching")
        XCTAssertTrue(coachingConsentDefinition == consentDefinition)
        
        consentDefinition = self.consentManager.getConsentDefinition(forConsentType: "coaching1")
        XCTAssertNil(consentDefinition)
    }
    
    func testConsentDefinitionRegistrationWithEmptyConsentDefinitions() {
        givenRegisteredConsentDefinition([])

        var consentDefinition = self.consentManager.getConsentDefinition(forConsentType: "moment")
        XCTAssertNil(consentDefinition)
        
        consentDefinition = self.consentManager.getConsentDefinition(forConsentType: "coaching")
        XCTAssertNil(consentDefinition)
    }
    
    func testConsentDefinitionRegistration_WithDuplicateConsentDefinitions_ThrowsException() {
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "moment text", helpText: "moment help text", version: 1, locale: "en-US")
        givenRegisteredConsentDefinition([momentConsentDefinition, momentConsentDefinition, momentConsentDefinition])
        XCTAssertTrue(errorRegisteringConsentDefinitions)
    }
    
    func testFetchConsetStateTimesOutShouldReturnError() {
        givenHandler(consentHandlerMock, ["moment"])
        givenTimeoutForBackendCallsIs(seconds: 3)
        givenBackendDoesNotCallCompletion()
        whenFetchingStatusFor(consentDefinition(ofType: "moment", andVersion: 2))
        thenTimeOutErrorIsReturned()
    }
    
    func testFetchConsentStatesTimesOutShouldReturnError() {
        givenHandler(consentHandlerMock, ["moment", "insight"])
        givenTimeoutForBackendCallsIs(seconds: 3)
        givenBackendDoesNotCallCompletion()
        whenFetchingStatusesFor([consentDefinition(ofType: "moment", andVersion: 2), consentDefinition(ofType: "insight", andVersion: 2)])
        thenTimeOutErrorIsReturned()
    }
    
    func givenBackendDoesNotCallCompletion() {
        consentHandlerMock.shouldFetchCallCompletion = false
    }
    
    func givenBackendReturns(_ consentStatus: ConsentStates, forVersion version: Int) {
        consentHandlerMock.postSuccess = consentStatus
        consentHandlerMock.versionToReturn = version
    }
    
    func givenHandler(_ consentHandler: ConsentHandlerProtocol, _ consentTypes: [String], failWhenNoException: Bool = false) {
        do {
            try consentManager.registerHandler(handler: consentHandler, forConsentTypes: consentTypes)
        } catch  {
            if (!failWhenNoException) {
                XCTFail()
            }
            return
        }
        if (failWhenNoException) {
            XCTFail()
        }
    }
    
    func givenRegisteredConsentDefinition(_ consentDefinitions: [ConsentDefinition]) {
        let consentDefinitionRegistrationExpectation = XCTestExpectation(description: "Registration of consent definition completed")
        consentManager.registerConsentDefinitions(consentDefinitions: consentDefinitions) { error in
            self.errorRegisteringConsentDefinitions = true
            consentDefinitionRegistrationExpectation.fulfill()
        }
        wait(for: [consentDefinitionRegistrationExpectation], timeout: 5.0)
    }
    
    func givenTimeoutForBackendCallsIs(seconds: Double) {
        self.consentManager._timeoutIntervalForTesting = seconds
    }
    
    func whenFetchingStatusFor(_ consentDefinition: ConsentDefinition) {
        givenRegisteredConsentDefinition([consentDefinition])
        let fetchConsentExpectation = XCTestExpectation(description: "Wait for fetching consent status")
        self.consentManager.fetchConsentState(forConsentDefinition: consentDefinition, completion: { (consentDefinitionStatus, error) in
            guard error == nil else {
                self.errorReturned = error
                fetchConsentExpectation.fulfill()
                return
            }
            self.fetchedConsentStatus = consentDefinitionStatus!.status
            self.fetchedVersionStatus = consentDefinitionStatus!.versionStatus
            fetchConsentExpectation.fulfill()
        });
        wait(for: [fetchConsentExpectation], timeout: 5.0)
    }
    
    func whenFetchingStatusesFor(_ consentDefinitions: [ConsentDefinition]) {
        givenRegisteredConsentDefinition(consentDefinitions)
        let fetchConsentExpectation = XCTestExpectation(description: "Wait for fetching consent status")
        self.consentManager.fetchConsentStates(forConsentDefinitions: consentDefinitions, completion: { (consentDefinitionStatuses, error) in
            guard error == nil else {
                self.errorReturned = error
                fetchConsentExpectation.fulfill()
                return
            }
            self.fetchedConsentDefinitionStatuses = consentDefinitionStatuses
            fetchConsentExpectation.fulfill()
        });
        wait(for: [fetchConsentExpectation], timeout: 5.0)
    }
    
    func whenGettingHandler(forConsentType type: String) {
        foundHandler = consentManager.getHandler(forConsentType: type)
    }
    
    func thenFoundHandlerIsNil() {
        XCTAssertNil(foundHandler, "Handler returned is not nil despite not registering it")
    }
    
    func thenFoundConsentVersionStatusIs(_ consentVersionStates: ConsentVersionStates) {
        XCTAssertEqual(consentVersionStates, fetchedVersionStatus)
    }
    
    func thenFoundStatusIs(_ expectedStatus: ConsentStates) {
        XCTAssertEqual(expectedStatus.rawValue, fetchedConsentStatus.rawValue)
    }
    
    func thenTimeOutErrorIsReturned() {
        XCTAssertNotNil(self.errorReturned)
        XCTAssertEqual(self.errorReturned.code, NSURLErrorTimedOut)
    }
    
    func thenNoErrorIsReturned() {
        XCTAssertNil(self.errorReturned)
    }
    
    func consentDefinition(ofType type: String, andVersion version: Int) -> ConsentDefinition {
        return ConsentDefinition(type: type, text: "moment text", helpText: "moment help text", version: version, locale: "en-US")
    }
    
}
