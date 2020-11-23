//
//  PPRDemoFrameworkInterface.swift
//  PPRDemoFramework
//
//  Created by Abhishek on 21/03/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit
import UAPPFramework
import PhilipsProductRegistration
import PhilipsRegistration

public class PPRDemoFrameworkInterface: NSObject, UAPPProtocol {
    private var appDependencies : PPRInterfaceDependency!

    private var launchInputs : PPRDemoFrameworkLaunchInput?
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        self.appDependencies = dependencies as? PPRInterfaceDependency
        PPRDemoFrameworkInterfaceWrapper.sharedInstance.interfaceDependencies = self.appDependencies
        
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        
        let podBundle = Bundle(for: PPRDemoFrameworkInterface.self)
        
        let storyBoard = UIStoryboard(name:"Main", bundle: podBundle)
        let viewController: RegistrationViewController = storyBoard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        
        return viewController
    }
}
