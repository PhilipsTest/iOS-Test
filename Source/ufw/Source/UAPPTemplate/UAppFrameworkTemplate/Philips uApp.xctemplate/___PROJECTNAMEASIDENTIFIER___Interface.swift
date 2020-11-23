//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit
import UAPPFramework


class ___PROJECTNAMEASIDENTIFIER___Interface: NSObject, UAPPProtocol {
    private var appDependencies : ___PROJECTNAMEASIDENTIFIER___Dependencies!
    
    private var launchInputs : ___PROJECTNAMEASIDENTIFIER___LaunchInput?
    
    required init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        self.appDependencies = dependencies as! ___PROJECTNAMEASIDENTIFIER___Dependencies
    }
    
    func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        
        
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyBoard.instantiateViewControllerWithIdentifier("___PROJECTNAMEASIDENTIFIER___ViewController")
        
        return viewController
    }
}
