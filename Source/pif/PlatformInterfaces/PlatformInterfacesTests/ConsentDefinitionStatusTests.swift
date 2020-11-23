import XCTest
@testable import PlatformInterfacesDev

class ConsentDefinitionStatusTests: XCTestCase {
    
    func testEquality() {
        let activeConsentStatus = ConsentStates.active
        let inSyncVersionStatus = ConsentVersionStates.inSync
        let momentConsentDefinition = ConsentDefinition(type: "moment, insight, clickstream", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        
        let consentDefinitionStatus1 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus2 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus3 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        XCTAssertTrue(consentDefinitionStatus1 == consentDefinitionStatus2)
        XCTAssertTrue(consentDefinitionStatus1 == consentDefinitionStatus3)
        XCTAssertTrue(consentDefinitionStatus2 == consentDefinitionStatus3)
    }
    
    func testUnEqualityForConsentDefinitions() {
        let activeConsentStatus = ConsentStates.active
        let inSyncVersionStatus = ConsentVersionStates.inSync
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let insightConsentDefinition = ConsentDefinition(type: "insight", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let clickStreamConsentDefinition = ConsentDefinition(type: "clickstream", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        
        let consentDefinitionStatus1 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus2 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: insightConsentDefinition)
        let consentDefinitionStatus3 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: clickStreamConsentDefinition)
        XCTAssertFalse(consentDefinitionStatus1 == consentDefinitionStatus2)
        XCTAssertFalse(consentDefinitionStatus1 == consentDefinitionStatus3)
        XCTAssertFalse(consentDefinitionStatus2 == consentDefinitionStatus3)
    }
    
    func testUnEqualityForVersions() {
        let activeConsentStatus = ConsentStates.active
        let inSyncVersionStatus = ConsentVersionStates.inSync
        let appVersionIsHigher = ConsentVersionStates.appVersionIsHigher
        let appVersionIsLower = ConsentVersionStates.appVersionIsLower
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        
        let consentDefinitionStatus1 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus2 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:appVersionIsHigher, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus3 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:appVersionIsLower, consentDefinition: momentConsentDefinition)
        XCTAssertFalse(consentDefinitionStatus1 == consentDefinitionStatus2)
        XCTAssertFalse(consentDefinitionStatus1 == consentDefinitionStatus3)
        XCTAssertFalse(consentDefinitionStatus2 == consentDefinitionStatus3)
    }
    
    func testUnEqualityForStatus() {
        let activeConsentStatus = ConsentStates.active
        let inactiveStatus = ConsentStates.inactive
        let rejectedStatus = ConsentStates.rejected
        let inSyncVersionStatus = ConsentVersionStates.inSync
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        
        let consentDefinitionStatus1 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus2 = ConsentDefinitionStatus(status: inactiveStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus3 = ConsentDefinitionStatus(status: rejectedStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        XCTAssertFalse(consentDefinitionStatus1 == consentDefinitionStatus2)
        XCTAssertFalse(consentDefinitionStatus1 == consentDefinitionStatus3)
        XCTAssertFalse(consentDefinitionStatus2 == consentDefinitionStatus3)
    }
    
    func testCombiningConsentStatusCombining() {
        let inactiveConsentStatus = ConsentStates.inactive
        let activeConsentStatus = ConsentStates.active
        let rejectedConsentStatus = ConsentStates.rejected
        
        let inSyncVersionStatus = ConsentVersionStates.inSync
        let appVersionHigherStatus = ConsentVersionStates.appVersionIsHigher
        let appVersionLowerStatus = ConsentVersionStates.appVersionIsLower
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        
        let consentDefinitionStatus_activeStatus_InSyncVersion = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus_inactiveStatus_AppVersionHigher = ConsentDefinitionStatus(status: inactiveConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus_rejectedStatus_AppVersionLower = ConsentDefinitionStatus(status: rejectedConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition)
        
        var consentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_activeStatus_InSyncVersion, consentDefinitionStatus2: consentDefinitionStatus_inactiveStatus_AppVersionHigher)
        XCTAssertNotNil(consentDefinitionStatus)
        XCTAssert(consentDefinitionStatus?.status == inactiveConsentStatus)
        
        consentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_rejectedStatus_AppVersionLower, consentDefinitionStatus2: consentDefinitionStatus_inactiveStatus_AppVersionHigher)
        XCTAssertNotNil(consentDefinitionStatus)
        XCTAssert(consentDefinitionStatus?.status == rejectedConsentStatus)
        
        consentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_inactiveStatus_AppVersionHigher, consentDefinitionStatus2: consentDefinitionStatus_rejectedStatus_AppVersionLower)
        XCTAssertNotNil(consentDefinitionStatus)
        XCTAssert(consentDefinitionStatus?.status == rejectedConsentStatus)
    }
    
