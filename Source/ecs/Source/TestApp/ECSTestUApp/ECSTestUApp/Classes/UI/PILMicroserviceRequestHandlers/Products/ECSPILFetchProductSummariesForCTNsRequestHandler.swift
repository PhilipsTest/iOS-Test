/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSPILFetchProductSummariesForCTNsRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.pilProductList = nil
    }
    
    func executeRequest() {
        
        let productCTNsField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.productCTNs.rawValue) as? UITextField
        
        let productCTNs = productCTNsField?.extractCTNs()
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchECSProductSummariesFor(ctns: productCTNs ?? [], completionHandler: { (products, invalidCTNs, error) in
            responseData = invalidCTNs?.count ?? 0 > 0 ? "Invalid Ctns: \(invalidCTNs?.description ?? "")" : ""
            if let products = products {
                ECSTestMasterData.sharedInstance.pilProductList = products
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(products) {
                    responseData = "\(responseData ?? "")\n \n \(String(data: data, encoding: .utf8) ?? ""))"
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
