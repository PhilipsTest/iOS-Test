/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSSubmitOrderRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.placedOrderDetail = nil
    }
    
    func executeRequest() {

        let cvvTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.cvvCode.rawValue) as? UITextField
        let ctnText: String? = (cvvTextField?.text ?? "").count > 0 ? cvvTextField?.text : nil
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.submitOrder(cvvCode: ctnText, completionHandler: { (orderDetail, error) in
            if let orderDetail = orderDetail {
                ECSTestMasterData.sharedInstance.placedOrderDetail = orderDetail
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(orderDetail) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