    func testCombiningVersionStatusCombining() {
        let inactiveConsentStatus = ConsentStates.inactive
        let activeConsentStatus = ConsentStates.active
        let rejectedConsentStatus = ConsentStates.rejected
        
        let inSyncVersionStatus = ConsentVersionStates.inSync
        let appVersionHigherStatus = ConsentVersionStates.appVersionIsHigher
        let appVersionLowerStatus = ConsentVersionStates.appVersionIsLower
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        
        let consentDefinitionStatus_activeStatus_InSyncVersion = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus_inactiveStatus_AppVersionHigher = ConsentDefinitionStatus(status: inactiveConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition)
        let consentDefinitionStatus_rejectedStatus_AppVersionLower = ConsentDefinitionStatus(status: rejectedConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition)
        
        var consentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_activeStatus_InSyncVersion, consentDefinitionStatus2: consentDefinitionStatus_inactiveStatus_AppVersionHigher)
        XCTAssertNotNil(consentDefinitionStatus)
        XCTAssert(consentDefinitionStatus?.versionStatus == appVersionHigherStatus)
        
        consentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_activeStatus_InSyncVersion, consentDefinitionStatus2: consentDefinitionStatus_activeStatus_InSyncVersion)
        XCTAssertNotNil(consentDefinitionStatus)
        XCTAssert(consentDefinitionStatus?.versionStatus == inSyncVersionStatus)
        
        consentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_inactiveStatus_AppVersionHigher, consentDefinitionStatus2: consentDefinitionStatus_rejectedStatus_AppVersionLower)
        XCTAssertNotNil(consentDefinitionStatus)
        XCTAssert(consentDefinitionStatus?.versionStatus == appVersionLowerStatus)
    }
    
    func testCombiningConsentDefinitionsWithVersionAndLatModifedDate() {
        givenTheConsentDefinitionStatuses()
        whenConsentDefinitionStatusesAreCombined()
        thenValidConsentDefinitionsWithRecentLastModifiedDatesAndLatestVersionAreCombined()
    }
    
    func testCombiningConsentDefinitionsWithLatModifedDate() {
        givenTheConsentDefinitionStatuses()
        whenConsentDefinitionStatusesAreCombined()
        thenValidConsentDefinitionsWithRecentLastModifiedDatesAreCombined()
    }
    
    func testCombiningConsentDefinitionsWithLatModifedDate_Version_State() {
        givenTheConsentDefinitionStatuses()
        whenConsentDefinitionStatusesWithOneRejectedStateAreCompared()
        thenValidConsentDefinitionsWithRecentLastModifiedDatesAndLatestVersionAndStatusAreCombined()
    }
    
    func testCombiningConsentDefinitionsWithLatModifedDate_Version_StateForInactive_RecentDate() {
        givenTheConsentDefinitionStatuses()
        whenConsentDefinitionStatusesWithInactiveLowerVersionVSactiveHigherversionRecentDate()
        thenValidConsentDefinitionsWithRecentLastModifiedDates_LatestVersionAndStatusAreCombined()
    }
    
    func testEqualityWithIdenticalLastModifiedTimestamp() {
        let date =  Date(timeIntervalSince1970: 1000)
        givenTheConsentStatusWithTimestamps(date1: date, date2: date)
        thenConsentStatusFoundIdentical()
    }
    
    func testEqualityWithNonIdenticalLastModifiedTimestamp() {
        let date1 =  Date(timeIntervalSince1970: 1000000000)
        let date2 = Date(timeIntervalSince1970: 2000000000)
        givenTheConsentStatusWithTimestamps(date1: date1, date2: date2)
        thenConsentStatusFoundNonIdentical()
    }
    
    func testEqualityWithIdenticalTimestamp() {
        let date =  Date(timeIntervalSince1970: 1000)
        givenMomentConsentDefinition();
        givenTheConsentDefinitionsWithTimestamps(date1: date, date2: date)
        thenConsentDefinitionsFoundIdentical()
    }
    
    func testEqualityWithNonIdenticalTimestamp() {
        let date1 =  Date(timeIntervalSince1970: 1000000000)
        let date2 = Date(timeIntervalSince1970: 2000000000)
        givenMomentConsentDefinition();
        givenTheConsentDefinitionsWithTimestamps(date1: date1, date2: date2)
        thenConsentDefinitionsFoundNonIdentical()
    }
    
    func testCombiningConsentDefinitionStatusWithActiveLowerVersionRecent_VS_InactiveHigherVersionOlder(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: activeConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: inactiveConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithInactiveLowerVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithActiveInSyncVersionOlder_VS_RejectedLowerVersionRecent(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: activeConsentStatus, versionStatus: inSyncVersionStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: rejectedConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithRejectedLowerVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithActiveLowerVersionRecent_VS_RejectedInSyncVersionOlder(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: activeConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: rejectedConsentStatus, versionStatus: inSyncVersionStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithRejectedLowerVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithInactiveLowerVersionOlder_VS_RejectedHigherVersionRecent(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: activeConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: rejectedConsentStatus, versionStatus: inSyncVersionStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithRejectedLowerVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithInactiveInSyncVersionRecent_VS_RejectedLowerVersionOlder(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: inactiveConsentStatus, versionStatus: inSyncVersionStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: rejectedConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithRejectedLowerVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithActiveHeigherVersionOlder_VS_InactiveHigherVersionRecent(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: activeConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: inactiveConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithInActiveHeigherVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithActiveLowerVersionOlder_VS_InactiveInSyncVersionRecent(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: activeConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: inactiveConsentStatus, versionStatus: inSyncVersionStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithInactiveLowerVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithInactiveInSyncVersionOlder_VS_InactiveLowerVersionRecent(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: inactiveConsentStatus, versionStatus: inSyncVersionStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: inactiveConsentStatus, versionStatus: appVersionLowerStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithInactiveLowerVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    func testCombiningConsentDefinitionStatusWithActiveInSyncVersionRecent_VS_InactiveHigherVersionOlder(){
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        momentConsentDefinition = ConsentDefinition(type: "moment", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
        let lhs = givenConsentDefinition(status: activeConsentStatus, versionStatus: inSyncVersionStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: recentDate)
        let rhs: ConsentDefinitionStatus = givenConsentDefinition(status: inactiveConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition, lastModifiedTimestamp: oldDate)
        whenConsentDefinitionStatusesAreCompared(lhs: lhs,rhs: rhs)
        thenValidConsentDefinitionsWithInActiveHeigherVersionRecentAreCombined(lhs: lhs,rhs: rhs)
    }
    
    private func givenConsentDefinition(status: ConsentStates, versionStatus: ConsentVersionStates, consentDefinition: ConsentDefinition, lastModifiedTimestamp:Date) -> ConsentDefinitionStatus{
        let  consentDefinitionStatus = ConsentDefinitionStatus(status: status, versionStatus: versionStatus, consentDefinition: consentDefinition,lastModifiedTimestamp:lastModifiedTimestamp)
        return consentDefinitionStatus
    }
    
    private func whenConsentDefinitionStatusesAreCompared(lhs:ConsentDefinitionStatus,rhs:ConsentDefinitionStatus){
        resultantConsentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: lhs, consentDefinitionStatus2: rhs)
    }
    
    private func thenValidConsentDefinitionsWithInactiveLowerVersionRecentAreCombined(lhs:ConsentDefinitionStatus,rhs:ConsentDefinitionStatus){
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.lastModifiedTimestamp == recentDate)
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.versionStatus == appVersionLowerStatus)
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.status == ConsentStates.inactive)
        
    }
    
    private func thenValidConsentDefinitionsWithRejectedLowerVersionRecentAreCombined(lhs:ConsentDefinitionStatus,rhs:ConsentDefinitionStatus){
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.lastModifiedTimestamp == recentDate)
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.versionStatus == appVersionLowerStatus)
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.status == ConsentStates.rejected)
    }
    
    private func thenValidConsentDefinitionsWithInActiveHeigherVersionRecentAreCombined(lhs:ConsentDefinitionStatus,rhs:ConsentDefinitionStatus){
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.lastModifiedTimestamp == recentDate)
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.versionStatus == appVersionHigherStatus)
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.status == ConsentStates.inactive)
    }
    private func givenTheConsentDefinitionStatuses(){
        givenMomentConsentDefinition();
        oldDate = Date(timeIntervalSince1970: 1000)
        recentDate = Date(timeIntervalSince1970: 1000000000)
        consentDefinitionStatus_activeStatus_InSyncVersion = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition)
        consentDefinitionStatus_inactiveStatus_AppVersionHigher = ConsentDefinitionStatus(status: inactiveConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:recentDate)
        consentDefinitionStatus_rejectedStatus_AppVersionHigher = ConsentDefinitionStatus(status: rejectedConsentStatus, versionStatus: appVersionHigherStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:oldDate)
        consentDefinitionStatus_activeStatus_InSyncVersion_recentLastModifedDate = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:recentDate)
        consentDefinitionStatus_activeStatus_InSyncVersion_olderLastModifedDate = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:oldDate)
    }
    
    private func givenTheConsentStatusWithTimestamps(date1:Date,date2:Date){
        self.date1 = date1
        self.date2 = date2
    }
    
    private func thenConsentStatusFoundIdentical(){
        let  consentStatus1 = ConsentStatus(status: .active, version: 10, timestamp:date1)
        let  consentStatus2 = ConsentStatus(status: .active, version: 10, timestamp:date2)
        XCTAssertTrue(consentStatus1 == consentStatus2)
    }
    
    private func thenConsentStatusFoundNonIdentical(){
        let  consentStatus1 = ConsentStatus(status: .active, version: 10, timestamp:date1)
        let  consentStatus2 = ConsentStatus(status: .active, version: 10, timestamp:date2)
        XCTAssertFalse(consentStatus1 == consentStatus2)
    }
    
    private func givenTheConsentDefinitionsWithTimestamps(date1:Date,date2:Date){
        self.date1 = date1
        self.date2 = date2
        
    }
    
    private func givenMomentConsentDefinition(){
        momentConsentDefinition = ConsentDefinition(type: "moment, insight, clickstream", text: "Sample", helpText: "Sample", version: 1, locale: "en-US")
    }
    
    private func thenConsentDefinitionsFoundIdentical(){
        let  consentDefinitionStatus1 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:date1)
        let  consentDefinitionStatus2 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:date2)
        XCTAssertTrue(consentDefinitionStatus1 == consentDefinitionStatus2)
    }
    
    private func thenConsentDefinitionsFoundNonIdentical(){
        let  consentDefinitionStatus1 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:date1)
        let  consentDefinitionStatus2 = ConsentDefinitionStatus(status: activeConsentStatus, versionStatus:inSyncVersionStatus, consentDefinition: momentConsentDefinition,lastModifiedTimestamp:date2)
        XCTAssertFalse(consentDefinitionStatus1 == consentDefinitionStatus2)
    }
    
    private func whenConsentDefinitionStatusesAreCombined(){
        resultantConsentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_activeStatus_InSyncVersion_recentLastModifedDate, consentDefinitionStatus2: consentDefinitionStatus_activeStatus_InSyncVersion_olderLastModifedDate)
    }
    
    private func whenConsentDefinitionStatusesWithOneRejectedStateAreCompared(){
        resultantConsentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_activeStatus_InSyncVersion_recentLastModifedDate, consentDefinitionStatus2: consentDefinitionStatus_rejectedStatus_AppVersionHigher)
    }
    
    private func whenConsentDefinitionStatusesWithInactiveLowerVersionVSactiveHigherversionRecentDate(){
        resultantConsentDefinitionStatus = ConsentDefinitionStatus.combine(consentDefinitionStatus1: consentDefinitionStatus_inactiveStatus_AppVersionHigher, consentDefinitionStatus2: consentDefinitionStatus_activeStatus_InSyncVersion_recentLastModifedDate)
    }
    
    private func thenValidConsentDefinitionsWithRecentLastModifiedDatesAreCombined(){
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.lastModifiedTimestamp == recentDate)
    }
    
    private func thenValidConsentDefinitionsWithRecentLastModifiedDatesAndLatestVersionAreCombined(){
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.lastModifiedTimestamp == recentDate)
        
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.versionStatus == inSyncVersionStatus)
    }
    
    private func thenValidConsentDefinitionsWithRecentLastModifiedDatesAndLatestVersionAndStatusAreCombined(){
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.lastModifiedTimestamp == recentDate)
        
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.versionStatus == appVersionHigherStatus)
        
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.status == ConsentStates.rejected)
        
    }
    
    private func thenValidConsentDefinitionsWithRecentLastModifiedDates_LatestVersionAndStatusAreCombined(){
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.lastModifiedTimestamp == recentDate)
        
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.versionStatus == appVersionHigherStatus)
        
        XCTAssertNotNil(resultantConsentDefinitionStatus)
        XCTAssert(resultantConsentDefinitionStatus?.status == ConsentStates.inactive)
        
    }
    
    
    func testConsentCreation() {
        whenConsentStatusInstantiated()
        thenConsentStatusCreated()
    }
    
    private func createConsentStatus(){
        consentStatus = ConsentStatus(status: .active, version: 10, timestamp:Date(timeIntervalSince1970: 1234))
        
    }
    
    private func whenConsentStatusInstantiated(){
        createConsentStatus()
    }
    
    private func thenConsentStatusCreated(){
        XCTAssertNotNil(consentStatus)
    }
    
    func testConsentEquality() {
        givenConsentStatusIsCreated()
        whenConsentsAreCompared()
        thenConsentsAreSame()
    }
    
    private func givenConsentStatusIsCreated(){
        createConsentStatus()
    }
    
    private func whenConsentsAreCompared(){
        consentsAreSame = (consentStatus == consentStatus)
    }
    
    private func thenConsentsAreSame(){
        XCTAssertTrue(consentsAreSame)
    }
    
    var consentStatus,consentStatus1:ConsentStatus!
    var consentsAreSame,consentDefinitionsAreSame : Bool!
    var consentDefinitionStatus_activeStatus_InSyncVersion:ConsentDefinitionStatus!
    var consentDefinitionStatus_inactiveStatus_AppVersionHigher:ConsentDefinitionStatus!
    var consentDefinitionStatus_rejectedStatus_AppVersionHigher:ConsentDefinitionStatus!
    
    var consentDefinitionStatus_activeStatus_InSyncVersion_recentLastModifedDate:ConsentDefinitionStatus!
    var consentDefinitionStatus_activeStatus_InSyncVersion_olderLastModifedDate:ConsentDefinitionStatus!
    var consentDefinitionStatus_activeStatus_AppVersionLower_Recent:ConsentDefinitionStatus!
    var consentDefinitionStatus_inactiveStatus_AppVersionHigher_Older:ConsentDefinitionStatus!
    
    var resultantConsentDefinitionStatus :ConsentDefinitionStatus!
    var oldDate:Date!
    var recentDate:Date!
    let inSyncVersionStatus = ConsentVersionStates.inSync
    let appVersionHigherStatus = ConsentVersionStates.appVersionIsHigher
    let appVersionLowerStatus = ConsentVersionStates.appVersionIsLower
    let inactiveConsentStatus = ConsentStates.inactive
    let activeConsentStatus = ConsentStates.active
    let rejectedConsentStatus = ConsentStates.rejected
    var momentConsentDefinition:ConsentDefinition!
    var consentDefinitionStatus1,consentDefinitionStatus2 : ConsentDefinitionStatus!
    var date1,date2:Date!
    
}
