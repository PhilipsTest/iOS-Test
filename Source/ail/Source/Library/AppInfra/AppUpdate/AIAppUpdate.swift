
//
//  AIAppUpdate.swift
//  AppInfra
//
//  Created by Hashim MH on 10/05/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//


@objc open class AIAppUpdate: NSObject,AIAppUpdateProtocol {
    
    //MARK:  - constants and properties
    fileprivate let kErrorDomainAIAppUpdate = "ail.appUpdate"
    fileprivate let kAppUpdateServiceID = "appUpdate.serviceId"
    fileprivate let logEventId = "AIAppUpdate"
    
    var appUpdateInfo = AIAppUpdateInfo.getSavedInfo()
    
    public enum AppUpdateErrors : Error {
        
        /// This error is thrown when there is a error in service discovery
        case serviceIdError
        
        /// This error is thrown when the response is invalid json
        case invalidJSON
        
        /// This error is thrown when info missing in the response
        case infoMissing
        
        public func message() -> String {
            switch self {
            case .serviceIdError:
                return "Could not read service id"
            case .invalidJSON:
                return  "error trying to convert data to JSON"
            case .infoMissing:
                return "ios appupdate info is missing in response"
            }
        }
        
        public func code() -> Int {
            return self._code + 3300
        }
        
        func getError() -> NSError{
            let error = NSError(domain: "ail.appUpdate", code: self.code(), userInfo: [NSLocalizedDescriptionKey: self.message()])
            return error
        }
    }
    
    
    fileprivate let aiappinfra: AIAppInfraProtocol?
    
    @objc lazy  var RESTClient:AIRESTClientProtocol? =  {
        var rest =   self.aiappinfra?.restClient.createInstance(with: nil)
        return rest
    }()
    
    fileprivate var logger: AILoggingProtocol?
    //MARK: - init
   @objc public init(appinfra: AIAppInfraProtocol) {
        self.aiappinfra = appinfra
        self.logger = AIInternalLogger.appInfraLogger
        super.init()
    }
    
    
    //MARK: - Appinfra Specific Methods
    @objc open func appInfraRefresh(){
        
        guard appUpdateInfo == nil else {
            self.logger?.log(.verbose, eventId: logEventId, message: "appdate info already downloaded")
            return;
        }
        
        let isAutoRefreshEnabled =  try?  aiappinfra?.appConfig.getPropertyForKey("appUpdate.autoRefresh", group: "appinfra")
        if isAutoRefreshEnabled == nil{
            self.logger?.log(.debug, eventId: logEventId, message: "appupdate auto refresh is not enabled")
        }
        else if let isAutoRefreshEnabled = isAutoRefreshEnabled as? Bool{
            if  isAutoRefreshEnabled {
                self.logger?.log(.debug, eventId: logEventId, message: "appinfra refreshing updateinfo")
                refresh({ (status, error) in
                    if let error = error {
                        let message = "appupdate auto refresh failed . error \(error.localizedDescription)"
                        self.logger?.log(.error, eventId: self.logEventId, message: message)
                    }
                })
            }
            
        }
        else{
            self.logger?.log(.warning, eventId: logEventId, message: "appUpdate.autoRefresh should be boolean in appconfig file")
        }
        
        
    }
    
    
    //MARK: - protocol methods
    
    /// refreshes the appupdate info available in the server
    ///
    /// - Parameter completionHandler: completion handler with refresh status and error if refresh failed
    open func refresh(_ completionHandler: ((AIAppUpdateRefreshStatus, Error?) -> Void)? = nil) {
        
        self.logger?.log(.debug, eventId: logEventId, message: "refreshing from server")
        do {
            if let serviceId = try getServiceId(){
                let logMessage = "serviceId:\(serviceId)"
                self.logger?.log(.debug, eventId: logEventId, message: logMessage)
                downloadAppUpdateInfo(forServiceId:serviceId , completionHandler:completionHandler)
                
            }
            else{
                let sdError = AppUpdateErrors.serviceIdError
                self.logger?.log(.error, eventId: logEventId,
                                        message: sdError.message())
                //let userInfo :[AnyHashable : Any] = [NSLocalizedDescriptionKey: sdError.message()]
                completionHandler?(.failed,sdError.getError())
            }
        }
        catch{
            completionHandler?(.failed,error)
        }
        
        
    }
    
    open func isDeprecated() -> Bool {
        if let appUpdateInfo = appUpdateInfo{
            return appUpdateInfo.isDeprecated
        }
        return false
    }
    
    
    open func isToBeDeprecated() -> Bool {
        if let appUpdateInfo = appUpdateInfo{
            return appUpdateInfo.isToBeDeprecated
        }
        return false
    }
    
    open func isUpdateAvailable() -> Bool {
        if let appUpdateInfo = appUpdateInfo{
            return appUpdateInfo.isUpdateAvailable
        }
        return false
    }
    
    open func getDeprecateMessage() -> String? {
        return appUpdateInfo?.minimumVersionMessage
    }
    
    open func getToBeDeprecatedMessage() -> String? {
        return appUpdateInfo?.deprecatedVersionMessage
    }
    
    open func getToBeDeprecatedDate() -> Date? {
        return appUpdateInfo?.deprecatedDate
    }
    
    open func getUpdateMessage() -> String? {
        return appUpdateInfo?.currentVersionMessage
    }
    
    open func getMinimumVersion() -> String? {
        return appUpdateInfo?.minimumVersion?.versionString
    }
    
    open func getMinimumOsVersion() -> String? {
        return appUpdateInfo?.minimumOSVersion
    }
    
    open func getMinimumOsMessage() -> String? {
        return appUpdateInfo?.minimumOSMessage
    }
    
    //MARK: - private methods
    fileprivate func downloadAppUpdateInfo(forServiceId serviceId:String, completionHandler:  ((AIAppUpdateRefreshStatus, Error?) -> Void)? = nil){
        
        self.RESTClient?.get(withServiceID: serviceId,
                             preference: AIRESTServiceIDPreference.country,
                             pathComponent: nil,
                             serviceURLCompletion: nil,
                             parameters: nil,
                             progress: nil,
                             success: {
                                (task, response) in
                                
                                guard let response = response as? [String: Any] else {
                                    let errorType = AppUpdateErrors.invalidJSON
                                    self.logger?.log(.error, eventId: self.logEventId, message:errorType.message())
                                    completionHandler?(.failed,errorType.getError())
                                    return
                                }
                                
                                guard let iosInfo = response["iOS"] as? [String: NSDictionary] else {
                                    let errorType = AppUpdateErrors.infoMissing
                                    self.logger?.log(.error, eventId: self.logEventId, message: errorType.message())
                                    completionHandler?(.failed,errorType.getError())
                                    return
                                }
                                
                                self.logger?.log(.debug, eventId: self.logEventId, message: "Succesfully fetched app update info")
                                self.appUpdateInfo = AIAppUpdateInfo(dictionary: iosInfo)
                                AIAppUpdateInfo.saveInfo(iosInfo);
                                completionHandler?(.success,nil)
                                
                                
        },
                             failure: {
                                (task, error) in
                                completionHandler?(.failed,error)
        })
        
    }
    
    
    fileprivate func getServiceId() throws -> String? {
        let serviceId =    try aiappinfra?.appConfig.getPropertyForKey(kAppUpdateServiceID, group: "appinfra")
        return serviceId as? String
    }
    
}

