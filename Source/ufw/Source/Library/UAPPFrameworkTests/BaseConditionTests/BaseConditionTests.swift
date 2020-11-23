/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import UAPPFrameworkDev

class BaseConditionTests: XCTestCase {
    
    var condition : BaseCondition?
    
    override func setUp() {
        super.setUp()
        condition = BaseCondition()
    }
    
    func testConditionEqualityCheck(){
        
        let loginFirstObj = LoginCondition()
        let loginSecoundObj = LoginCondition()
        
        XCTAssertNotEqual(loginFirstObj,loginSecoundObj)
    }
    
    func testIsSatisfied() {
        let loginFirstObj = LoginCondition()
        XCTAssertEqual(loginFirstObj.isSatisfied(), true)
    }
    
    func testCorrectInitialisation() {
        XCTAssertNotNil(condition)
    }
}
