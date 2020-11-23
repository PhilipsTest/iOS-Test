/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AVFoundation
import PhilipsEcommerceSDK
import PlatformInterfaces

class MECOAuthHandler: NSObject, MECAnalyticsTracking {
    static let shared = MECOAuthHandler()
    var completionHandler: ((_ sucess: Bool, _ error: Error?) -> Void)?

    func refreshHybris(completionHandler:@escaping(_ sucess: Bool, _ error: Error?) -> Void) {

        guard let refreshToken = MECConfiguration.shared.oauthData?.refreshToken else {
            completionHandler(false, nil)
            return
        }

        let oauthProvider = ECSOAuthProvider(token: refreshToken)
        MECConfiguration.shared.ecommerceService?.hybrisRefreshOAuthWith(hybrisOAuthData: oauthProvider,
                                                                         completionHandler: { [weak self] (oauthData, error) in
                                                                            guard let weakSelf = self else { return }
            guard let error = error else {
                MECConfiguration.shared.oauthData = oauthData
                completionHandler(true, nil)
                return
            }
            guard error.code == 5000 || error.code == 6025 else {
                weakSelf.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.hybrisOAuthAuthenticationWith,
                                          serverName: MECAnalyticServer.hybris, error: error)
                completionHandler(false, error)
                return
            }
            weakSelf.completionHandler = completionHandler
            MECConfiguration.shared.oauthData = nil
            MECConfiguration.shared.sharedUDInterface?.addUserDataInterfaceListener(weakSelf)
            MECConfiguration.shared.sharedUDInterface?.refreshSession()
        })
    }

    func oauthHybris(completionHandler:@escaping(_ sucess: Bool, _ error: Error?) -> Void) {

        guard MECConfiguration.shared.oauthData == nil else {
            completionHandler(true, nil)
            return
        }

        guard let accessToken = MECConfiguration.shared.getAccessToken() else {
            completionHandler(false, NSError(domain: MECErrorDomain.MECAuthentication,
                                             code: 100,
                                             userInfo: [NSLocalizedDescriptionKey: MECLocalizedString("mec_cart_login_error_message")]))
            return
        }

        if let sharedDataInterface = MECConfiguration.shared.sharedUDInterface {
            let grantType = sharedDataInterface.isOIDCToken() ? ECSOAuthGrantType.OIDC : ECSOAuthGrantType.JANRAIN
            let outhProvider = ECSOAuthProvider(token: accessToken, grantType: grantType)
            MECConfiguration.shared.ecommerceService?.hybrisOAuthAuthenticationWith(hybrisOAuthData: outhProvider,
                                                                                    completionHandler: { (oauthData, error) in
                guard let errorCode = error?.code, (errorCode == 5000 || errorCode == 6025) else {
                    MECConfiguration.shared.oauthData = oauthData
                    MECUtility.saveUserEmailInformation()
                    completionHandler(true, nil)
                    return
                }
                self.completionHandler = completionHandler
                sharedDataInterface.addUserDataInterfaceListener(self)
                sharedDataInterface.refreshSession()
            })
        }
    }
}

extension MECOAuthHandler: UserDataDelegate {
    func refreshSessionSuccess() {
        guard let completionBlock = self.completionHandler else { return }
        oauthHybris(completionHandler: completionBlock)
    }

    func refreshSessionFailed(_ error: Error) {
        guard let completionBlock = self.completionHandler else { return }
        completionBlock(false, error)
    }
}
