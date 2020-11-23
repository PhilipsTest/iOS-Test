/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSApplyAndRemoveVoucherRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func executeRequest() {
        
        let voucherIDField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.voucherID.rawValue) as? UITextField
        let voucherID = voucherIDField?.text ?? ""
        var responseData, errorData: String?
        
        switch inputViewController?.microServiceInput?.microServiceIdentifier {
        case ECSMicroServicesIndentifier.applyVoucher.rawValue:
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.applyVoucher(voucherID: voucherID, completionHandler: { (vouchers, error) in
                if let vouchers = vouchers {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(vouchers) {
                        responseData = String(data: data, encoding: .utf8)
                    }
                }
                errorData = error?.fetchResponseErrorMessage()
                self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
            })
        case ECSMicroServicesIndentifier.removeVoucher.rawValue:
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.removeVoucher(voucherID: voucherID, completionHandler: { (vouchers, error) in
                if let vouchers = vouchers {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(vouchers) {
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
