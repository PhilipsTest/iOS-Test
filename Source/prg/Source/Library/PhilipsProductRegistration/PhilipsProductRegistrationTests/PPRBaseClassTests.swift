//
//  PPRBaseClassTests.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 21/09/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import XCTest
import UAPPFramework
@testable import PhilipsRegistration
@testable import PhilipsProductRegistrationDev

class PPRBaseClassTests: XCTestCase {

    private static var __once7: () = {
        let originalSelector = #selector(AIAppIdentityInterface.getMicrositeId)
        let swizzledSelector = #selector(PPRFakeSelectorClass.fakeMicrositeId)

        let originalMethod = class_getInstanceMethod(AIAppIdentityInterface.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(PPRFakeSelectorClass.self, swizzledSelector)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    private static var __once6: () = {
        let originalSelector: Selector = NSSelectorFromString("getPlatformEnvironment")
        let swizzledSelector: Selector = NSSelectorFromString("fakePlatformEnviroment")

        let originalMethod = class_getInstanceMethod(NSClassFromString("AISDManager"), originalSelector)
        let swizzledMethod = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), swizzledSelector)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    private static var __once5: () = {
        let originalSelector: Selector = NSSelectorFromString("getPlatformMicrositeID")
        let swizzledSelector: Selector = NSSelectorFromString("fakePlatformMicrositeId")

        let originalMethod = class_getInstanceMethod(NSClassFromString("AISDManager"), originalSelector)
        let swizzledMethod = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), swizzledSelector)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()

    private static var __once4: () = {
        let originalSelector: Selector = NSSelectorFromString("loadFromDisk")
        let swizzledSelector: Selector = NSSelectorFromString("fakeAppConfigABTest")
        
        let originalMethod = class_getInstanceMethod(NSClassFromString("AIABTest"), originalSelector)
        let swizzledMethod = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), swizzledSelector)
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    private static var __once3: () = {
            let originalSelector: Selector = NSSelectorFromString("getAppIdentityConfigDictionary")
            let swizzledSelector: Selector = NSSelectorFromString("fakeAppConfig")
            
        let originalMethod = class_getInstanceMethod(AIAppIdentityInterface.self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), swizzledSelector)
            
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        }()
    
    private static var __once2: () = {
        let originalSelector = #selector(AIAppIdentityInterface.getAppVersion)
        let swizzledSelector = #selector(PPRFakeSelectorClass.fakeAppVersion)
        
        let originalMethod = class_getInstanceMethod(AIAppIdentityInterface.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(PPRFakeSelectorClass.self, swizzledSelector)
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }        }()
    
    private static var __once1: () = {
            let originalSelector: Selector = NSSelectorFromString("getLoggingConfigDictionary")
            let swizzledSelector: Selector = NSSelectorFromString("fakeLoggingConfigDictionary")
            
            let originalMethod = class_getInstanceMethod(NSClassFromString("AILogging"), originalSelector)
            let swizzledMethod = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), swizzledSelector)
            
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        }()
    
    private static var __once: () = {
            let originalSelector: Selector = NSSelectorFromString("readAppConfigurationFromFile")
            let swizzledSelector: Selector = NSSelectorFromString("fakeAppConfigurationFromFile")
            
            let originalMethod = class_getInstanceMethod(NSClassFromString("AIAppConfiguration"), originalSelector)
            let swizzledMethod = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), swizzledSelector)
            
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
//        let originalSelector1: Selector = NSSelectorFromString("getPropertyForKey:group:error:")
//
//        let originalMethod1 = class_getInstanceMethod(NSClassFromString("AIAppConfiguration"), originalSelector1)
        //let swizzledMethod1 = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), #selector(PPRFakeSelectorClass.getProperty(with:group:)))
        
        //method_exchangeImplementations(originalMethod1, swizzledMethod1)
        
        let originalSelector1: Selector = NSSelectorFromString("getDefaultPropertyForKey:group:error:")
        
        let originalMethod1 = class_getInstanceMethod(NSClassFromString("AIAppConfiguration"), originalSelector1)
        let swizzledMethod1 = class_getInstanceMethod(NSClassFromString("PPRFakeSelectorClass"), #selector(PPRFakeSelectorClass.getDefaultProperty(with:group:)))
        if let originalMethod1 = originalMethod1, let swizzledMethod1 = swizzledMethod1 {
            method_exchangeImplementations(originalMethod1, swizzledMethod1)
        }
        }()
    
    struct Static {
        static var configToken: Int = 0
        static var logToken: Int = 0
        static var versionToken: Int = 0
        static var appConfigToken: Int = 0
    }
    
    var appInfra: AIAppInfra?
    var userDataInterface:UserDataInterface?

    override func setUp() {
        super.setUp()
        
        self.changeConfigurationMethod()
        
        self.changeLoggingConfigurationMethod()
        
        self.changeAppVersionMethod()
        
        self.changeAppIdentityConfigMethod()
        
        self.changeABtestConfigMethod()

        self.changePlatformmicrositeIdMethod()

        self.changePlatformEnviromentMethod()

        self.changeMicrositeIdMethod()

        let dependency: PPRInterfaceDependency = PPRInterfaceDependency()
        //Client app needs to alloc for AIAppInfra
        self.appInfra = AIAppInfra.init(builder: nil)
        let userMock = DIUserMock.sharedInstance
        userMock.isUserLoggedIn = true
        userMock.isAccessTokenRefreshed = false
        self.userDataInterface = userMock
        dependency.appInfra = self.appInfra
        dependency.userDataInterface = self.userDataInterface
        //Initialize the component interface with dependency and settings
        let _ = PPRInterface(dependencies: dependency, andSettings: nil)
    }
    
    func setUserDataInterface(appInfra:AIAppInfra!) -> UserDataInterface!{
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }
    
    func changeConfigurationMethod() {

        _ = PPRBaseClassTests.__once
    }
    
    func changeLoggingConfigurationMethod() {
        
        _ = PPRBaseClassTests.__once1
    }
    
    func changeAppVersionMethod() {
        
        _ = PPRBaseClassTests.__once2
    }
    
    func changeAppIdentityConfigMethod() {
    
        _ = PPRBaseClassTests.__once3
    }
    
    func changeABtestConfigMethod() {
        
        _ = PPRBaseClassTests.__once4
    }

    func changePlatformmicrositeIdMethod() {

        _ = PPRBaseClassTests.__once5
    }

    func changePlatformEnviromentMethod() {

        _ = PPRBaseClassTests.__once6
    }

    func changeMicrositeIdMethod() {

        _ = PPRBaseClassTests.__once7
    }
}
