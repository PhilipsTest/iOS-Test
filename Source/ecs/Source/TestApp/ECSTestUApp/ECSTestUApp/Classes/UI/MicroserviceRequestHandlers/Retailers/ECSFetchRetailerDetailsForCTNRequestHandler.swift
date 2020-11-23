/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSTestFetchRetailerDetailsForCTNRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func executeRequest() {
        
        let productCTNField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.productCTN.rawValue) as? UITextField
        let productCTN = productCTNField?.text ?? ""
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchRetailerDetailsFor(productCtn: productCTN, completionHandler: { (retailers, error) in
            if let retailers = retailers {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(retailers) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
