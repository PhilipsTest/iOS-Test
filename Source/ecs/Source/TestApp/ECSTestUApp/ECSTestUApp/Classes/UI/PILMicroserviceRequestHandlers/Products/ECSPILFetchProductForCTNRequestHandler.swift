/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSPILFetchProductForCTNRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.pilProductList = nil
    }
    
    func executeRequest() {
        
        let productCTNField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.productCTN.rawValue) as? UITextField
        let productCTN = productCTNField?.text ?? ""
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchECSProductFor(ctn: productCTN, completionHandler: { (product, error) in
            if let product = product {
                ECSTestMasterData.sharedInstance.pilProductList = [product]
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(product) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
