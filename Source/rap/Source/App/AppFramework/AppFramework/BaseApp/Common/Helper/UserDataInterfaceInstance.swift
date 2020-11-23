//
//  UserDataInterfaceInstance.swift
//  AppFramework
//
//  Created by Philips on 3/4/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import AppInfra
import PhilipsRegistration

public class UserDataInterfaceInstance: NSObject {
    public static let sharedInstance = UserDataInterfaceInstance()
    var userDataInterface : UserDataInterface?

    fileprivate override init() {
        super.init()
        let appinfraHandler = AppInfraSharedInstance.sharedInstance.appInfraHandler
        self.userDataInterface = self.setUserDataInterface(appInfra: appinfraHandler)
    }
    
    private func setUserDataInterface(appInfra:AIAppInfra!) -> UserDataInterface!{
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }
    
    
}
