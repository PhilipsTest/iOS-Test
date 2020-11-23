//
//  PPRFakeSelectorClass.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 23/09/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import Foundation

@objc(PPRFakeSelectorClass)

class PPRFakeSelectorClass: NSObject {
    
    @objc func fakeAppConfigurationFromFile() -> [String:AnyObject]?  {
        
        let logConfig = "{\"fileName\": \"AppInfraLog\",\"numberOfFiles\": 5,\"fileSizeInBytes\": 50000,\"logLevel\": \"Off\",\"fileLogEnabled\": false,\"consoleLogEnabled\": false,\"componentLevelLogEnabled\": false,\"componentIds\": []}"
        

        let applicationConfig: String = "{\"UserRegistration\":{\"JanRainConfiguration.RegistrationClientID.Development\":\"8kaxdrpvkwyr7pnp987amu4aqb4wmnte\",\"JanRainConfiguration.RegistrationClientID.Testing\":\"g52bfma28yjbd24hyjcswudwedcmqy7c\",\"JanRainConfiguration.RegistrationClientID.Evaluation\":\"durhrkq6ezqcvmqf6mq77ev48fuubdbj\",\"JanRainConfiguration.RegistrationClientID.Staging\":\"durhrkq6ezqcvmqf6mq77ev48fuubdbj\",\"JanRainConfiguration.RegistrationClientID.Production\":\"tygvkmbxkaact4rjtnh7ugkyqq9tf8z6\",\"PILConfiguration.CampaignID\":\"CL20150501_PC_TB_COPPA\",\"Flow.EmailVerificationRequired\":true,\"Flow.TermsAndConditionsAcceptanceRequired\":true,\"Flow.MinimumAgeLimit\":{\"NL\":12,\"GB\":0,\"default\":16},\"SigninProviders.default\":[\"myphilips\",\"facebook\",\"googleplus\"]},\"APPINFRA\":{\"appidentity.micrositeId\":77000,\"appidentity.sector\":\"b2c\",\"appidentity.state\":\"Production\",\"appidentity.serviceDiscoveryEnvironment\":\"Production\",\"LOGGING.RELEASECONFIG\":\(logConfig),\"LOGGING.DEBUGCONFIG\":\(logConfig)}}"
        
        
        if let data = applicationConfig.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    @objc func fakeLoggingConfigDictionary() -> [String:AnyObject]? {
        
        let logConfig = "{\"AI_LOGLEVEL\":\"DDLogLevelAll\",\"MAX_NUMBER_OF_LOG_FILE\":5,\"MAX_FILE_SIZE\":50000,\"FILE_LOG_ENABLED\":1,\"CONSOLE_LOG_ENABLED\":1,\"COMPONENT_LEVEL_LOG_ENABLED\":1,\"LIST_COMPONENTID\":[\"Registration\",\"DemoProductRegistrationClient\"]}"
        
        if let data = logConfig.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    @objc func fakeAppVersion() -> String {
        return "1.0.0"
    }
    
    @objc func fakeAppConfig() -> [String:AnyObject]?  {
  
        let logConfig = "{\"fileName\": \"AppInfraLog\",\"numberOfFiles\": 5,\"fileSizeInBytes\": 50000,\"logLevel\": \"Off\",\"fileLogEnabled\": false,\"consoleLogEnabled\": false,\"componentLevelLogEnabled\": false,\"componentIds\": []}"
        
        let applicationConfig: String = "{\"appidentity.micrositeId\":77000,\"appidentity.sector\":\"b2c\",\"appidentity.appState\":\"Production\",\"appidentity.serviceDiscoveryEnvironment\":\"Production\",\"servicediscovery.platformMicrositeId\":\"70000\",\"servicediscovery.platformEnvironment\":\"Production\",\"logging.releaseConfig\":\(logConfig),\"logging.debugConfig\":\(logConfig)}"
        
        if let data = applicationConfig.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    @objc func fakeAppConfigABTest() -> [String:AnyObject]?  {
        
        let applicationConfig: String = "{\"appidentity.micrositeId\":\"77000\",\"appidentity.sector\":\"b2c\",\"appidentity.state\":\"Production\",\"appidentity.serviceDiscoveryEnvironment\":\"Production\",\"abtest.precache\":[\"ReceiveMarketingOptIn\"],\"servicediscovery.platformMicrositeId\": \"70000\",\"servicediscovery.platformEnvironment\": \"Production\"}"
        
        if let data = applicationConfig.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    @objc func fakePlatformMicrositeId()-> String {
        return "70000"
    }

    @objc func fakeMicrositeId()-> String {
        return "70000"
    }

    @objc func fakePlatformEnviroment()-> String {
        return "PRODUCTION"
    }
    
    @objc func getDefaultProperty(with key: String, group :String) -> Any? {
        if key == "restclient.cacheSizeInKB" {
            return NSNumber(value: 200)
        }
        
        let dict :Dictionary =  ["UserRegistration":["JanRainConfiguration.RegistrationClientID.Development":"8kaxdrpvkwyr7pnp987amu4aqb4wmnte","JanRainConfiguration.RegistrationClientID.Testing":"g52bfma28yjbd24hyjcswudwedcmqy7c","JanRainConfiguration.RegistrationClientID.Evaluation":"durhrkq6ezqcvmqf6mq77ev48fuubdbj","JanRainConfiguration.RegistrationClientID.Staging":"durhrkq6ezqcvmqf6mq77ev48fuubdbj","JanRainConfiguration.RegistrationClientID.Production":"tygvkmbxkaact4rjtnh7ugkyqq9tf8z6","PILConfiguration.CampaignID":"CL20150501_PC_TB_COPPA","Flow.EmailVerificationRequired":true,"Flow.TermsAndConditionsAcceptanceRequired":true,"SigninProviders.default":["myphilips","facebook","googleplus"]],"appinfra":["appidentity.micrositeId":77000,"appidentity.sector":"b2c","appidentity.appState":"Production","appidentity.serviceDiscoveryEnvironment":"Production", "servicediscovery.platformMicrositeId": "70000", "servicediscovery.platformEnvironment": "Production"]]
        
        if (dict.keys.contains(group)) {
            let groupDict = dict[group]
            if (groupDict?.keys.contains(key))! {
                let value = groupDict?[key]
                return value
            }else {
                return "67665"
            }
        }else {
            return "67665"
        }
    }
    
/*    @objc func getProperty(with key: String, group :String) -> Any? {
        if key == "restclient.cacheSizeInKB" {
            return NSNumber(value: 200)
        }
//        let dict :[String: AnyObject] = ["UserRegistration":"value" as AnyObject]
        
        let dict :Dictionary =  ["UserRegistration":["JanRainConfiguration.RegistrationClientID.Development":"8kaxdrpvkwyr7pnp987amu4aqb4wmnte","JanRainConfiguration.RegistrationClientID.Testing":"g52bfma28yjbd24hyjcswudwedcmqy7c","JanRainConfiguration.RegistrationClientID.Evaluation":"durhrkq6ezqcvmqf6mq77ev48fuubdbj","JanRainConfiguration.RegistrationClientID.Staging":"durhrkq6ezqcvmqf6mq77ev48fuubdbj","JanRainConfiguration.RegistrationClientID.Production":"tygvkmbxkaact4rjtnh7ugkyqq9tf8z6","PILConfiguration.CampaignID":"CL20150501_PC_TB_COPPA","Flow.EmailVerificationRequired":true,"Flow.TermsAndConditionsAcceptanceRequired":true,"SigninProviders.default":["myphilips","facebook","googleplus"]],"appinfra":["appidentity.micrositeId":77000,"appidentity.sector":"b2c","appidentity.state":"Production","appidentity.serviceDiscoveryEnvironment":"Production", "servicediscovery.platformMicrositeId": "70000", "servicediscovery.platformEnvironment": "Production"]]
        
        if (dict.keys.contains(group)) {
            let groupDict = dict[group]
            if (groupDict?.keys.contains(key))! {
                let value = groupDict?[key] as! String
                return value
            }else {
                return "67665"
            }
        }else {
           return "67665"
        }
    } */
    
    
}
