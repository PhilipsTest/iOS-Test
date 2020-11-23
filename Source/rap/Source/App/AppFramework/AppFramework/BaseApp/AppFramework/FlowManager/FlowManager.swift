/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework

class FlowManager : BaseFlowManager {
    
    /**
     Returns singleton instance of this class
     */
    static let sharedInstance = FlowManager()
    
    fileprivate override init() {
        super.init()
    }
    
    override func populateStateMap(_ stateMap: inout StateMapType) {
        stateMap[AppStates.Splash] = SplashState()
        stateMap[AppStates.Welcome] = WelcomeState()
        stateMap[AppStates.UserRegistration] = UserRegistrationState()
        stateMap[AppStates.InAppPurchase] = InAppPurchaseState()
        stateMap[AppStates.HamburgerMenu] = HamburgerMenuState()
        stateMap[AppStates.Home] = HomeState()
        stateMap[AppStates.UserRegistrationEnvironmentSettings] = UserRegEnvSettingsState()
        stateMap[AppStates.ConsumerCare] = ConsumerCareState()
        stateMap[AppStates.ProductRegistration] = ProductRegistrationState()
        stateMap[AppStates.About] = AboutState()
        stateMap[AppStates.LogoutHome] = LogoutHomeState()
        stateMap[AppStates.UserRegistrationWelcome] = UserRegistrationWelcomeState()
        stateMap[AppStates.UserRegistrationSettings] = UserRegistrationSettingsState()
        stateMap[AppStates.InAppPurchaseCatalogueView] = InAppPurchaseCatalogueViewState()
        stateMap[AppStates.InAppPurchaseCart] = InAppPurchaseCartState()
        stateMap[AppStates.InAppPurchaseOrderHistory] = InAppPurchaseOrderHistoryState()
        stateMap[AppStates.ComponentVersions] = ComponentVersionsState()
        stateMap[AppStates.TestDemoApps] = ChapterListState()
        stateMap[AppStates.TermsAndPrivacy] = TermsAndPrivacyState()
        stateMap[AppStates.DemoInAppState] = DemoInAppPurchaseState()
        stateMap[AppStates.DemoMobileEcommerce] = DemoMobileEcommerceState()
        stateMap[AppStates.TestEcommerceState] = TestEcommerceState()
        stateMap[AppStates.DemoUserRegistrationState] = DemoUserRegistrationState()
        stateMap[AppStates.DemoAppInfraState] = DemoAppInfraState()
        stateMap[AppStates.DemoProductRegistrationState] = DemoProductRegistrationState()
        stateMap[AppStates.DemoConsumerCareState] = DemoConsumerCareState()
        stateMap[AppStates.DemoChatbotState] = DemoChatbotState()
        stateMap[AppStates.MyAccount] = MyAccountState()
        stateMap[AppStates.PrivacySettings] = PrivacySettingsState()
        stateMap[AppStates.MyDetails] = MyDetailsState()
        stateMap[AppStates.UserOptin] = UserOptinState()
        stateMap[AppStates.CookieConsent] = CookieState()

    }
    
    override func populateConditionMap(_ conditionMap: inout ConditionMapType) {
        conditionMap[AppConditions.IsDonePressed] = WelcomeDonePressedCondition()
        conditionMap[AppConditions.IsLoggedIn] = LoginCondition()
        conditionMap[AppConditions.IsOnboardingComplete] = OnboardingCompleteCondition()
        conditionMap[AppConditions.IsCookieConsentProvided] = CookieConsentCondition()
        conditionMap[AppConditions.IsUserVerified] = UserLoggedInCondition()
    }
}
