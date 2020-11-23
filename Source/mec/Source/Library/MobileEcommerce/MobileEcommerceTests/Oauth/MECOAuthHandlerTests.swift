/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PlatformInterfaces

class MECOAuthHandlerTests: XCTestCase {
    var mockService: MockECSService?
    var mockUserDataInterface: MECMockUserDataInterface?
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        mockService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockService
        MECConfiguration.shared.sharedAppInfra = appInfra
        mockUserDataInterface = MECMockUserDataInterface()
        MECConfiguration.shared.sharedUDInterface = mockUserDataInterface
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }

    override func tearDown() {
        super.tearDown()
        MECConfiguration.shared.oauthData = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.sharedUDInterface = nil
        MECConfiguration.shared.sharedAppInfra = nil
        MECConfiguration.shared.sharedUDInterface = nil
    }

    func testOauthHybrisAlreadyLoggedIn() {
        MECConfiguration.shared.oauthData = ECSOAuthData()
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertTrue(sucess)
            XCTAssertNil(error)
        }
    }
    
    func testOauthHybrisAlreadyAccessTokenNil() {
        MECOAuthHandler.shared.oauthHybris { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 100)
            XCTAssertEqual(error?.domain, MECErrorDomain.MECAuthentication)
        }
    }
    
    func testOauthHybrisSuccess() {
        let mockuserData = MECMockUserDataInterface()
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData = ECSOAuthData()
        mockService?.oAuthData = oauthData
        
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertTrue(sucess)
            XCTAssertEqual(MECConfiguration.shared.oauthData, oauthData)
            XCTAssertNil(error)
        }
    }
    
    func testOAuthHybrisSuccessSavesUserDetail() {
        let testEmail = "1234"
        let mockuserData = MECMockUserDataInterface()
        mockuserData.details = [MECConstants.MECAccessToken: "1234", UserDetailConstants.EMAIL: testEmail]
        mockuserData.loginState = .userLoggedIn
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData = ECSOAuthData()
        mockService?.oAuthData = oauthData
        
        MECOAuthHandler.shared.oauthHybris { [weak self] (sucess, error) in
            XCTAssertNotNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
            XCTAssertEqual((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue, self?.createDummySaveDataWith(value: testEmail))
        }
    }
    
    func testOAuthHybrisSuccessOverridesUserDetail() {
        let testEmail = "1234"
        let oldValues: NSDictionary = ["DummyKey": "DummyValue"]
        let mockuserData = MECMockUserDataInterface()
        mockuserData.details = [MECConstants.MECAccessToken: "1234", UserDetailConstants.EMAIL: testEmail]
        mockuserData.loginState = .userLoggedIn
        MECConfiguration.shared.sharedUDInterface = mockuserData
        (MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue = oldValues
        
        let oauthData = ECSOAuthData()
        mockService?.oAuthData = oauthData
        
        MECOAuthHandler.shared.oauthHybris { [weak self] (sucess, error) in
            XCTAssertNotNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
            XCTAssertNotEqual((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue, oldValues)
            XCTAssertEqual((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue, self?.createDummySaveDataWith(value: testEmail))
        }
    }
    
    func testOAuthHybrisFailureDoesnotSaveUserDetail() {
        let mockuserData = MECMockUserDataInterface()
        let testEmail = "1234"
        
        mockuserData.refreshError = NSError(domain: "Refresh Error", code: 9999, userInfo: nil)
        mockuserData.shouldCallSuccess = false
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [MECConstants.MECAccessToken: "1234", UserDetailConstants.EMAIL: testEmail]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        mockService?.oauthError = NSError(domain: "token expiry", code: 5000, userInfo: nil)
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
        }
    }
    
    func testOAuthHybrisFailureDoesnotOverrideSavedUserDetail() {
        let mockuserData = MECMockUserDataInterface()
        let oldValues: NSDictionary = ["DummyKey": "DummyValue"]
        let testEmail = "1234"
        
        mockuserData.refreshError = NSError(domain: "Refresh Error", code: 9999, userInfo: nil)
        mockuserData.shouldCallSuccess = false
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [MECConstants.MECAccessToken: "1234", UserDetailConstants.EMAIL: testEmail]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        mockService?.oauthError = NSError(domain: "token expiry", code: 5000, userInfo: nil)
        (MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue = oldValues
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertNotNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
            XCTAssertEqual((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue, oldValues)
        }
    }
    
    func testOauthHybrisJanrainTokenExpiryRefreshFailed() {
        let mockuserData = MECMockUserDataInterface()
        
        mockuserData.refreshError = NSError(domain: "Refresh Error", code: 9999, userInfo: nil)
        mockuserData.shouldCallSuccess = false
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        mockService?.oauthError = NSError(domain: "token expiry", code: 5000, userInfo: nil)
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertFalse(sucess)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 9999)
        }
    }
    
    func testPILOauthHybrisJanrainTokenExpiryRefreshFailed() {
        let mockuserData = MECMockUserDataInterface()
        
        mockuserData.refreshError = NSError(domain: "Refresh Error", code: 9999, userInfo: nil)
        mockuserData.shouldCallSuccess = false
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        mockService?.oauthError = NSError(domain: "token expiry", code: 6025, userInfo: nil)
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertFalse(sucess)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 9999)
        }
    }
    
    func testOauthHybrisJanrainTokenExpiryRefreshSuccess() {
        let mockuserData = MECMockUserDataInterface()
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData1 = ECSOAuthData()
        oauthData1.refreshToken = "12345"
        mockService?.oAuthData = oauthData1
        
        mockService?.oauthError = NSError(domain: "token expiry", code: 5000, userInfo: nil)
        mockService?.shouldSendOauthError = true
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertTrue(sucess)
            XCTAssertNil(error)
            XCTAssertEqual(MECConfiguration.shared.oauthData, oauthData1)
        }
    }
    
    func testPILOauthHybrisJanrainTokenExpiryRefreshSuccess() {
        let mockuserData = MECMockUserDataInterface()
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData1 = ECSOAuthData()
        oauthData1.refreshToken = "12345"
        mockService?.oAuthData = oauthData1
        
        mockService?.oauthError = NSError(domain: "token expiry", code: 6025, userInfo: nil)
        mockService?.shouldSendOauthError = true
        MECOAuthHandler.shared.oauthHybris { (sucess, error) in
            XCTAssertTrue(sucess)
            XCTAssertNil(error)
            XCTAssertEqual(MECConfiguration.shared.oauthData, oauthData1)
        }
    }
    
    func testRefreshHybris() {
        MECOAuthHandler.shared.refreshHybris { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNil(error)
        }
    }
    
    func testRefreshHybrisDoesnotOverrideSavedEmailData() {
        let mockuserData = MECMockUserDataInterface()
        let oldValues: NSDictionary = ["DummyKey": "DummyValue"]
        let testEmail = "1234"
        
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [UserDetailConstants.EMAIL: testEmail]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        (MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue = oldValues
        MECOAuthHandler.shared.refreshHybris { (success, error) in
            XCTAssertNotNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
            XCTAssertEqual((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue, oldValues)
        }
    }
    
    func testRefreshHybrisSuccess() {
        
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "1234"
        mockService?.refreshAuthData = oauthData
        
        let oauthData1 = ECSOAuthData()
        oauthData1.refreshToken = "12345"
        
        MECConfiguration.shared.oauthData = oauthData1
        
        MECOAuthHandler.shared.refreshHybris { (sucess, error) in
            XCTAssertTrue(sucess)
            XCTAssertEqual(MECConfiguration.shared.oauthData, oauthData)
            XCTAssertNil(error)
        }
    }
    
    func testRefreshHybrisFailedJanrainTokenExpiryRefreshSuccess() {
        let mockuserData = MECMockUserDataInterface()
        mockuserData.shouldCallSuccess = true
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "12345"
        MECConfiguration.shared.oauthData = oauthData
        
        let oauthData1 = ECSOAuthData()
        oauthData1.refreshToken = "12345"
        mockService?.oAuthData = oauthData1
        
        mockService?.refreshOauthError = NSError(domain: "token expiry", code: 5000, userInfo: nil)
        MECOAuthHandler.shared.refreshHybris(completionHandler: { (sucess, error) in
            XCTAssertTrue(sucess)
            XCTAssertNil(error)
            XCTAssertEqual(MECConfiguration.shared.oauthData, oauthData1)
        })
    }
    
    func testPILRefreshHybrisFailedJanrainTokenExpiryRefreshSuccess() {
        let mockuserData = MECMockUserDataInterface()
        mockuserData.shouldCallSuccess = true
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "12345"
        MECConfiguration.shared.oauthData = oauthData
        
        let oauthData1 = ECSOAuthData()
        oauthData1.refreshToken = "12345"
        mockService?.oAuthData = oauthData1
        
        mockService?.refreshOauthError = NSError(domain: "token expiry", code: 6025, userInfo: nil)
        MECOAuthHandler.shared.refreshHybris(completionHandler: { (sucess, error) in
            XCTAssertTrue(sucess)
            XCTAssertNil(error)
            XCTAssertEqual(MECConfiguration.shared.oauthData, oauthData1)
        })
    }
    
    func testRefreshHybrisFailedJanrainTokenExpiryRefreshFailed() {
        let mockuserData = MECMockUserDataInterface()
        
        mockuserData.refreshError = NSError(domain: "Refresh Error", code: 9999, userInfo: nil)
        mockuserData.shouldCallSuccess = false
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "12345"
        MECConfiguration.shared.oauthData = oauthData
        
        mockService?.refreshOauthError = NSError(domain: "token expiry", code: 5000, userInfo: nil)
        MECOAuthHandler.shared.refreshHybris(completionHandler: { (sucess, error) in
            XCTAssertFalse(sucess)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 9999)
        })
    }
    
    func testPILRefreshHybrisFailedJanrainTokenExpiryRefreshFailed() {
        let mockuserData = MECMockUserDataInterface()
        
        mockuserData.refreshError = NSError(domain: "Refresh Error", code: 9999, userInfo: nil)
        mockuserData.shouldCallSuccess = false
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "12345"
        MECConfiguration.shared.oauthData = oauthData
        
        mockService?.refreshOauthError = NSError(domain: "token expiry", code: 6025, userInfo: nil)
        MECOAuthHandler.shared.refreshHybris(completionHandler: { (sucess, error) in
            XCTAssertFalse(sucess)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 9999)
        })
    }
    
    func testRefreshHybrisFailedOtherError() {
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "12345"
        MECConfiguration.shared.oauthData = oauthData
        
        mockService?.refreshOauthError = NSError(domain: "token expiry", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Token expired"])
        MECOAuthHandler.shared.refreshHybris(completionHandler: { (sucess, error) in
            XCTAssertFalse(sucess)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 1000)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:hybrisOAuthAuthenticationWith:Hybris:Token expired:1000")
        })
    }
    
    func testSaveUserEmailInformationSuccess() {
        let testEmail = "TestEmail"
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: testEmail]
        MECUtility.saveUserEmailInformation()
        XCTAssertEqual((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue, createDummySaveDataWith(value: testEmail))
    }
    
    func testSaveUserEmailInformationFailure() {
        let testEmail = "TestEmail"
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: testEmail]
        (MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storeError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "read failed"])
        MECUtility.saveUserEmailInformation()
        XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
        XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:appError:other:read failed:123")
        XCTAssertNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
    }
    
    func testSaveUserEmailInformationWithNoEmail() {
        MECUtility.saveUserEmailInformation()
        XCTAssertNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
    }
    
    func testSaveUserEmailInformationWithBlankEmail() {
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: ""]
        MECUtility.saveUserEmailInformation()
        XCTAssertNil((MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider)?.storedValue)
    }
    
    func testShouldAuthenticateWithHybrisEmailMismatch() {
        let savedTestEmail = "TestEmail"
        let newTestEmail = "NewTestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: newTestEmail]
        mockStorageProvider?.fetchedValue = createDummyEmailDataWith(value: savedTestEmail)
        XCTAssertTrue(MECUtility.shouldAuthenticateWithHybris())
    }
    
    func testShouldAuthenticateWithHybrisEmailMatch() {
        let testEmail = "TestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: testEmail]
        mockStorageProvider?.fetchedValue = createDummyEmailDataWith(value: testEmail)
        XCTAssertFalse(MECUtility.shouldAuthenticateWithHybris())
    }
    
    func testShouldAuthenticateWithHybrisEmailMatchCaseInsensitive() {
        let savedTestEmail = "TestEmail"
        let newTestEmail = "testemail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: newTestEmail]
        mockStorageProvider?.fetchedValue = createDummyEmailDataWith(value: savedTestEmail)
        XCTAssertFalse(MECUtility.shouldAuthenticateWithHybris())
    }
    
    func testShouldAuthenticateWithHybrisEmailForNotLoggedIn() {
        let savedTestEmail = "TestEmail"
        let newTestEmail = "NewTestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userNotLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: newTestEmail]
        mockStorageProvider?.fetchedValue = createDummyEmailDataWith(value: savedTestEmail)
        XCTAssertFalse(MECUtility.shouldAuthenticateWithHybris())
    }
    
    func testShouldAuthenticateWithHybrisEmailForBlankNewEmail() {
        let savedTestEmail = "TestEmail"
        let newTestEmail = ""
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: newTestEmail]
        mockStorageProvider?.fetchedValue = createDummyEmailDataWith(value: savedTestEmail)
        XCTAssertTrue(MECUtility.shouldAuthenticateWithHybris())
    }

    func testShouldAuthenticateWithHybrisEmailForNilNewEmail() {
        let savedTestEmail = "TestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userLoggedIn
        mockStorageProvider?.fetchedValue = createDummyEmailDataWith(value: savedTestEmail)
        XCTAssertTrue(MECUtility.shouldAuthenticateWithHybris())
    }

    func testShouldAuthenticateWithHybrisEmailForBlankSavedEmail() {
        let savedTestEmail = ""
        let newTestEmail = "NewTestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: newTestEmail]
        mockStorageProvider?.fetchedValue = createDummyEmailDataWith(value: savedTestEmail)
        XCTAssertTrue(MECUtility.shouldAuthenticateWithHybris())
    }
    
    func testShouldAuthenticateWithHybrisEmailForNilSavedEmail() {
        let newTestEmail = "NewTestEmail"
        mockUserDataInterface?.loginState = .userLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: newTestEmail]
        XCTAssertTrue(MECUtility.shouldAuthenticateWithHybris())
    }

    func testShouldAuthenticateWithHybrisEmailError() {
        let newTestEmail = "NewTestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        mockUserDataInterface?.loginState = .userLoggedIn
        mockUserDataInterface?.details = [UserDetailConstants.EMAIL: newTestEmail]
        mockStorageProvider?.fetchError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "read error"])
        XCTAssertTrue(MECUtility.shouldAuthenticateWithHybris())
        XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
        XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:appError:other:read error:123")
    }
}

extension MECOAuthHandlerTests {
    
    func createDummySaveDataWith(value: String) -> NSDictionary {
        let valueDict = createDummyEmailDataWith(value: value)
        let mainDict: NSDictionary = [MECConstants.MECUSEROAUTHDATASAVEKEY: valueDict]
        return mainDict
    }
    
    func createDummyEmailDataWith(value: String) -> NSDictionary {
        let emailDict: NSDictionary = [MECConstants.MECUSEROAUTHEMAILDATASAVEKEY: value]
        return emailDict
    }
}
