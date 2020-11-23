
//
//  AIClouldLoggingSyncManager.swift
//  AppInfra
//
//  Created by Hashim MH on 21/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit
import CoreData
import PlatformInterfaces

@objc public class HsdpData:NSObject{
    
    @objc public static let acGroupName = "hsdp"
    @objc public static let acSecretKeyName = "appInfra.cloudLoggingSecretKey"
    @objc public static let acSharedKeyName = "appInfra.cloudLoggingSharedKey"
    @objc public static let acProductKeyName = "appInfra.cloudLoggingProductKey"
    
    @objc public static let test = "appInfra.cloudLoggingProductKey"
    
    var secretKey:String
    var sharedKey:String
    var productKey:String
    
    init(key:String, sharedKey:String, productKey:String ) {
        self.secretKey = key
        self.sharedKey = sharedKey
        self.productKey = productKey
    }
    
    @objc public convenience init?(appConfig:AIAppConfigurationProtocol){
        let sc = try? appConfig.getPropertyForKey(HsdpData.acSecretKeyName, group: HsdpData.acGroupName)
        let sk = try? appConfig.getPropertyForKey(HsdpData.acSharedKeyName, group: HsdpData.acGroupName)
        let pk = try? appConfig.getPropertyForKey(HsdpData.acProductKeyName, group: HsdpData.acGroupName)
        if let sc = sc as? String,  let sk = sk as? String, let pk = pk as? String{
            assert( sc.count > 0 && pk.count > 0 && sk.count > 0, "please provide valid hsdp credential in AppConfig.json")
            self.init(key: sc , sharedKey: sk, productKey: pk)
        }
        else{
            assert( false, "please provide the hsdp credential in AppConfig.json")
            return nil
        }
        
    }
}



@objc public class AIClouldLoggingSyncManager: NSObject,AIConsentStatusChangeProtocol {
    
    
    typealias CompletionHandler = (_ consentEnable:Bool) -> Void
    
    
    
    struct SyncConstants {
        static let MAXIMUM_BATCH_LIMIT = 25
        static let MAXIMUM_CONCURRENT_OPERATION = 4
        
    }
    
    enum SyncStatus: String {
        case new
        case inProcess
        case error
        case synced
    }
    
    lazy  var RESTClient:AIRESTClientProtocol? =  {
        var rest =   self.appinfra?.restClient.createInstance(with: nil)
        rest?.requestSerializer .setValue("1", forHTTPHeaderField: "api-version")
        rest?.requestSerializer .setValue("application/json", forHTTPHeaderField: "Content-Type")
        return rest
    }()
    
    @objc public var cloudBatchLimit = 5
    private let requestSerializer:AICLoudLogRequestSerializer
    private let rest:AICloudLoggerRestClient
    private let hsdpData:HsdpData?
    
    var managedObjectContext:NSManagedObjectContext? = AILogCoreDataStack.shared.managedObjectContext
    private var appinfra:AIAppInfraProtocol?
    
    private  let syncQueue: OperationQueue = OperationQueue()
    
