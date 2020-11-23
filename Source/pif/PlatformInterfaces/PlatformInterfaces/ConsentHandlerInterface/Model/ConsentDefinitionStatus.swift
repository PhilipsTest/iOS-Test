/* Copyright (c) Koninklijke Philips N.V., 2019
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

@objc public enum ConsentStates: Int {
    case active
    case inactive
    case rejected
}

@objc public enum ConsentVersionStates: Int {
    case inSync
    case appVersionIsHigher
    case appVersionIsLower
}

@objcMembers public class ConsentDefinitionStatus: NSObject {
    public var status: ConsentStates
    public var versionStatus: ConsentVersionStates
    public var consentDefinition: ConsentDefinition
    public var lastModifiedTimestamp :Date
    
    public init(status: ConsentStates, versionStatus: ConsentVersionStates, consentDefinition: ConsentDefinition, lastModifiedTimestamp:Date = Date(timeIntervalSince1970: 0)) {
        self.status = status
        self.versionStatus = versionStatus
        self.consentDefinition = consentDefinition
        self.lastModifiedTimestamp = lastModifiedTimestamp
        super.init()
    }
    
    public static func == (lhs: ConsentDefinitionStatus, rhs: ConsentDefinitionStatus) -> Bool {
        return lhs.status == rhs.status &&
            lhs.versionStatus == rhs.versionStatus &&
            lhs.consentDefinition == rhs.consentDefinition &&
            lhs.lastModifiedTimestamp == rhs.lastModifiedTimestamp
    }
    
    public static func combine(consentDefinitionStatus1: ConsentDefinitionStatus, consentDefinitionStatus2: ConsentDefinitionStatus) -> ConsentDefinitionStatus? {
        let statusRawValueToUse =  (consentDefinitionStatus1.status.rawValue > consentDefinitionStatus2.status.rawValue) ? consentDefinitionStatus1.status.rawValue : consentDefinitionStatus2.status.rawValue
        let versionRawValueToUse = (consentDefinitionStatus1.versionStatus.rawValue > consentDefinitionStatus2.versionStatus.rawValue) ? consentDefinitionStatus1.versionStatus.rawValue : consentDefinitionStatus2.versionStatus.rawValue
        let lastModifiedTimeStampToUse = (consentDefinitionStatus1.lastModifiedTimestamp > consentDefinitionStatus2.lastModifiedTimestamp) ? consentDefinitionStatus1.lastModifiedTimestamp : consentDefinitionStatus2.lastModifiedTimestamp
        guard let consentStatus = ConsentStates(rawValue: statusRawValueToUse),
            let versionStatus = ConsentVersionStates(rawValue: versionRawValueToUse) else { return nil }
        return ConsentDefinitionStatus(status: consentStatus, versionStatus: versionStatus, consentDefinition: consentDefinitionStatus1.consentDefinition,lastModifiedTimestamp:lastModifiedTimeStampToUse)
    }
}

@objcMembers public class ConsentStatus: NSObject, NSCoding {
    public var status: ConsentStates
    public var version: Int
    public var timestamp: Date
    
    enum Keys {
        static let version = "versionKey"
        static let status = "statusKey"
        static let timestamp = "timestamp"
    }
    
    public init(status: ConsentStates, version: Int, timestamp:Date = Date(timeIntervalSince1970: 0)) {
        self.status = status
        self.version = version
        self.timestamp = timestamp
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(status.rawValue, forKey: Keys.status)
        aCoder.encode(version, forKey: Keys.version)
        aCoder.encode(timestamp, forKey: Keys.timestamp)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let status = ConsentStates(rawValue: aDecoder.decodeInteger(forKey: Keys.status)),let timestamp = aDecoder.decodeObject(forKey: Keys.timestamp) as? Date else {
            return nil
        }
        self.status = status
        self.version = aDecoder.decodeInteger(forKey: Keys.version)
        self.timestamp = timestamp
    }
    
    public static func == (lhs: ConsentStatus, rhs: ConsentStatus) -> Bool {
        return lhs.status == rhs.status &&
            lhs.version == rhs.version &&
            lhs.timestamp == rhs.timestamp
    }

}
