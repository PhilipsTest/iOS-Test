//
//  AINetworkTime.swift
//  AppInfra
//
//  Created by philips on 9/19/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit
import TrueTime


let kAITimeEvent = "AITime"

public protocol TrueTimeProtocol {
    
    var referenceTime: ReferenceTime? { get }
    
    func start(pool: [String], port: Int)
    
    func fetchIfNeeded(success: @escaping (ReferenceTime) -> Void,
                       failure: ((NSError) -> Void)?)
    
}

extension TrueTimeClient: TrueTimeProtocol {
    
}


@objc public class AINetworkTime: NSObject, AITimeProtocol {
    
    var client: TrueTimeProtocol?
    var ntpHosts: [String]?
    var isSynchronised: Bool = false
    fileprivate var logger: AILoggingProtocol?
    
    @objc public override init() {
        super.init()
        self.logger = AIInternalLogger.appInfraLogger
        client = TrueTimeClient(timeout: 8, maxRetries: 3, maxConnections: 3, maxServers: 5,
                                numberOfSamples: 4, pollInterval: (3*60*60) )
        client?.start(pool: ntpHost(), port: 123)
        NotificationCenter.default.addObserver(self, selector: #selector(timeUpdated),
                                               name: NSNotification.Name.TrueTimeUpdated , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func timeUpdated() {
        if ((client?.referenceTime?.now()) != nil) {
            isSynchronised = true
        } else {
            isSynchronised = false
        }
    }
    
    @objc public func getUTCTime() -> Date! {
        if let now = client?.referenceTime?.now() {
            return now
        }
        return Date.init()
    }
    
    @objc public func refreshTime() {
        logger?.log(.debug, eventId: kAITimeEvent , message: "AppInfra time syncronization starts. .")
        isSynchronised =  false
        client?.fetchIfNeeded(success: {_ in
            self.isSynchronised = true
        }, failure: { _ in
            self.isSynchronised = false
        })
    }
    
    @objc public func isSynchronized() -> Bool {
        return isSynchronised
    }
    
    func ntpHost() -> [String] {
        if let ntpHost = ntpHosts {
            return ntpHost
        }
        var ntpDomains: [String] = ["time.apple.com","0.pool.ntp.org","0.uk.pool.ntp.org",
                                    "0.us.pool.ntp.org","asia.pool.ntp.org","time1.google.com"]
        if let filePath = Bundle.main.path(forResource: "ntp.hosts", ofType: ""),
            let filePathData = FileManager.default.contents(atPath: filePath),
            let fileData = String(data: filePathData, encoding: .utf8)  {
            ntpDomains = fileData.components(separatedBy: CharacterSet.newlines)
        }
        self.ntpHosts = ntpDomains
        return self.ntpHosts!
    }
    
}
