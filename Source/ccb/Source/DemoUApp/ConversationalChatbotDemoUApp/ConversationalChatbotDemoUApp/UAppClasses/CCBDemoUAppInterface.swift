/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import UAPPFramework
import ConversationalChatbot

@objcMembers public class CCBDemoUAppInterface: NSObject, UAPPProtocol {
    
    private var uAppDependencies : CCBDependencies?
    private var uAppSettings: CCBSettings?
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        self.uAppDependencies = dependencies as? CCBDependencies
        self.uAppSettings = settings as? CCBSettings
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput,
    withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        let podBundle = Bundle(for: CCBDemoUAppInterface.self)
        let storyBoard = UIStoryboard(name:"Main", bundle:podBundle)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "CCBDemoUAppViewController") as? CCBDemoUAppViewController
        viewController?.ccbLaunchInput = launchInput as? CCBLaunchInput
        viewController?.ccbAppinfraHandler = self.uAppDependencies?.appInfra
        viewController?.ccbSettings = self.uAppSettings
        viewController?.ccbDependencies = self.uAppDependencies
        guard let image = (launchInput as! CCBLaunchInput).leftChatIcon else {
            return viewController;
        }
        viewController?.leftIconImage = image
        return viewController
    }
    
}