    @objc public init(appInfra:AIAppInfraProtocol) {
        
        self.appinfra = appInfra
        self.hsdpData = HsdpData(appConfig: appInfra.appConfig)
        self.requestSerializer = AICLoudLogRequestSerializer(productKey:self.hsdpData?.productKey)
        self.rest = AICloudLoggerRestClient(appinfra: appInfra, sharedKey: self.hsdpData?.sharedKey, secretKey: self.hsdpData?.secretKey)
        syncQueue.maxConcurrentOperationCount = SyncConstants.MAXIMUM_CONCURRENT_OPERATION;
        syncQueue.name = "com.philips.platform.ail.cloud.sync"
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appinfraInitialized), name: .InfraComponentsInitialisationComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: NSNotification.Name(rawValue: kAILReachabilityChangedNotification), object: nil)
    }
    
    @objc func appinfraInitialized(){
        NotificationCenter.default.removeObserver(self, name: .InfraComponentsInitialisationComplete, object: nil)
        sync(forced: true)
    }
    
    @objc func networkChanged(){
        sync(forced: true)
    }
    
    public func consentStatusChanged(for consentDefinition: ConsentDefinition, error: NSError?, requestedStatus: Bool) {
        if (error == nil){
            sync(forced: true)
        }
    }
    
    @objc public func sync(forced isForced:Bool = false){
        shouldSync { [weak self](consentEnable) in
            
            if (!consentEnable), let _ = self?.hsdpData{
                return
            }
            
            AILogCoreDataStack.shared.perform({
                self?.startSyncToCloud(isForced: isForced)
            })
            
        }
    }
    
    func startSyncToCloud(isForced:Bool){
        guard let logs = self.fetchLogs(forced:isForced) else { return }
        
        guard let postdata  = self.requestSerializer.postData(logs: logs) else {return}
        self.syncQueue.addOperation { [weak self] in
            self?.rest.uploadLog(logData: postdata, success: { [weak self] in
                AILogCoreDataStack.shared.perform({
                    self?.delete(logs:logs)
                });
            }) { [weak self] (shouldRetry, error) in
                if shouldRetry{
                    AILogCoreDataStack.shared.perform({
                        self?.updateFailed(logs: logs)
                    })
                }
                else{
                    AILogCoreDataStack.shared.perform({
                        self?.delete(logs:logs)
                    })
                    
                }
            }
        }
        self.sync()
    }
    
    func dateString() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter .string(from: date)
        return dateString
    }
    
    func fetchLogs(forced:Bool = false)->[AILog]?{
        let dataFetch:NSFetchRequest<AILog> = AILog.fetchRequest()
        let sort = NSSortDescriptor(key: "logTime", ascending: true)
        dataFetch.sortDescriptors = [sort]
        dataFetch.fetchLimit = SyncConstants.MAXIMUM_BATCH_LIMIT
        dataFetch.predicate = NSPredicate(format: "status != %@",SyncStatus.inProcess.rawValue)
        
        do {
            if let rows =  try self.managedObjectContext?.count(for: dataFetch){
                if   rows < cloudBatchLimit && !forced { return nil }
            }
            
        } catch  {
            
        }
        if let logs =  try? self.managedObjectContext?.fetch(dataFetch){
            logs.forEach { $0.status = SyncStatus.inProcess.rawValue }
            try? self.managedObjectContext?.save()
            return logs
        }        
        return nil
    }
    
    func updateFailed(logs:[AILog]){
        logs.forEach { $0.status = SyncStatus.error.rawValue }
        try? self.managedObjectContext?.save()
    }
    
    func delete(logs:[AILog]){
        logs.forEach {
            $0.status = SyncStatus.synced.rawValue
            self.managedObjectContext?.delete($0)
        }
        try? self.managedObjectContext?.save()
        /*
         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = AILog.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "status == %@",SyncStatus.synced.rawValue)
         let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         do {
         try self.managedObjectContext?.execute(batchDeleteRequest)
         
         } catch {
         // Error Handling
         print("Error delete after sync:" + error.localizedDescription)
         }
         try? self.managedObjectContext?.save()
         */
        
    }
    
    
    func shouldSync(completion: @escaping CompletionHandler){
        
        guard let rest = appinfra?.restClient else {
            return
        }
        
        let isReachable = rest.isInternetReachable()
        
        consentValueCheck { (consentEnable) in
            AILogCoreDataStack.shared.perform({
                completion(consentEnable && isReachable)
            })
        }
    }
    
    func consentValueCheck(completion:@escaping CompletionHandler){
        var cloudConsent = false
        
        if let consentManager = self.appinfra?.consentManager,
            let cloudConsentIdentifier = self.appinfra?.cloudLogging.getCloudLoggingConsentIdentifier(),
            let cloudConsentDefinition = self.getCloudLoggingConsentDefinition(consentType: cloudConsentIdentifier){
            
            consentManager.addConsentStatusChanged?(delegate:self, for:cloudConsentDefinition)
            
            consentManager.fetchConsentState(forConsentDefinition: cloudConsentDefinition, completion: { (consentStatus, error) in
                if ((error) != nil){
                    completion(cloudConsent)
                    return
                }
                
                if(consentStatus?.status == ConsentStates.active){
                    cloudConsent = true
                }
                AILogCoreDataStack.shared.perform({
                    completion(cloudConsent)
                })
            })
            
        }else{
            completion(cloudConsent)
        }
    }
    
    func getCloudLoggingConsentDefinition(consentType: String) -> ConsentDefinition? {
        var consentDefinition: ConsentDefinition?
        
        consentDefinition = self.appinfra?.consentManager.getConsentDefinition(forConsentType: consentType)
        
        return consentDefinition
    }
    
}
