//
//  SwiftExecutionViewController.swift
//  DemoAppInfra
//
//  Created by leslie on 30/08/16.
//  Copyright © 2016 philips. All rights reserved.
//

import AppInfra

class SwiftExecutionViewController: UIViewController {
    var appInfraSwiftLogger:AILoggingProtocol? = nil
    let appInfra = AilShareduAppDependency.shared().uAppDependency.appInfra
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Swift Tests"
         appInfraSwiftLogger = appInfra?.logging.createInstance(forComponent: "SwiftDebugging", componentVersion:appInfra?.appIdentity.getAppVersion());
        appInfraSwiftLogger?.log(.debug, eventId: "SwiftCombatibility", message:"SwiftCombatibility Tests Started");
        
        self.executeAppConfiguration()
        self.executeAppIdentity()
        self.executeSecureStorage()
        self.executeServiceDiscovery()
        self.executeLogging()
        executeTimeSync()
        executeTagging()// commented since it is crashing
        executeRestClients()
        executeApiSignin()
        
    }

//MARK: - App Config test
    func executeAppConfiguration(){
        //checking getProperty api from swift
        do {
            let devID = try self.appInfra?.appConfig.getPropertyForKey("Development", group: "UR")
            print("id = \(String(describing: devID)) Executed App Configuration getProperty from swift")
        }
        catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
        }
        
        //checking setProperty api from swift
        do {
            //setting new value
            try self.appInfra?.appConfig.setPropertyForKey("Development", group: "UR", value: "new")
            print("Executed App Configuration setProperty from swift")
            
            //verifying new value
            let newId = try self.appInfra?.appConfig.getPropertyForKey("Development", group: "UR")
            if newId as! String == "new" {
                print("Verified App Configuration setProperty from swift")
            }
            
            //testing a method call that returns error.
            try self.appInfra?.appConfig.getPropertyForKey("abc", group: "UR")
        }
        catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
        }
    }
    

//MARK: - App Identity test

    func executeAppIdentity() {
        print("--------------\n \n")
        print("Starting app identity testing from swift")
        let sector = self.appInfra?.appIdentity.getSector()
        print("sector = \(sector ?? "")")
        let name = self.appInfra?.appIdentity.getAppName()
        print("app name = \(name ?? "")")
        let micrositeId = self.appInfra?.appIdentity.getMicrositeId()
        print("micrositeId = \(micrositeId ?? "")")
        let appState = self.appInfra?.appIdentity.getAppState()
        print("appState = \(appState ?? AIAIAppState.DEVELOPMENT)")
        let localizedAppName = self.appInfra?.appIdentity.getLocalizedAppName()
        print("localizedAppName = \(localizedAppName ?? "")")
        let appVersion = self.appInfra?.appIdentity.getAppVersion()
        print("appVersion = \(appVersion ?? "")")
        let serviceDiscoveryEnvironment = self.appInfra?.appIdentity.getServiceDiscoveryEnvironment()
        print("serviceDiscoveryEnvironment = \(serviceDiscoveryEnvironment ?? "")")
    }
    
//MARK: - Secure Storage test
    
    func executeSecureStorage() {
        print("--------------\n \n")
        appInfraSwiftLogger?.log(.debug, eventId: "SecureStorage", message:"Starting Secure Storage Testing")
        appInfraSwiftLogger?.log(.debug, eventId: "SecureStoragePublicAPI", message:"storeValueForKey(\"testSwift\", value: \"testSwiftValue\")")
       
        do {
            
            try appInfra?.storageProvider.storeValue(forKey: "testSwift", value: "testSwiftValue" as NSCoding);
        }
        catch{
            let nsError = error as NSError
             appInfraSwiftLogger?.log(.error, eventId: "SecureStorageStoreError", message:nsError.localizedDescription)
        }


        
        appInfraSwiftLogger?.log(.debug, eventId: "SecureStorage:fetchValueForKey", message:try! appInfra?.storageProvider.fetchValue(forKey: "testSwift") as! String)
  
        do {
            
            try appInfra?.storageProvider.fetchValue(forKey: "zcsdsd");
        }
        catch{
            let nsError = error as NSError
            appInfraSwiftLogger?.log(.error, eventId: "SecureStorage", message:nsError.localizedDescription)
        }
        

        appInfra?.storageProvider.removeValue(forKey: "testSwift")
        if let eData = try? appInfra?.storageProvider.loadData("teststring".data(using: String.Encoding.utf8)! as NSCoding){
            print("encryptingData:teststring" )
            if let dData = try? appInfra?.storageProvider.parseData(eData)
            {
                let plainString = NSString(data: dData as! Data, encoding: String.Encoding.utf8.rawValue)
              print("decryptedData:\(plainString!)" )
            }
            

        }
        
    }

