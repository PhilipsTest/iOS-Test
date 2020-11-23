//
//  MYAInterface.swift
//  MyAccount
//
//  Created by Hashim MH on 09/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit
import UAPPFramework
import PlatformInterfaces
/**
 MYAInterface implements UAPPProtocol to lauch as micro app
 - Since 2018.1.0
 
 ### Usage Example: ###
 ````
    let myaDependencies = MYADependencies()
    myaDependencies.appInfra = appinfra
    let myaInterface = MYAInterface(dependencies: myaDependencies, andSettings: MYASettings())
    let launchInput = MYALaunchInput()
    launchInput.delegate = self
    let vc  = myaInterface.instantiateViewController(launchInput) { (error) in
     <#handle error#>
    }
     if let vc = vc {
     <#push/present vc to navigationcontroller#>
     }
 ````
 */
@objc public class MYAInterface: NSObject,UAPPProtocol {
    
    /**
     MYAInterface init method
     - Parameter dependencies: Object of Type UAppDependencies class,for injecting Dependencies needed by MyAccount
     - Parameter settings: Object of type UAPPSettings class,for injecting one time initialisation parameters needed for UAPP Initialisation
     - Since: 2018.1.0
     - Returns: instance of uAPP
    */
    @objc public required init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?){
        let _ = MYAData.setup(dependencies)
        let interfaceInput: MYAData = MYAData.shared
        interfaceInput.dependency = dependencies
        interfaceInput.settings = settings
        
    }
    
    /**
     MYAInterface instantiateViewController will initializes the rootviewcontroller of the MyAccount
     - Parameter launchInput: Instance of UAPPLaunchInput class,for setting the parameters needed to launch of MyAccount
     - Parameter completionHandler: Block for handling error
     - Since: 2018.1.0
     - Returns: an instance of uApp's UIViewController which will be used for launching the MyAccount
     */
    @objc public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Swift.Void)? = nil) -> UIViewController?{
        if let launchInput = launchInput as? MYALaunchInput {
            MYAData.shared.profileMenuList = launchInput.profileMenuList
            MYAData.shared.settingsMenuList = launchInput.settingMenuList
            MYAData.shared.additionalTabConfig = launchInput.additionalTabConfiguration
            MYAData.shared.delegate = launchInput.delegate
            MYAData.shared.userProvider = launchInput.userDataProvider
        }
        
        if (MYAData.shared.userProvider?.loggedInState().rawValue)! >= UserLoggedInState.pendingTnC.rawValue{

            return self.storyBoard().instantiateViewController(withIdentifier: MYAstoryBoardIDs.profileScreen)
        }
        else{
            MYAData.shared.logger.log(.error, eventId:"MYAInterface" , message: MYAError.userNotLoggedIn.localizedDescription)
            completionHandler?(MYAError.userNotLoggedIn.error())
            return nil
        }
    }

 
    private func bundle() -> Bundle {
        return Bundle(for: MYAInterface.classForCoder())
    }
    
    private func storyBoard() -> UIStoryboard  {
        return UIStoryboard.init(name: MYAstoryBoardIDs.storyBoardName, bundle:self.bundle())
    }
}

