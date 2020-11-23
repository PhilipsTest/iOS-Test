//
//  MYALaunchInput.swift
//  MyAccount
//
//  Created by Hashim MH on 10/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//


import UIKit
import UAPPFramework
import PlatformInterfaces

/**
 Gives an object of type MyaTabConfig which can be used to display third tab In MyAccount
 */
@objc open class MYATabConfig:NSObject {
    public var name : String
    public var viewController :UIViewController
   
    /**
     Initialize an object of type MYATabConfig in order to display third tab in MyAccount.
     - Parameter TabName : Name of third tab
     - Parameter controller : View Controllers
     - Returns: An object of type MyaTabConfig
     - Since: 2018.1.0
     */
    public init(tabName:String,controller: UIViewController) {
        name = tabName
        viewController = controller
        super.init()
    }
}

/**
 This class provides Launchinput for the MyAccount
 - Since: 2018.1.0
 */
@objc public class MYALaunchInput: UAPPLaunchInput {
   
    /**
     The application need to specify which object should handle callback on click of menu items in profile,settings and logout in MyAccount
    - Since: 2018.1.0
    */
    @objc open weak var delegate: MYADelegate?
    
    /**
     The application need's to send an array of list menu items that needs to displayed in the profileMenuList and recive callbacks with the same name on click of them.
     - Since: 2018.1.0
     */
    @objc public var profileMenuList: [String]?
   
    /**
     The application need's to send an array of list menu items that needs to displayed in the settingsMenuList and recive callbacks with the same name on click of them.
     - Since: 2018.1.0
     */
   @objc public var settingMenuList: [String]?
    
    /**
     The application need's to send an object of type MYATabConfig which will be displayed as a third tab in the the MyAccount
     - Since: 2018.1.0
     */
    @objc public var additionalTabConfiguration:MYATabConfig?
    
    /**
     The application need's to send an object which confirms to UserDataInterface in order to display the user information in MyAccount
     The object can be obtained by calling a api userDataInterface() on urInterface object of UserRegistartion.
     - Since: 2018.1.0
     */
    @objc public var userDataProvider : UserDataInterface?
   
}
