/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework
import ConsentWidgets
import PlatformInterfaces
import Firebase

class PrivacySettingsState: BaseState, ConsentWidgetCenterPrivacyProtocol, AIConsentStatusChangeProtocol {

    var consentWidgetInterface : ConsentWidgetsInterface?
    var consentViewController : UIViewController?
    
    override init() {
        super.init(stateId : AppStates.PrivacySettings)
        let dependency = ConsentWidgetsDependencies()
        dependency.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        consentWidgetInterface = ConsentWidgetsInterface(dependencies: dependency, andSettings: nil)
    }
    
    override func getViewController() -> UIViewController? {
        if let consentController = getConsentIntialViewController() {
            return consentController
        }
        return nil
    }
    
    
    // Gives the viewController of the consent center which displays all the app-related Consents.
    func getConsentIntialViewController() -> UIViewController? {
        let consentDefinitions = ConsentBootstrapper.sharedInstance.consentDefinitions
        let launchInput: ConsentWidgetsLaunchInput = ConsentWidgetsLaunchInput(consentDefinitions: consentDefinitions, privacyDelegate: self)
        if let clickStreamConsentDefinition = ConsentBootstrapper.sharedInstance.getClickStreamConsentDefinition() {
            AppInfraSharedInstance.sharedInstance.appInfraHandler?.consentManager.addConsentStatusChanged?(delegate: self, for: clickStreamConsentDefinition)
        }
        consentViewController = consentWidgetInterface?.instantiateViewController(launchInput, withErrorHandler:nil)
        return consentViewController
    }
    
    deinit {
        if let clickStreamConsentDefinition = ConsentBootstrapper.sharedInstance.getClickStreamConsentDefinition() {
            AppInfraSharedInstance.sharedInstance.appInfraHandler?.consentManager.removeConsentStatusChanged?(delegate: self, for: clickStreamConsentDefinition)
        }
    }

    func userClickedOnPrivacyURL() {
        if let privacyVC = consentViewController {
            TermsAndPrivacyHelper().launchPrivacyPolicy(fromViewController: privacyVC, withTitle: Constants.PRIVACY_POLICY_TEXT)
        }
    }
    
    public func consentStatusChanged(for consentDefinition: ConsentDefinition, error: NSError?, requestedStatus: Bool) {
        if let error = error {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "Consent Change Failure", message: "\(String(describing: consentDefinition.getTypes().first!)) type Consent change request to \(requestedStatus) failed with error \(error.localizedDescription)")
        } else {
            if(requestedStatus){
                AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.enableDeveloperMode(true)
                Analytics.setAnalyticsCollectionEnabled(true)
                AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.updateCache(success:{
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "PrivacySettings", message: "Abtest update cache success")
                }, error: {
                    error in
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "PrivacySettings", message: "Abtest returned error on update cache")
                })
            }else{
                Analytics.resetAnalyticsData()
                Analytics.setAnalyticsCollectionEnabled(false)
            }
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "Consent Change Success", message: "\(String(describing: consentDefinition.getTypes().first!)) type Consent changed to \(requestedStatus)")
        }
    }
}
