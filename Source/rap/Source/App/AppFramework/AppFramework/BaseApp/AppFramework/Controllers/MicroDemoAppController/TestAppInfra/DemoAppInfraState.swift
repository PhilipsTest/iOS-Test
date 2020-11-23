//
//  DemoAppInfraState.swift
//  AppFramework
//
//  Created by Philips on 3/21/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation
import UIKit
import PhilipsConsumerCare
import UAPPFramework
import AppInfraMicroApp


class DemoAppInfraState: BaseState {
  
    var appInfraHandler : AppInfraMicroAppInterface?
    var demoAppInfraDependencies : AppInfraMicroAppDependencies?
    var demoAppInfraLaunchInput : AppInfraMicroAppLaunchInput?
    var demoAppInfraViewController : UIViewController?
    
    override init() {
        super.init(stateId : AppStates.DemoAppInfraState)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        setUpAppInfraDemoHandler()
        setUpAppInfraDemoLaunchInput()
         let demoAppInfraViewController = appInfraHandler?.instantiateViewController(demoAppInfraLaunchInput!, withErrorHandler: nil)
        return demoAppInfraViewController
        
    }
    
    
    func setUpAppInfraDemoHandler() {
    
        demoAppInfraDependencies = AppInfraMicroAppDependencies()
        demoAppInfraDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        appInfraHandler = AppInfraMicroAppInterface(dependencies: demoAppInfraDependencies!, andSettings: nil)

    }
    
    
    func setUpAppInfraDemoLaunchInput() {
        demoAppInfraLaunchInput = AppInfraMicroAppLaunchInput()
       
    }
    
    
}



