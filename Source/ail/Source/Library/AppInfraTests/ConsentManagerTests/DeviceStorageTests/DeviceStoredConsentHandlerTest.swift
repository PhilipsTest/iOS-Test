/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PlatformInterfaces
@testable import AppInfra

class DeviceStoredConsentHandlerTest: XCTestCase {
    
    //MARK Variable Declarations
    
    var appInfra: AIAppInfra!
    var appInfraMockSecureStorage: AppInfraSecureStorageMock!
    
    
    //MARK Default methods
    
    override func setUp() {
        super.setUp()
        appInfra = AIAppInfra()
        appInfraMockSecureStorage = AppInfraSecureStorageMock()
        appInfra.storageProvider = appInfraMockSecureStorage
        appInfra.time = AppInfraTimeMock()
        appInfra.logging = TestAILoggingProtocol()
        appInfra.internationalization = AppInfraInternationalizationMock()
        appInfra.deviceHandler = DeviceStoredConsentHandler(with: appInfra)
        appInfra.cloudLogging = appInfra.logging as? AICloudLoggingProtocol
    }
    
    override func tearDown() {
        super.tearDown()
        appInfraMockSecureStorage.flushAllConsentData()
    }
    
    var fetchConsent:DummyConsent!
    var returnedConsentStatus:ConsentStatus!

}

//MARK DeviceStoredConsentHandler Test Cases

extension DeviceStoredConsentHandlerTest {
    
    func testDeviceCloudConsentHandler()
    {
        XCTAssertNotNil(appInfra.deviceHandler);
    }
    
    func testCloudConsentHandlerIdentifier()
    {
        XCTAssertNotNil(appInfra.cloudLogging.getCloudLoggingConsentIdentifier());
    }

    
    func testDeviceConsentFetchBeforePost() {
        let fetchConsent = createConsent()
         appInfra.deviceHandler.fetchConsentTypeState(for: fetchConsent.type) { (consentStatus, error) in
            XCTAssertNil(error)
            if let consentStatus = consentStatus {
                XCTAssertEqual(consentStatus.status, ConsentStates.inactive)
                XCTAssertEqual(consentStatus.version, 0)
            }
        }
    }
    
    func testDeviceConsentPostSuccess() {
        let postConsent = createConsent()
         appInfra.deviceHandler.storeConsentState(for: postConsent.type,
                                                     withStatus: true,
                                                     withVersion: postConsent.version) { (postStatus, error) in
                                                        XCTAssertTrue(postStatus)
                                                        XCTAssertNil(error)
                                                        XCTAssertEqual(postConsent.version, 1)
        }
    }
    
    func testDeviceConsentPostFailure() {
        let postConsent = createConsent()
        appInfraMockSecureStorage.mockSecureStorageOutputType = .postError
         appInfra.deviceHandler.storeConsentState(for: postConsent.type,
                                                     withStatus: true,
                                                     withVersion: postConsent.version) { (postStatus, error) in
                                                        XCTAssertFalse(postStatus)
                                                        XCTAssertNil(error)
        }
    }
    
    func testSingleFetchStatusSuccess() {
        let postConsent = createConsent()
        appInfra.deviceHandler.storeConsentState(for: postConsent.type, withStatus: true, withVersion: postConsent.version) { [weak self] (status, _) in
            self?.appInfra.deviceHandler.fetchConsentTypeState(for: postConsent.type,
                                                                   completion: { (consentStatus, _) in
                                                                    if let consentStatus = consentStatus {
                                                                        XCTAssertEqual(consentStatus.status, ConsentStates.active)
                                                                    }
            })
        }
    }
    
    func testFetchStatusForVersionChange() {
        let postConsent = createConsent()
        let fetchConsent = createConsent(with: "dummyConsent",
                                         version: 2)
        appInfra.deviceHandler.storeConsentState(for: postConsent.type,
                                                     withStatus: true,
                                                     withVersion: postConsent.version) { [weak self] (status, _) in
                                                        self?.appInfra.deviceHandler.fetchConsentTypeState(for: fetchConsent.type,
                                                                                                               completion: { (fetchStatus, _) in
                                                                                                                if let fetchStatus = fetchStatus {
                                                                                                                    XCTAssertEqual(fetchStatus.status, ConsentStates.active)
                                                                                                                    XCTAssertEqual(fetchStatus.version, 1)
                                                                                                                }
                                                        })
        }
    }
    
    func testConsentDataUpdate() {
        let consent = createConsent()
        appInfra.deviceHandler.storeConsentState(for: consent.type,
                                                     withStatus: true,
                                                     withVersion: consent.version,
                                                     completion: {_, _ in })
        appInfra.deviceHandler.storeConsentState(for: consent.type,
                                                     withStatus: false,
                                                     withVersion: consent.version,
                                                     completion: {_, _ in })
        appInfra.deviceHandler.fetchConsentTypeState(for: consent.type) { (consentFetchStatus, _) in
            if let consentFetchStatus = consentFetchStatus {
                XCTAssertEqual(consentFetchStatus.status, ConsentStates.inactive)
                XCTAssertEqual(consentFetchStatus.version, 1)
            }
        }
    }
    
    func testConsentDataFetchFailForDifferentDataReturn() {
        let postConsent = createConsent(with: "dummyConsent4",
                                        version: 3)
        appInfra.deviceHandler.storeConsentState(for: postConsent.type,
                                                     withStatus: true,
                                                     withVersion: postConsent.version,
                                                     completion: {_, _ in })
        appInfraMockSecureStorage.mockSecureStorageOutputType = .fetchMockError
        appInfra.deviceHandler.fetchConsentTypeState(for: postConsent.type) { (consentFetchStatus, _) in
            if let consentFetchStatus = consentFetchStatus {
                XCTAssertEqual(consentFetchStatus.status, ConsentStates.active)
            }
        }
    }
    
    func testTimeStampStored() {
        givenTheConsentDetails()
        givenConsentDetailsAreStored()
        whenFetchConsentIsInvoked()
        thenConsentStatusObjectContainsTimestamp()
    }
    
    private func givenTheConsentDetails(){
        fetchConsent = createConsent()
    }
    
    private func givenConsentDetailsAreStored(){
        appInfra.deviceHandler.storeConsentState(for: fetchConsent.type,
                                                 withStatus: true,
                                                 withVersion: fetchConsent.version,
                                                 completion: {_, _ in })
    }
    
    private func whenFetchConsentIsInvoked(){
        appInfra?.deviceHandler.fetchConsentTypeState(for: fetchConsent.type) { (consentStatus, error) in
            self.returnedConsentStatus = consentStatus
        }
    }
    private func thenConsentStatusObjectContainsTimestamp(){
        let timestamp = returnedConsentStatus.timestamp
        XCTAssertNotNil(timestamp)
        XCTAssertTrue(timestamp.compare(Date(timeIntervalSince1970: 0)) == ComparisonResult.orderedDescending)

    }
 
  
}

//MARK Helper methods

extension DeviceStoredConsentHandlerTest {
    
    func createConsent(with type: String = "dummyConsent",
                       version: Int = 1) -> DummyConsent {
        return DummyConsent(type: type, version: version)
    }
}
