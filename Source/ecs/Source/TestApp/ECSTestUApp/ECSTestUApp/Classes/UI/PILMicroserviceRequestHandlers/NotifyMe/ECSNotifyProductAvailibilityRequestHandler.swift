/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PlatformInterfaces

class ECSNotifyProductAvailibilityRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        return textField?.tag == ECSMicroServiceInputIndentifier.email.rawValue
    }
    
    func populateDefaultValue(textField: UITextField?) {
        if textField?.tag == ECSMicroServiceInputIndentifier.email.rawValue {
            let emailAddress = try? ECSTestDemoConfiguration.sharedInstance.userDataInterface?.userDetails([UserDetailConstants.EMAIL])[UserDetailConstants.EMAIL] as? String
            textField?.text = emailAddress ?? ""
        }
    }
    
    func executeRequest() {
        var responseData, errorData: String?
        let ctnValue = (inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.productCTN.rawValue) as? UITextField)?.text ?? ""
        let emailValue = (inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.email.rawValue) as? UITextField)?.text ?? ""
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.registerForProductAvailability(email: emailValue, ctn: ctnValue, completionHandler: { (result, error) in
                responseData = result.description
                errorData = error?.fetchResponseErrorMessage()
                self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
