//
//  AINetworkTimeTests.swift
//  AppInfraTests
//
//  Created by philips on 9/20/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import XCTest
import TrueTime
@testable import AppInfra

class AINetworkTimeTests: XCTestCase {
    
    var aiTimeSync: AINetworkTime?
    
    func testUtcTime() {
        aiTimeSync = AINetworkTime.init()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            formatter.timeZone = aZone as TimeZone
        }
        let now = Date()
        let dateAsString = formatter.string(from: now)
        
        let utcTime: Date? = aiTimeSync?.getUTCTime()
        var utcAsString: String? = nil
        if let aTime = utcTime {
            utcAsString = formatter.string(from: aTime)
        }
        XCTAssertEqual(dateAsString, utcAsString)
    }
    
    func testNtpHostsGivingValues() {
        aiTimeSync = AINetworkTime.init()
        XCTAssertEqual(aiTimeSync?.ntpHosts, giveUrlsFromNtp())
    }
    
    func testNtpHostsGivigValuesOnceSet() {
        aiTimeSync = AINetworkTime.init()
        aiTimeSync?.setNtpHosts(hostURLs: ["test"])
        XCTAssertEqual(aiTimeSync?.ntpHosts, ["test"])
    }
    
    func testSecondTimeCallingShouldBeGiveOldValue() {
        aiTimeSync = AINetworkTime.init()
        aiTimeSync?.setNtpHosts(hostURLs: ["test"])
        XCTAssertEqual(aiTimeSync?.ntpHosts, ["test"])
        _ = aiTimeSync?.ntpHost()
        XCTAssertEqual(aiTimeSync?.ntpHosts,["test"])
    }
    
    func giveUrlsFromNtp() -> [String] {
        let arrayOfUrls = ["time.apple.com","0.pool.ntp.org","0.uk.pool.ntp.org","0.us.pool.ntp.org","asia.pool.ntp.org","time1.google.com"]
        return arrayOfUrls
    }
    
    func testIsSyncronizedToTrue() {
        aiTimeSync = AINetworkTime.init()
        aiTimeSync?.refreshTime()
        aiTimeSync?.setIsSync(with: true)
        XCTAssertEqual(aiTimeSync?.isSynchronized(), true)
    }
    
    func testIsSyncronizedToFalse() {
        aiTimeSync = AINetworkTime.init()
        aiTimeSync?.refreshTime()
        aiTimeSync?.setIsSync(with: false)
        XCTAssertEqual(aiTimeSync?.isSynchronized(), false)
    }
    
    func testDeinit() {
        aiTimeSync = AINetworkTime.init()
        aiTimeSync = nil
    }
    
    func testbundleValue() {
        Bundle.loadSwizzler()
        aiTimeSync = AINetworkTime.init()
        XCTAssertEqual(aiTimeSync?.ntpHosts, ["time.apple.com","0.pool.ntp.org",""])
        Bundle.deSwizzele()
    }
    
    func testUtcTimeWithMock() {
        aiTimeSync = AINetworkTime.init()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let now = Date()
        let trueTimeMock = TrueTimeMock.init(date: now, isSync: true)
        trueTimeMock.setrefernceTime()
        aiTimeSync?.client = trueTimeMock
        let utcTime: Date? = aiTimeSync?.getUTCTime()
        let dateAsString = formatter.string(from: (trueTimeMock.referenceTime?.now())! )
        var utcAsString: String? = nil
        if let aTime = utcTime {
            utcAsString = formatter.string(from: aTime)
        }
        XCTAssertEqual(dateAsString,utcAsString)
    }
    
    func testRefereshTimeSetSyncToTrue() {
        aiTimeSync = AINetworkTime.init()
        aiTimeSync?.client = TrueTimeMock(date: Date(), isSync: true)
        aiTimeSync?.refreshTime()
        XCTAssertEqual(aiTimeSync?.isSynchronised, true)
    }
    
    func testRefereshTimeSetSyncToFalse() {
        aiTimeSync = AINetworkTime.init()
        aiTimeSync?.client = TrueTimeMock(date: Date(), isSync: false)
        aiTimeSync?.refreshTime()
        XCTAssertEqual(aiTimeSync?.isSynchronised, false)
    }
    
    
    func testTimeUpdateToTrue() {
        aiTimeSync = AINetworkTime.init()
        let now = Date()
        let trueTimeMock = TrueTimeMock.init(date: now, isSync: true)
        trueTimeMock.setrefernceTime()
        aiTimeSync?.client = trueTimeMock
        aiTimeSync?.isSynchronised = false
        aiTimeSync?.timeUpdated()
        XCTAssertTrue((aiTimeSync?.isSynchronised)!)
    }
    
    func testTimeUpdateToFalse() {
        aiTimeSync = AINetworkTime.init()
        let trueTimeMock = TrueTimeMockWithReferenceTimeToNil()
        aiTimeSync?.client = trueTimeMock
        aiTimeSync?.isSynchronised = true
        aiTimeSync?.timeUpdated()
        XCTAssertFalse((aiTimeSync?.isSynchronised)!)
    }
    
}

extension AINetworkTime {
    
    public func setNtpHosts(hostURLs : [String]) {
        self.ntpHosts = hostURLs
    }
    
    public func setIsSync(with value: Bool) {
        self.isSynchronised = value
    }
}

class TrueTimeMock : TrueTimeProtocol {
    
    var date : Date?
    var sync : Bool = false
    
    init(date: Date, isSync: Bool) {
        self.date = date
        self.sync = isSync
    }
    
    var referenceTime: ReferenceTime?
    
    func start(pool: [String], port: Int) {
        return
    }
    
    func fetchIfNeeded(success: @escaping (ReferenceTime) -> Void, failure: ((NSError) -> Void)?) {
        if sync {
            success(ReferenceTime(time: date!, uptime: timeval.init(tv_sec: 100, tv_usec: 100)))
        } else {
            failure!(NSError(domain: "", code: 1, userInfo: nil))
        }
    }
    
    public func setrefernceTime() {
        self.referenceTime = ReferenceTime(time: date!, uptime: timeval.init(tv_sec: 0, tv_usec: 0))
    }
}

class TrueTimeMockWithReferenceTimeToNil: TrueTimeProtocol{
    var referenceTime: ReferenceTime?
    
    func start(pool: [String], port: Int) {
        return
    }
    
    func fetchIfNeeded(success: @escaping (ReferenceTime) -> Void, failure: ((NSError) -> Void)?) {
        return
    }
    
    
}
