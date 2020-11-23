/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PlatformInterfaces
@testable import MobileEcommerceDev

class MECNotifyMePresenterTests: XCTestCase {
    
    var notifyMePresenter: MECNotifyMePresenter!
    var mockECSService: MockECSService?

    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        notifyMePresenter = MECNotifyMePresenter()
        mockECSService = MockECSService(appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockECSService
    }

    override func tearDown() {
        super.tearDown()
        notifyMePresenter = nil
        mockECSService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.sharedUDInterface = nil
    }
    
    func testRegisterForStockNotificationForCTNSuccess() {
        mockECSService?.notifyMeSuccess = true
        mockECSService?.notifyMeError = nil
        notifyMePresenter.registerForStockNotificationFor(ctn: "Test CTN", email: "Test Email") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
        }
    }
    
    func testRegisterForStockNotificationForCTNError() {
        mockECSService?.notifyMeError = NSError(domain: "", code: 123, userInfo: nil)
        notifyMePresenter.registerForStockNotificationFor(ctn: "Test CTN", email: "Test Email") { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
        }
    }
    
    func testFetchUserEmail() {
        let mockUserDetails = MECMockUserDataInterface()
        mockUserDetails.details[UserDetailConstants.EMAIL] = "Test Email"
        MECConfiguration.shared.sharedUDInterface = mockUserDetails
        
        XCTAssertEqual(notifyMePresenter.fetchUserEmail(), "Test Email")
        
        mockUserDetails.details[UserDetailConstants.EMAIL] = ""
        XCTAssertEqual(notifyMePresenter.fetchUserEmail(), "")
        
        mockUserDetails.details[UserDetailConstants.EMAIL] = nil
        XCTAssertEqual(notifyMePresenter.fetchUserEmail(), "")
        
        MECConfiguration.shared.sharedUDInterface = nil
        XCTAssertEqual(notifyMePresenter.fetchUserEmail(), "")
    }
}
