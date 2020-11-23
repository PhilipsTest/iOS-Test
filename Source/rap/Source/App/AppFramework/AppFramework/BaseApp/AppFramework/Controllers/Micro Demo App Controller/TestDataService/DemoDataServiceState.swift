/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import UAPPFramework
import DataServices
import DataServicesUApp

class DataServicesState: BaseState,PushNotificationPayloadDelegate {
    private var dataservicesViewController: UIViewController?
    private var dataServicesHandler: DataServicesHandler
    public var dependencies: DataServicesUAppDependencies?
    
    init(dataServicesHandler: DataServicesHandler) {
        self.dataServicesHandler = dataServicesHandler
        super.init(stateId: AppStates.DemoDataService)
        self.configureDataServicesAndDependencies()
    }
    
    convenience override init() {
        self.init(dataServicesHandler: DataServicesHandler.sharedInstance)
    }
    
    private func configureDataServicesAndDependencies() {
        self.dependencies = DataServicesUAppDependencies()
        self.dependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        if let appinfra = self.dependencies?.appInfra {
            self.dependencies?.dscConfiguration.supportedMomentTypes = try! appinfra.appConfig.getPropertyForKey("supportedMomentTypes", group: "dataservices") as! [String]
            dataServicesHandler.initializeDataServices(withServiceDiscovery: appinfra.serviceDiscovery, consentManager: appinfra.consentManager, logging: appinfra.logging, userRegistration: nil, errorHandler: self.dependencies?.errorHandler, dscConfiguration: self.dependencies?.dscConfiguration)
            if let momentDataCreator = self.dependencies?.momentDataCreator {
                dataServicesHandler.setupDataServices(withDataCreator: momentDataCreator)
            }
            
            if let dataBaseDeletingMonitor = self.dependencies?.databaseDeletingMonitor {
                if let databaseUpdatingMonitor = self.dependencies?.databaseUpdatingMonitor {
                    dataServicesHandler.initializeDatabaseMonitor(self.dependencies?.fetchManager, inDatabaseSavingMonitor: self.dependencies?.databaseSavingMonitor, inDatabaseDeletingMonitor: dataBaseDeletingMonitor, inDatabaseUpdatingMonitor: databaseUpdatingMonitor)
                }
            }
            
            if let dataFetchers = self.dependencies?.dataFetchers {
                if let dataSenders = self.dependencies?.dataSenders {
                    dataServicesHandler.initializeSyncMonitors(dataFetchers, withDataSenders: dataSenders)
                }
            }
            
        }
        
    }
    
    override func getViewController() -> UIViewController? {
        guard let controllerToReturn = self.dataservicesViewController else {
            let settings = DataServicesUAppSettings()
            let launchInput = DataServicesUAppLaunchInput()

            // Register Consent Definitions in Consent Manager
            _ = ConsentBootstrapper.sharedInstance

            if let dependency = self.dependencies {
                let dataServicesInterface = DataServicesUAppInterface(dependencies: dependency, andSettings: settings)
                self.dataservicesViewController = dataServicesInterface.instantiateViewController(launchInput, withErrorHandler: nil)
            }
            return self.dataservicesViewController
            
        }
        
        return controllerToReturn
    }
    
    /**
     Register token by calling Data Service RegisterToken API.
     - Parameter deviceTokenString: The device token having type String.
     - Parameter appAgent: The appAgent eg "RAP-IOS" having type String .
     - Parameter protocolService: The protocolService eg "Push.APNS" having type String.
     - Parameter handler: Handler having value for register token success or not.
     */
    
    func registerToken(deviceTokenString: String, appAgent: String, protocolService:String, handler:@escaping (Bool)->Void){
        if let appInfraObject = AppInfraSharedInstance.sharedInstance.appInfraHandler {
            dataServicesHandler.initializeDataServices(withServiceDiscovery: appInfraObject.serviceDiscovery, consentManager: appInfraObject.consentManager, logging: appInfraObject.logging, userRegistration: nil, errorHandler: nil, dscConfiguration: dependencies?.dscConfiguration)
        }
        
        dataServicesHandler.registerDeviceToken(withDevToken: deviceTokenString, withAppAgent:appAgent
        , withProtocolService:protocolService ) { (value) in
            
            handler(value)
        }
    }
    
    
    /**
     Register token by calling Data Service RegisterToken API.
     - Parameter deviceTokenString: The device token having type String.
     - Parameter appAgent: The appAgent eg "RAP-IOS" having type String .
     - Parameter handler: Handler having value for register token success or not.
     */
    
    func unRegisterToken(deviceTokenString: String, appAgent: String,handler:@escaping (Bool)->Void){
        if let appInfraObject = AppInfraSharedInstance.sharedInstance.appInfraHandler {
            dataServicesHandler.initializeDataServices(withServiceDiscovery: appInfraObject.serviceDiscovery, consentManager: appInfraObject.consentManager, logging: appInfraObject.logging, userRegistration: nil, errorHandler: nil, dscConfiguration: dependencies?.dscConfiguration)
        }
        
        dataServicesHandler.unRegisterDeviceToken(withDevToken: deviceTokenString, withAppAgent:appAgent
        ) { (value) in
            handler(value)
        }
    }
    
    
    func sendPayloadToComponent(payload: [String:AnyObject]){
        dataServicesHandler.handlePushNotificationPayload(jsonObject: payload)
    }
    
    func getVersion() -> String {
        let dictionary = Bundle(for:DataServicesHandler.self).infoDictionary
        if let version = dictionary?["CFBundleShortVersionString"] as? String{
           return "\(version)"
        }
        return ""
    }
}

