//
//  AILog+CoreDataProperties.swift
//  AppInfra
//
//  Created by Philips on 03/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//
//

import Foundation
import CoreData


extension AILog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AILog> {
        return NSFetchRequest<AILog>(entityName: "AILog")
    }

    @NSManaged public var appsId: String?
    @NSManaged public var appState: String?
    @NSManaged public var appVersion: String?
    @NSManaged public var component: String?
    @NSManaged public var details: String?
    @NSManaged public var eventID: String?
    @NSManaged public var homeCountry: String?
    @NSManaged public var locale: String?
    @NSManaged public var localTime: NSDate?
    @NSManaged public var logDescription: String?
    @NSManaged public var logID: String?
    @NSManaged public var logTime: NSDate?
    @NSManaged public var networkType: String?
    @NSManaged public var serverName: String?
    @NSManaged public var severity: String?
    @NSManaged public var transactionID: String?
    @NSManaged public var userUUID: String?
    @NSManaged public var status: String?

}
