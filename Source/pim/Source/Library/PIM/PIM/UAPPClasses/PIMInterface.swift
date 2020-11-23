/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import UAPPFramework
import PlatformInterfaces
import PhilipsUIKitDLS

/**
PIMInterface is the public interface for any proposition to consume UDI micro app. Its the intitialization point.
- Since: 1904.0
*/
@objcMembers open class PIMInterface: NSObject, UAPPProtocol {
    /**
    Public completion handler to communicate back to proposition if any error happened while migration or redirection
    - Since: 2001.0
    */
    public var pimCompletionHandler: ((Error?) -> Void)? {
        didSet {
            PIMSettingsManager.sharedInstance.setPIMCompletionHandler(completionHandler: self.pimCompletionHandler)
        }
    }
    /*
     * User Migration status from JR or Old USR user to UDI user.
     */
    public var isUserMigrating: Bool {
        get {
            return PIMSettingsManager.sharedInstance.isUserMigrating
        }
    }
    
    private weak var pimViewController: PIMViewController?
    private var appDependencies : PIMDependencies
    private var launchInputs : PIMLaunchInput?
    private var pimMigrator : PIMMigrator?
    private var janrainHandler:PIMJanrainHandler?
    private var migrationCompletionHandler: ((NSError?) -> ())?
    
    /**
    PIMInterface init method
    - Parameter dependencies: Object of uAppDependencies class,for injecting Dependencies needed by uApp
    - Parameter settings: Object of UAPPSettings class,for injecting one time initialisation parameters needed for uApp Initialisation
    - Returns: An instance of UAPP
    - Since: 1904.0
    */
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        self.appDependencies = dependencies as! PIMDependencies
        PIMSettingsManager.sharedInstance.updateDependencies(self.appDependencies)
        let userManager = PIMUserManager(self.appDependencies.appInfra)
        _ = PIMSettingsManager.sharedInstance.userManager(userManager)
        _ = PIMConfigManager(self.appDependencies.appInfra.serviceDiscovery, userManager)
        PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMInterface", message: "PIMInterace init called")
        
        super.init()
        self.startSilentMigration()
    }
    
    convenience init(dependencies: UAPPDependencies, settings: UAPPSettings?,migrator:PIMMigrator,janrainHandler:PIMJanrainHandler) {
        self.init(dependencies: dependencies, andSettings: settings)
        self.pimMigrator = migrator
        self.janrainHandler = janrainHandler
    }
    
    /**
    PIMInterface instantiateViewController will initializes the rootviewcontroller of the uApp
    - Parameter launchInput: Instance of UAPPLaunchInput class,for setting the parameters needed for launch of uAPP
    - Parameter completionHandler: Block for handling error
    - Returns: An instance of UAPP UIViewController which will be used for launching the uApp
    - Since: 1904.0
    */
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        PIMSettingsManager.sharedInstance.setPIMCompletionHandler(completionHandler: completionHandler)
        return viewControllerFromStoryboard()
    }

}

// Other public methods
extension PIMInterface {
    /**
    * This interface includes APIs to use UserDataInterface related API's
     - Returns: object conforming to UserDataInterface protocol
     - Since: 1904.0
     */
    public func userDataInterface() -> UserDataInterface {
        return PIMDataImplementation(PIMSettingsManager.sharedInstance.pimUserManagerInstance())
    }
    
    /**
    * Public API to do migration from legacy UR to UDI
     - Parameter completionHandler: Block for handling error
     - Since: 1904.0
     */
    public func migrateJanrainUserToPIM(completionHandler:  ((NSError?) -> Void)?) {
        self.migrationCompletionHandler = completionHandler
        self.startSilentMigration()
    }
    
    /**
    * Public API to handle URI redirection from outside app context to UDI
     - Parameter url: redirection URL
     - Since: 1904.0
     */
    public func startRedireURIHandling(url:URL) {
        if self.pimViewController != nil {
            self.pimViewController?.handleURLRedirection(url)
        } else {
            PIMAuthManager().loginRedirectedUser(url: url)
        }
    }
}

// Private methods
extension PIMInterface {
    
    private func viewControllerFromStoryboard() -> UIViewController? {
        let userState = PIMSettingsManager.sharedInstance.pimUserManagerInstance().getUserLoggedInState()
        let viewControllerID = (userState != .userNotLoggedIn) ? UDIStoryboard.udiProfileScene : UDIStoryboard.udiLoginScene
        return PIMUtilities.getUDIViewController(storyboard: viewControllerID)
    }
    
    private func canMigrationStart() -> Bool {
        let settingsManager = PIMSettingsManager.sharedInstance
        var canMigrationStart = false
        
        //user was logged in via pim earlier and   //User is logged/logging into PIM via migration
        let userState = settingsManager.pimUserManagerInstance().getUserLoggedInState()
        guard  userState == .userNotLoggedIn else {
            self.clearMigrationInstances(error:nil)
            return canMigrationStart
        }
        
        //Migration is currently happening
        guard PIMSettingsManager.sharedInstance.isUserMigrating == false else {
            return canMigrationStart
        }
        self.instantiateJRHandler()
        guard self.janrainHandler?.doJanrainUserExists() == true else {
            let error = PIMErrorBuilder.buildUserNotLoggedInError()
            self.clearMigrationInstances(error: error)
            return canMigrationStart
        }
        canMigrationStart = true
        
        return canMigrationStart
    }
    
    private func instantiateJRHandler() {
        if self.janrainHandler == nil { self.janrainHandler = PIMJanrainHandler() }
    }
    
    private func instantiateMigrator() {
        if self.pimMigrator == nil { self.pimMigrator = PIMMigrator() }
    }
    
    private func startSilentMigration() {
        guard self.canMigrationStart() == true else {
            return
        }
        // Set migration flag to determine user is a migration user
        PIMSettingsManager.sharedInstance.isUserMigrating = true
        self.janrainHandler?.refreshUserJanrainAccessToken { token,error  in
            guard error == nil, let jrToken = token else {
                self.clearMigrationInstances(error:error as NSError?)
                return
            }
            self.performMigration(withToken: jrToken)
        }
    }
    
    private func performMigration(withToken token:String) {
        self.instantiateMigrator()
        self.pimMigrator?.migrateUserToPIM(token: token, completionHandler: {
            error,token in
            if token != nil {
                PIMUserManager.setMigrationUserFlag()
            }
            if let aError = error {
                PIMUtilities.tagUDIError(.technicalError, inError: aError, errorType: PIMConstants.TaggingKeys.MIGRATION_SESSION, serverName: nil)
            }
            self.clearMigrationInstances(error:error)
        })
    }
    
    private func clearMigrationInstances(error:NSError?) {
        if (error == nil) {
            // Migration successful. So deleting legacy keychain data as not required anymore
            self.appDependencies.appInfra?.storageProvider.removeValue(forKey: PIMConstants.LegacyJanrainKeys.JANRAIN_CAPTURE_USER)
            self.janrainHandler?.deleteDataFromKeychain(tokenName: PIMConstants.LegacyJanrainKeys.JANRAIN_ACCESS_TOKEN)
            self.janrainHandler?.deleteDataFromKeychain(tokenName: PIMConstants.LegacyJanrainKeys.JANRAIN_REFRESH_SECRET)
        }
        self.migrationCompletionHandler?(error)
        PIMSettingsManager.sharedInstance.isUserMigrating = false
        self.migrationCompletionHandler = nil
        self.pimMigrator = nil
        self.janrainHandler = nil
    }
}
