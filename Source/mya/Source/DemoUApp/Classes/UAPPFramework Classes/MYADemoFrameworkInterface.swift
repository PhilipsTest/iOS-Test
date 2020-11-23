//
//  PPRDemoFrameworkInterface.swift
//  PPRDemoFramework
//
//  Created by Hashim MH on 09/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import UAPPFramework
import MyAccount
import ConsentWidgets
import PhilipsRegistration



public class MYADemoFrameworkInterface: NSObject, UAPPProtocol {
    private var appDependencies : MYADemoFrameworkDependencies!
    private var launchInputs : MYADemoFrameworkLaunchInput?
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        self.appDependencies = dependencies as? MYADemoFrameworkDependencies
        MYADemoFrameworkInterfaceWrapper.sharedInstance.interfaceDependencies = self.appDependencies
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        let storyboard = UIStoryboard.init(name: "MYADemoUApp", bundle: Bundle.init(for: self.classForCoder))
        let vc = storyboard.instantiateInitialViewController() as? MYADemoFrameworkHomeVC
        vc?.appinfra = appDependencies.appInfra
        return vc
    }
}
