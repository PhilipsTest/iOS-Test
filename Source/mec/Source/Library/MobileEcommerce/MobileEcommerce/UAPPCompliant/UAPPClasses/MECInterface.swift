/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework
import PlatformInterfaces

/**
MECInterface is the public interface for any proposition to consume MobileEcommerce micro app. Its the intitialization point.
- Since: 2001.0
*/
@objcMembers public class MECInterface: NSObject, UAPPProtocol, MECInitializer, MECAnalyticsTracking {

    private var mecLauncher = MECLauncher()

    /**
     MECInterface init method
     - Parameter dependencies: Object of uAppDependencies class,for injecting Dependencies needed by uApp
     - Parameter settings: Object of UAPPSettings class,for injecting one time initialisation parameters needed for uApp Initialisation
     - Since: 2001.0
     - Returns: An instance of UAPP
     */
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        if let mecAppInfra = dependencies.appInfra {
            MECConfiguration.shared.sharedAppInfra = mecAppInfra
            MECUtility.configureTaggingAndLogging(MECConfiguration.shared.sharedAppInfra)
        }

        if let mecDependencies = dependencies as? MECDependencies,
            let dataInterface = mecDependencies.userDataInterface {
            MECConfiguration.shared.sharedUDInterface = dataInterface
        }
    }

    /**
     MECInterface instantiateViewController will initializes the rootviewcontroller of the uApp
     - Parameter launchInput: Instance of UAPPLaunchInput class,for setting the parameters needed for launch of uAPP
     - Parameter completionHandler: Block for handling error
     - Since: 2001.0
     - Returns: An instance of UAPP UIViewController which will be used for launching the uApp
     */
    public func instantiateViewController(_ launchInput: UAPPLaunchInput,
                                          withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        var mecViewController: UIViewController?
        BazaarVoiceHandler.sharedInstance.configureBazaarVoice(bazaarVoiceEnvironment: MECConfiguration.shared.bazaarVoiceEnvironment)
        if let landingView = MECConfiguration.shared.flowConfiguration?.landingView {
            mecViewController = mecLauncher.launchView(landingView,
                                                       failure: { (inError: NSError) in
                                                        completionHandler?(inError)
            })
            return mecViewController
        }
        let message = MECLocalizedString("mec_invalid_landing_view")
        let error = NSError(domain: message, code: MECErrorCode.MECErrorLandingViewCode,
                            userInfo: [NSLocalizedDescriptionKey: message])
        completionHandler?(error)
        return mecViewController
    }

    /**
    * This interface includes APIs to share Cart related data.
     - Returns: object conforming to MECDataInterface protocol
     - Since: 2002.0
     */
    public func dataInterface() -> MECDataInterface {
        return MECConfiguration.shared.getDataInterface()
    }
}
