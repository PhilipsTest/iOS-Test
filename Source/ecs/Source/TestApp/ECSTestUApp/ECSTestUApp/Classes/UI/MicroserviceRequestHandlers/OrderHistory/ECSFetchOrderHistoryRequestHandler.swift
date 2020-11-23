/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSFetchOrderHistoryRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        if let textField = textField, let text = textField.text {
            switch textField.tag {
            case ECSMicroServiceInputIndentifier.currentPage.rawValue:
                fallthrough
            case ECSMicroServiceInputIndentifier.pageSize.rawValue:
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
            case ECSMicroServiceInputIndentifier.currentPage.rawValue:
                textField.text = "0"
            case ECSMicroServiceInputIndentifier.pageSize.rawValue:
                textField.text = "20"
            default:
                break
            }
        }
    }
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.orderHistory = nil
    }
    
    func executeRequest() {
        var responseData, errorData: String?
        
        let pageSizeField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.pageSize.rawValue) as? UITextField
        let currentPageField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.currentPage.rawValue) as? UITextField
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchOrderHistory(pageSize: Int(pageSizeField?.text ?? "") ?? 0, currentPage: Int(currentPageField?.text ?? "") ?? 0, completionHandler: { (orderHistory, error) in
            if let orderHistory = orderHistory {
                ECSTestMasterData.sharedInstance.orderHistory = orderHistory
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(orderHistory) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
