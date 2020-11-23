//
//  AILog+CoreDataClass.swift
//  AppInfra
//
//  Created by Philips on 30/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//
//

import Foundation
import CoreData


struct Constants {
    static let MAXIMUM_ROWS = 1000
    static let MINIMUM_ROWS = 20
    static let ZERO_ROWS = 0
    static let QUERY_FORALL = "(severity CONTAINS %@) OR (severity CONTAINS %@) OR (severity CONTAINS %@) OR (severity CONTAINS %@) OR (severity CONTAINS %@)"
    static let ENTITY_NAME = "AILog"
    static let SORT_BASED_LOGTIME = "logTime"
    static let fetchLimit = 20
    static let momdName = "AILogging"
    static let uidPrefix = "hsdpUUID"

}

@objc(AILog)
public class AILog: NSManagedObject {

    @objc public func updateLogMessage(with logMessage:DDLogMessage){
        self.logDescription = logMessage.message
        self.localTime = logMessage.timestamp as NSDate
        if let tagData = logMessage.tag as? AILogMetaData{
            updateLogMetaData(with: tagData)
        }
        updateLogUtitlityData(with: logMessage.flag)
    }
    
    @objc private func updateLogMetaData(with tagData:AILogMetaData){

        self.eventID = tagData.eventId
        self.component = tagData.component
        if let component = self.component {
            self.component = component.replacingOccurrences(of: ":", with: "/")
        }
        self.userUUID = tagData.originatingUser
        if let uid = self.userUUID{
            self.userUUID = "\(Constants.uidPrefix)_\(uid)"
        }
        if let logTime = tagData.networkDate{
            self.logTime = logTime as NSDate
        }
        self.details = nil
        if let paramsDictonary = tagData.params{
            if let jsonData = try? JSONSerialization.data(withJSONObject: paramsDictonary, options: []){
                self.details = String(data: jsonData, encoding: .utf8)
            }
        }
    }
    
    @objc private func updateLogUtitlityData(with flag:DDLogFlag){
        self.severity = AILogUtilities.logLevel(flag)
        self.logID = AILogUtilities.generateLogId()
        self.serverName = AILogUtilities.systemInfo()
    }
    
    @objc public func updateCloudLogMetaData(withData metaData: AICloudLogMetadata){
        self.appsId = metaData.appId
        self.appState = metaData.appState
        self.appVersion = metaData.appVersion
        self.homeCountry = metaData.homeCountry
        self.locale = metaData.locale
        self.networkType = metaData.networkType
    }
    
    @objc public func saveData() -> Int{
        let noOfRowsInDB = fetchRowsFromDB()
        if(isPreConditionSatisfied(withRowsInDB: noOfRowsInDB)){
            self.savingDataToDB()
        }else{
            self.clearDataFromDB()
            self.savingDataToDB()
        }
        return noOfRowsInDB+1;
    }
    
    private func fetchRowsFromDB() -> Int{
        var noOfRows = 0
        let dataFetch:NSFetchRequest<AILog> = AILog.fetchRequest()
        do{
            if let rows = try self.managedObjectContext?.count(for: dataFetch){
                noOfRows = rows
            }
        }
        catch {
            print("Failed to fetch Data from DataBase: \(error)")
        }
        return noOfRows
    }
    
    private func isPreConditionSatisfied(withRowsInDB rowCount:Int) -> Bool{
        if(rowCount > Constants.MAXIMUM_ROWS){
            return false
        }else{
            return true
        }
    }
    
    
    private func savingDataToDB(){
        do{
            try self.managedObjectContext?.save()
        }
        catch{
            print("Failed to save in DataBase: \(error)")
        }
    }
    
    private func clearDataFromDB(){
        let dataFetch:NSFetchRequest<AILog> = AILog.fetchRequest()
        dataFetch.predicate = NSPredicate(format:"status != %@", "inProcess")
        sortAndDeleteData(forFetchRequest: dataFetch)
    }

    
    private func sortAndDeleteData(forFetchRequest fetchRequest:NSFetchRequest<AILog>){
        do{
            let sectionSortDescriptor = NSSortDescriptor(key: Constants.SORT_BASED_LOGTIME, ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
            fetchRequest.fetchLimit = Constants.fetchLimit
            
            if let request = fetchRequest as? NSFetchRequest<NSFetchRequestResult>{
              let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
              try self.managedObjectContext?.execute(deleteRequest)
            }
        }
        catch {
            print("Failed to perform batch update: \(error)")
        }
    }
}
