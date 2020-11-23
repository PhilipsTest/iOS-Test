/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK
import AppInfra
import PlatformInterfaces

class MECConfiguration: NSObject {

    static let shared = MECConfiguration()
    var ecommerceService: ECSServices?
    var flowConfiguration: MECFlowConfiguration?
    var sharedAppInfra: AIAppInfra!
    var mecTagging: AIAppTaggingProtocol?
    var mecLogging: AILoggingProtocol?
    var isHybrisAvailable: Bool?
    var bazaarVoiceClientID: String?
    var bazaarVoiceConversationAPIKey: String?
    var bazaarVoiceEnvironment: MECBazaarVoiceEnvironment?
    var locale: String?
    var rootCategory: String?
    var productCategory: String?
    weak var bannerConfigDelegate: MECBannerConfigurationProtocol?
    weak var cartUpdateDelegate: MECCartUpdateProtocol?
    weak var orderFlowCompletionDelegate: MECOrderFlowCompletionProtocol?
    var blacklistedRetailerNames: [String]? = []
    var sharedUDInterface: UserDataInterface?
    var oauthData: ECSOAuthData?
    var supportsHybris: Bool = true
    var supportsRetailers: Bool = true
    var voucherCode: String?
    var maximumCartCount: Int = 0

    private override init() {}

    var isUserLoggedIn: Bool {
        return (sharedUDInterface != nil && sharedUDInterface?.loggedInState() == .userLoggedIn)
    }

    func getUserDetails(_ list: [String]) -> [String: String]? {
        let userDetails =  try? self.sharedUDInterface?.userDetails(list)
        return userDetails as? [String: String]
    }

    func getAccessToken() -> String? {
        getUserDetails([MECConstants.MECAccessToken])?[MECConstants.MECAccessToken]
    }

    func getUserEmailID() -> String? {
        getUserDetails([UserDetailConstants.EMAIL])?[UserDetailConstants.EMAIL]
    }

    func resetSavedUserData() {
        isHybrisAvailable = nil
        if MECUtility.shouldAuthenticateWithHybris() {
            oauthData = nil
        }
    }

    func getDataInterface() -> MECDataInterface {
        return MECDataImplementation.sharedInstance
    }
}
