/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import UAPPFramework

@objcMembers public class CCBInterface: NSObject, UAPPProtocol {
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        if (settings != nil) {
            CCBManager.shared.ccbSettings = settings as? CCBSettings
        }
        CCBManager.shared.ccbDependencies = dependencies as? CCBDependencies
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput,
    withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: CCBInterface.classForCoder()))
        let messageViewController = storyBoard.instantiateViewController(withIdentifier: "CCBMessageScene") as! CCBMessageViewController
        guard let image = (launchInput as! CCBLaunchInput).leftChatIcon  else {
            return messageViewController
        }
        messageViewController.leftChatIcon = image;
        return messageViewController
    }
    
}
