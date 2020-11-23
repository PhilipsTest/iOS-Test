/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSErrorCreationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testGetECSPILErrorType() {
        let errors = ECSPILHybrisErrors()
        let error = ECSPILHybrisError()
        let errorSource = ECSPILErrorSource()
        errorSource.parameter = "TestParam"
        error.code = "ECSMockError"
        errors.errors = [error]
        XCTAssertEqual(errors.getECSPILErrorType(error: nil), "")
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSMockError")
        
        error.source = errorSource
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSMockError")
        
        error.code = "MockCode"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode")
        
        errorSource.parameter = "[MockParameter]"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode_MockParameter")
        
        errorSource.parameter = "[TestMockError1, TestMockError2]"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode_TestMockError1")
        
        errorSource.parameter = "[TestMockError1 TestMockError2]"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode_TestMockError1 TestMockError2")
        
        errorSource.parameter = "TestMockError1,[TestMockError2]"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode")
        
        errorSource.parameter = "TestMockError1,[TestMockError2]"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode")
        
        errorSource.parameter = "[]"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode")
        
        errorSource.parameter = " [TestMockError2] "
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL_MockCode")
        
        error.code = ""
        errorSource.parameter = "[TestMockError2]"
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "ECSPIL__TestMockError2")
        
        error.code = nil
        XCTAssertEqual(errors.getECSPILErrorType(error: error), "")
    }
    
    func testGetECSErrorType() {
        let error = ECSHybrisError()
        XCTAssertEqual(error.getECSErrorType(type: nil), "")
        XCTAssertEqual(error.getECSErrorType(type: "ECSError"), "ECSError")
        XCTAssertEqual(error.getECSErrorType(type: "TestError"), "ECSTestError")
    }
    
    func testSubjectError() {
        let error = ECSHybrisError()
        XCTAssertEqual(error.subjectError?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
        error.error = "ECSCartEntryError"
        XCTAssertEqual(error.subjectError?.getErrorCode(), ECSHybrisErrorType.ECSCartEntryError.rawValue)
    }
}
