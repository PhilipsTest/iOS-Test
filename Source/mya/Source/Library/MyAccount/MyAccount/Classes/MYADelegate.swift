//
//  MYAListener.swift
//  MyAccount
//
//  Created by Hashim MH on 26/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//
import Foundation

/**
 The applications class needs to confirm to this protocol in order to receive callbacks from Myaccount on select of items in settings,profile page and on click of logout.
  - Since: 2018.1.0
 */
@objc public protocol MYADelegate: NSObjectProtocol {
    /**
     This has to be implemented by the application to handle the menu item click on the settings view. Should return true if Application has handled the menu item click for a particular menu. Should return false if delegate is not handling that particlular menu item click.
     - Parameter item: the Settings menu item key that is added in LaunchInput of the settingMenuList.
     - Since: 2018.1.0
     - Returns: True if menu item click is handled by the Application, false other wise.
     */
    @objc func settingsMenuItemSelected(onItem item:String)->Bool
    
    /**
     This has to be implemented by the application to handle the menu item click on the profile view. Should return true if Application has handled the menu item click for a particular menu. Should return false if delegate is not handling that particlular menu item click.
     - Parameter item: the Profile menu item key that is added in LaunchInput of the profileMenuList.
     - Since: 2018.1.0
     - Returns: True if menu item click is handled by the Application, false other wise.
     */
    @objc func profileMenuItemSelected(onItem item:String)->Bool
    
    /**
     On click of logout in My-Account the Application will receive a callback.
     Proposition should handle logout on receiving callback.
     - Since: 2018.1.0
     */
    @objc func logoutClicked()
}