//MARK: - ServiceDiscovery
    func executeServiceDiscovery() {
        print("------------------");

  
        appInfra?.serviceDiscovery.getHomeCountry { (countryCode, SourceType, error) in
                print("getHomeCountry");
            
            if  ((error) != nil){
                print(error ?? "error in getting homecountry")
            }
            else{
                print("countryCode:\(countryCode ?? "")")
                print("SourceType:\(SourceType ?? "")")
            }

        }
        
        print("setHomeCountry");
        appInfra?.serviceDiscovery.setHomeCountry("IN")
        
        appInfra?.serviceDiscovery?.getServicesWithCountryPreference(["userreg.janrain.cdn.v2"], withCompletionHandler: { (services, error) in
            print("getServicesWithCountryPreference");
            
            if  ((error) != nil){
                print(error ?? "error")
            }
            else{
                print("services:\(String(describing: services))")
            }
        }, replacement: nil)


        appInfra?.serviceDiscovery?.getServicesWithLanguagePreference(["userreg.janrain.cdn.v2"], withCompletionHandler: { (services, error) in
            print("getServicesWithLanguagePreference");
            
            if  ((error) != nil){
                print(error ?? "error")
            }
            else{
                print("services:\(String(describing: services))")
            }
        }, replacement: nil)
        
        appInfra?.serviceDiscovery.refresh { (error) in
            
        }
    }
    
//MARK: - Logging
    func executeLogging() {
        print("-------Logging-----------");
        let appInfraSwiftTestLogger = appInfra?.logging.createInstance(forComponent: "AppInfraSwiftTestLogger", componentVersion: "1")
        appInfraSwiftTestLogger?.log(.info, eventId: "Test", message: "test message")
        appInfraSwiftTestLogger?.log(AILogLevel.info, eventId: "Test", message: "test message")
        print("------------------");

        
    }

//MARK: - TimeSync
    func executeTimeSync() {
        print("---------TimeSync---------");
        appInfra?.time.refreshTime()
        let time = appInfra?.time.getUTCTime()
        print(time ?? "No time")
        print("------------------");

    }
//MARK: - Tagging
    func executeTagging() {
        print("---------Tagging---------");
        let tagging = appInfra?.tagging.createInstance(forComponent: "SwiftDebugging", componentVersion: "1.0");
        tagging?.setPrivacyConsent(.unknown)
        let privacy = tagging?.getPrivacyConsent()
        print ("privacy:\(String(describing: privacy))")
        tagging?.trackPage(withInfo: "testpage", paramKey: "apicheck", andParamValue: "running")
        tagging?.trackPage(withInfo: "testpage", params: ["apicheck1":"checkDictionary"])
        tagging?.trackAction(withInfo: "testbutton", paramKey: "pressed", andParamValue: "yes")
        tagging?.trackAction(withInfo: "testbutton", params: ["pressed":"no"])
        tagging?.setPreviousPage("testPreviousPage");
        tagging?.trackLinkExternal("http://www.google.com")
        tagging?.trackFileDownload("Introvideo.mp4")
        tagging?.trackSocialSharing(.facebook, withItem: "test")
        print("------------------");

    }
//MARK: - RESTClient
    func executeRestClients() {
        print("-------RESTClient----------");
        let protocolCachePolicy = AIRESTURLRequestCachePolicy.useProtocolCachePolicy;
        _ = AIRESTURLRequestCachePolicy.returnCacheDataElseLoad
        _ = AIRESTURLRequestCachePolicy.reloadIgnoringLocalCacheData
        
        
        //let protocolCachePolicy = AIRESTURLRequestCachePolicy.AIRESTURLRequestUseProtocolCachePolicy;
        //let protocolCachePolicy1 = .UseProtocolCachePolicy;
        let url = URL(string:"https://httpbin.org")
        let session = URLSessionConfiguration.default
        
        _ = appInfra?.restClient.manager()
        let newManager  = appInfra?.restClient.createInstance(withBaseURL: nil)
        let newManager1 = appInfra?.restClient.createInstance(withBaseURL: url, sessionConfiguration: session)
        _ = appInfra?.restClient.createInstance(with: session)
        _ = appInfra?.restClient.createInstance(withBaseURL: url, sessionConfiguration: session, with: protocolCachePolicy);
        
        newManager?.get("https://httpbin.org/ip", parameters: nil, progress: nil, success: { (task, response) in
            
            print(response  as! NSDictionary)
            
            }) { (task, error) in
           
            print(error.localizedDescription)
        }
        
        newManager1?.post("post", parameters: ["postkey":"testvaue"], progress: nil, success: { (task, data) in
           print(data  as! NSDictionary)
            }) { (task, error) in
            print(error.localizedDescription)
        }
        
        
        newManager1?.put("put", parameters: ["putkey":"testvaue"], success: { (task, data) in
            print(data  as! NSDictionary)
        }) { (task, error) in
        
         print(error.localizedDescription)
        }
        
        newManager1?.delete("delete", parameters: ["deletekey":"testvaue"], success: { (task, data) in
            print(data  as! NSDictionary)
        }) { (task, error) in
            
            print(error.localizedDescription)
        }
        
        }

//MARK: - APISignin
    func executeApiSignin() {
        let apisignin = AIClonableClient.init(apiSigner: "cafebabe-1234-dead-dead-1234567890ab", andhexKey: "e124794bab4949cd4affc267d446ddd95c938a7428d75d7901992e0cb4bc320cd94c28dae1e56d83eaf19010ccc8574d6d83fb687cf5d12ff2afddbaf73801b5")
        let header = apisignin?.clonableClient("POST", dhpUrl: "/login", queryString: "authenticationm", headers: ["Auth":"custom"], requestBody: nil)
        print(header ?? "No Headers")
        
        }

}
