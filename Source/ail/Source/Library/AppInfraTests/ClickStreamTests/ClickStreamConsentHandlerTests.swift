/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import PlatformInterfaces

class ClickStreamConsentHandlerTests: XCTestCase {
    
    //MARK Variable Declarations
    var appInfra: AIAppInfra!
    var clickStreamHandler: ClickStreamConsentHandler!
    fileprivate var CLICKSTREAMCONSENTTYPE = ""
    var fetchConsent:DummyConsent!
    var fetchConsent1:DummyConsent!
    var returnedConsentStatus:ConsentStatus!
    
    //MARK Default methods
    override func setUp() {
        super.setUp()
        appInfra = AIAppInfra()
        appInfra.tagging = AppInfraTaggingMock()
        appInfra.storageProvider = AppInfraSecureStorageMock()
        appInfra.time = AppInfraTimeMock()
        appInfra.internationalization = AppInfraInternationalizationMock()
        clickStreamHandler = ClickStreamConsentHandler(with: appInfra)
        CLICKSTREAMCONSENTTYPE = appInfra.tagging.getClickStreamConsentIdentifier()
    }
}

//MARK ClickStreamConsentHandler Test Cases
extension ClickStreamConsentHandlerTests {
    
    func testClickStreamPostSuccess() {
        givenTheConsentDetails()
        givenConsentDetailsAreStoredWithConsenttypeAndVersion()
    }
    
    func testClickStreamFetchWithoutStore() {
        givenTheConsentDetails()
        whenFetchConsentIsInvoked(consentType: fetchConsent.type)
        thenConsentStatusObjectContainsStatusVersionTimestamp()
    }
    
    func testTimeStampStored() {
        givenTheConsentDetails()
        givenConsentDetailsAreStored(consentType: fetchConsent.type,status: true,version: fetchConsent.version)
        whenFetchConsentIsInvoked(consentType: fetchConsent.type)
        thenConsentStatusObjectContainsTimestamp()
    }
    
    func testClickStreamFetchAfterPost() {
        givenTheConsentDetails()
        givenConsentDetailsAreStored(consentType: fetchConsent.type,status: true,version: fetchConsent.version)
        whenFetchConsentIsInvoked(consentType: fetchConsent.type)
        thenConsentStatusObjectContainsAciveStatus()
    }
    
    func testClickStreamFetchSuccess() {
        givenTheConsentDetails()
        givenConsentDetailsAreStored(consentType: fetchConsent.type,status: false,version: fetchConsent.version)
        whenFetchConsentIsInvoked(consentType: fetchConsent.type)
        thenConsentStatusObjectContainsRejectedStatus()
    }
    
    func testClickStreamVersionUpdateReturnsOldVersion() {
        givenTheConsentDetails()
        givenTheConsentDetailsWithTypeAndVersion()
        givenConsentDetailsAreStored(consentType: fetchConsent.type,status: true,version: fetchConsent.version)
        whenFetchConsentIsInvoked(consentType: fetchConsent1.type)
        thenConsentStatusObjectContainsAciveStatusAndVersion()
    }
    
    func testClickStreamConsentValueUpdate(){
        givenTheConsentDetails()
        givenTheConsentDetailsWithTypeAndVersion()
        givenConsentDetailsAreStored(consentType: fetchConsent.type,status: true,version: fetchConsent.version)
        givenConsentDetailsAreStored(consentType: fetchConsent.type,status: false,version: fetchConsent.version)
        whenFetchConsentIsInvoked(consentType: fetchConsent.type)
        thenConsentStatusObjectContainsRejectedStatus()
    }
    
    private func givenTheConsentDetails(){
        fetchConsent = createConsent()
    }
    
    private func givenTheConsentDetailsWithTypeAndVersion(){
        fetchConsent1 = createConsent(with: CLICKSTREAMCONSENTTYPE, version: 1)
    }
    
    private func givenConsentDetailsAreStored(consentType: String,status: Bool,version: Int){
        clickStreamHandler.storeConsentState(for: consentType,
                                             withStatus: status,
                                             withVersion: version,
                                             completion: {_, _ in })
    }
    
    private func givenConsentDetailsAreStoredWithConsenttypeAndVersion(){
        clickStreamHandler.storeConsentState(for: fetchConsent.type,
                                             withStatus: true,
                                             withVersion: fetchConsent.version,
                                             completion: { (status, error) in
                                                self.thenConsentStatusObjectContainsStatusWithNoError( status: status,error:error)
        })
    }
    
    private func whenFetchConsentIsInvoked(consentType: String){
        clickStreamHandler.fetchConsentTypeState(for: consentType) { (consentStatus, error) in
            self.returnedConsentStatus = consentStatus
        }
    }
    
    private func thenConsentStatusObjectContainsTimestamp(){
        let timestamp = returnedConsentStatus.timestamp
        XCTAssertNotNil(timestamp)
        XCTAssertTrue(timestamp.compare(Date(timeIntervalSince1970: 0)) == ComparisonResult.orderedDescending)
    }
    
    private func thenConsentStatusObjectContainsStatusWithNoError(status: Bool,error: NSError!){
        XCTAssertTrue(status)
        XCTAssertNil(error)
    }
    
    private func thenConsentStatusObjectContainsStatusVersionTimestamp(){
        XCTAssertEqual(returnedConsentStatus.status, .inactive)
        XCTAssertEqual(returnedConsentStatus.version, 0)
        XCTAssertEqual(returnedConsentStatus.timestamp, Date(timeIntervalSince1970: 0))
    }
    
    private func thenConsentStatusObjectContainsAciveStatus(){
        XCTAssertEqual(returnedConsentStatus.status, .active)
    }
    
    private func thenConsentStatusObjectContainsAciveStatusAndVersion(){
        XCTAssertEqual(returnedConsentStatus.status, .active)
        XCTAssertEqual(returnedConsentStatus.version, 1)
    }
    
    private func thenConsentStatusObjectContainsRejectedStatus(){
        XCTAssertEqual(returnedConsentStatus.status, .rejected)
    }
    
}

//MARK Helper methods
extension ClickStreamConsentHandlerTests {
    
    func createConsent(with type: String = "AIL_ClickStream",
                       version: Int = 1) -> DummyConsent {
        return DummyConsent(type: type, version: version)
    }
}

struct DummyConsent {
    var type: String!
    var version: Int!
}
