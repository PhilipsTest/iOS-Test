//
//  NSDateExtensionTest.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class NSDateExtensionTest: XCTestCase {
    
    var dateFormatter:DateFormatter?
    
    override func setUp() {
        super.setUp()
        dateFormatter = DateFormatter()
        dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
    }
    
    func testStringFromDateWithddMMyyyy() {
        let format = "yyyy:MM:dd"
        let formatter = dateFormatterWith(format)
        
        let actualDateString = "2016:02:26"
        let date = formatter.date(from: actualDateString)
        
        let resultDateString = date!.stringDateWith(format)
        XCTAssertEqual(resultDateString, actualDateString)
    }
    
    func testStringFromDateWithddMMyyyyHHmmss() {
        let format = "yyyy:MM:dd HH:mm:ss"
        let formatter = dateFormatterWith(format)
        
        let actalDateString = "2016:02:26 21:30:13"
        let date = formatter.date(from: actalDateString)
        
        let resultDateString = date!.stringDateWith(format)
        
        XCTAssertEqual(resultDateString, actalDateString)
    }

    func testStringFromDateForCurrentDate() {
        let format = "yyyy:MM:dd HH:mm:ss"
        let formatter = dateFormatterWith(format)
        
        let actalDateString = formatter.string(from: Date())
        let date = formatter.date(from: actalDateString)
        
        let resultDateString = date!.stringDateWith(format)
        
        XCTAssertEqual(resultDateString, actalDateString)

    }
    
    func testDateWithParam() {
        var dateComponent = DateComponents()
        dateComponent.era = 1
        dateComponent.day = 1
        dateComponent.month = 1
        dateComponent.year = 2000
        dateComponent.hour = 0
        dateComponent.minute = 0
        dateComponent.second = 0
        
        let date: Date = Date().dateWith(dateComponent)!
        XCTAssertEqual(date.stringDateWith("yyyy-MM-dd HH:mm:ss"), "2000-01-01 00:00:00")
    }
    
    func testCompareDatesWithLessThan() {
        let date = Date().addingTimeInterval(-20)
        
        XCTAssertTrue(date.compare(Date()) == ComparisonResult.orderedAscending)
        XCTAssertFalse(date.compare(Date()) == ComparisonResult.orderedDescending)
        XCTAssertFalse(date.compare(Date()) == ComparisonResult.orderedSame)
    }
    
    func testCompareDatesWithGreaterThan() {
        let date = Date().addingTimeInterval(20)
        XCTAssertTrue(date.compare(Date()) == ComparisonResult.orderedDescending)
        XCTAssertFalse(date.compare(Date()) == ComparisonResult.orderedAscending)
        XCTAssertFalse(date.compare(Date()) == ComparisonResult.orderedSame)
 }
    
    func testRegistrationLongDate() {
        let  stringDate = "2013-12-03 00:00:00 +0000"
        let dateFormatter = self.dateFormatterWith("yyyy-MM-dd HH:mm:ss zz")
        let date = Date.registrationLongDateFrom(stringDate)
        XCTAssertEqual(date, dateFormatter.date(from: stringDate))
    }
    
    func testRegistrationShortDate() {
        let stringDate = "2013-12-03"
        let dateFormatter = self.dateFormatterWith("yyyy-MM-dd")
        let expectedDate = Date.registrationShortDateFrom(stringDate)
        let actualDate = dateFormatter.date(from: stringDate)
        XCTAssertEqual(expectedDate, actualDate)
    }
    
    func testCompareDatesWithEqual() {
        let dateOne = Date()
        let dateTwo = dateOne
        
        XCTAssertTrue(dateOne.compare(dateTwo) == ComparisonResult.orderedSame)
        XCTAssertFalse(dateOne.compare(dateTwo) == ComparisonResult.orderedAscending)
        XCTAssertFalse(dateOne.compare(dateTwo) == ComparisonResult.orderedDescending)
    }
    
    fileprivate func dateFormatterWith(_ format:String)->DateFormatter {
        dateFormatter!.dateFormat = format
        dateFormatter!.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter!
    }
    
}
