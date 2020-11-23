/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK
import PlatformInterfaces

class ECSOAuthRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        if let textField = textField, let text = textField.text {
            switch textField.tag {
            case ECSMicroServiceInputIndentifier.accessToken.rawValue:
                return text.count > 0 ? false : true
            case ECSMicroServiceInputIndentifier.clientID.rawValue:
                return text.count > 0 ? false : true
            case ECSMicroServiceInputIndentifier.clientSecret.rawValue:
                return text.count > 0 ? false : true
            case ECSMicroServiceInputIndentifier.refreshToken.rawValue:
                return text.count > 0 ? false : true
            case ECSMicroServiceInputIndentifier.grantType.rawValue:
                return text.count > 0 ? false : true
            default:
                return false
            }
        }
        return false
    }
    
    func populateDefaultValue(textField: UITextField?) {
        if let textField = textField {
            switch textField.tag {
            case ECSMicroServiceInputIndentifier.accessToken.rawValue:
                textField.text = ECSTestMasterData.sharedInstance.janrainAccessToken ?? ""
                break
            case ECSMicroServiceInputIndentifier.clientSecret.rawValue:
                let appState = ECSTestDemoConfiguration.sharedInstance.sharedAppInfra?.appIdentity.getAppState()
                textField.text = (appState == .PRODUCTION ? "prod_inapp_54321" : "acc_inapp_12345")
            case ECSMicroServiceInputIndentifier.clientID.rawValue:
                textField.text = ECSOAuthClientID.JANRAIN.rawValue
            case ECSMicroServiceInputIndentifier.refreshToken.rawValue:
                textField.text = ECSTestMasterData.sharedInstance.refreshToken
            case ECSMicroServiceInputIndentifier.grantType.rawValue:
                switch inputViewController?.microServiceInput?.microServiceIdentifier {
                case ECSMicroServicesIndentifier.hybrisOAuthAuthentication.rawValue:
                    if let userDataInterface = ECSTestDemoConfiguration.sharedInstance.userDataInterface {
                        textField.text = userDataInterface.isOIDCToken() ? ECSOAuthGrantType.OIDC.rawValue : ECSOAuthGrantType.JANRAIN.rawValue
                    }
                case ECSMicroServicesIndentifier.hybrisRefreshOAuth.rawValue:
                    textField.text = "refresh_token"
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.refreshToken = nil
    }
    
    func executeRequest() {
        
        let accessTokenField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.accessToken.rawValue) as? UITextField
        let refreshTokenField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.refreshToken.rawValue) as? UITextField
        let clientIDField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.clientID.rawValue) as? UITextField
        let clientSecretField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.clientSecret.rawValue) as? UITextField
        let grantTypeField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.grantType.rawValue) as? UITextField
        
        switch inputViewController?.microServiceInput?.microServiceIdentifier {
        case ECSMicroServicesIndentifier.hybrisOAuthAuthentication.rawValue:
            var responseData, errorData: String?
            var oAuthProvider: ECSOAuthProvider!
            let clientID = ECSOAuthClientID(rawValue: clientIDField?.text ?? "") ?? ECSOAuthClientID.JANRAIN
            if let grantType = ECSOAuthGrantType(rawValue: grantTypeField?.text ?? "") {
                oAuthProvider = ECSOAuthProvider(token: accessTokenField?.text ?? "",
                                                 clientID: clientID,
                                                 clientSecret: clientSecretField?.text ?? "",
                                                 grantType: grantType)
            } else {
                oAuthProvider = ECSOAuthProvider(token: accessTokenField?.text ?? "",
                                                 clientID: clientID,
                                                 clientSecret: clientSecretField?.text ?? "")
                
            }
            
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.hybrisOAuthAuthenticationWith(hybrisOAuthData: oAuthProvider, completionHandler: { (oAuthData, error) in
                if let oAuthData = oAuthData {
                    ECSTestMasterData.sharedInstance.refreshToken = oAuthData.refreshToken
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(oAuthData) {
                        responseData = String(data: data, encoding: .utf8)
                    }
                }
                errorData = error?.fetchResponseErrorMessage()
                self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
            })
        case ECSMicroServicesIndentifier.hybrisRefreshOAuth.rawValue:
            var responseData, errorData: String?
            var oAuthProvider: ECSOAuthProvider!
            let clientID = ECSOAuthClientID(rawValue: clientIDField?.text ?? "") ?? ECSOAuthClientID.JANRAIN
            if let grantType = ECSOAuthGrantType(rawValue: grantTypeField?.text ?? "") {
                oAuthProvider = ECSOAuthProvider(token: refreshTokenField?.text ?? "",
                                                 clientID: clientID,
                                                 clientSecret: clientSecretField?.text ?? "",
                                                 grantType: grantType)
            } else {
                oAuthProvider = ECSOAuthProvider(token: refreshTokenField?.text ?? "",
                                                 clientID: clientID,
                                                 clientSecret: clientSecretField?.text ?? "")
                
            }
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.hybrisRefreshOAuthWith(hybrisOAuthData: oAuthProvider, completionHandler: { (oAuthData, error) in
                if let oAuthData = oAuthData {
                    ECSTestMasterData.sharedInstance.refreshToken = oAuthData.refreshToken
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(oAuthData) {
                        responseData = String(data: data, encoding: .utf8)
                    }
                }
                errorData = error?.fetchResponseErrorMessage()
                self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
            })
        default:
            break
        }
    }
}
