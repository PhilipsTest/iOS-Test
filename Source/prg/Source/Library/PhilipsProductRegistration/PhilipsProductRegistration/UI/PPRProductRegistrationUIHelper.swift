//
//  PPRProductRegistrationUIHelper.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit

/// ### Protocols for Product Registration call backs.
/// - Since: 1.0.0
@objc public protocol PPRUserInterfaceDelegate: class {
    
    /// When user taps on Back.
    ///
    /// - Parameters:
    ///   - userProduct: Object of PPRUserWithProducts. This class contains methods for product registration related methods.
    ///   - products: Array of Registered products.
    /// - Since: 1.0.0
    func productRegistrationBack(userProduct: PPRUserWithProducts?, products: [PPRRegisteredProduct])
    
    /// On successful registration of product when user taps on continue.
    ///
    /// - Parameters:
    ///   - userProduct: Object of PPRUserWithProducts. This class contains methods for product registration related methods.
    ///   - products: Array of Registered products.
    /// - Since: 1.0.0
    func productRegistrationContinue(userProduct: PPRUserWithProducts?, products: [PPRRegisteredProduct])
}

/// This class provides interfaces for configuring product registration user interface, launch option and content where configurable text is available.
/// - Since: 1.0.0
@objc public class PPRProductRegistrationUIHelper: NSObject {
    
    private func bundle() -> Bundle {
       return Bundle(for: PPRProductRegistrationUIHelper.classForCoder())
    }

    private func storyBoard() -> UIStoryboard  {
        return UIStoryboard.init(name: PPRStoryBoardIDs.storyBoardName, bundle:self.bundle())
    }
    
    /// Launching ProductRegistration with user interface.
    ///
    /// - Parameters:
    ///   - products: Array of PPRProductsbthat are going to be registered.
    ///   - configuration: Object of PPRConfiguration
    ///   - delegate: Object of PPRUserInterfaceDelegate
    /// - Returns: UIViewController
    /// - Since: 1.0.0
    class func instantiateUI(products: [PPRProduct],
                              configuration: PPRConfiguration,
                              delegate: PPRUserInterfaceDelegate?) -> UIViewController
    {
        let helper = PPRProductRegistrationUIHelper()
        helper.trackProductRegistrationStart()
        let viewController = helper.getRootViewController(launchOption: configuration.launchOption)
        viewController.products = products
        viewController.configuration = configuration
        viewController.delegate = delegate
        return viewController
    }
    
    func getRootViewController(launchOption: PPRUILaunchOption) -> PPRBaseViewController {
        let controllerName = getViewControllerName(launchOpton: launchOption)
        return self.storyBoard().instantiateViewController(withIdentifier: controllerName) as! PPRBaseViewController
    }
    
    func getViewControllerName(launchOpton: PPRUILaunchOption) -> String {
        switch launchOpton {
        case .WelcomeScreen:
            return PPRStoryBoardIDs.welcomeScreen
        case .ProductRegistrationScreen:
            return PPRStoryBoardIDs.registerScreen
        }
    }
}
