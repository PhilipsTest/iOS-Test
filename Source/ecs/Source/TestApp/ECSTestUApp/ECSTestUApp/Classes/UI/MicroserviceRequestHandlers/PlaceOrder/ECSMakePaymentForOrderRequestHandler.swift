/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSMakePaymentForOrderRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.selectOrder.rawValue:
            return ECSTestMasterData.sharedInstance.placedOrderDetail == nil ? 0 : 1
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            return ECSTestMasterData.sharedInstance.savedAddresses?.count ?? 0
        default:
            return 0
        }
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.selectOrder.rawValue:
            return ECSTestMasterData.sharedInstance.placedOrderDetail?.orderID ?? ""
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            return ECSTestMasterData.sharedInstance.savedAddresses?[row].addressID ?? ""
        default:
            return ""
        }
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.selectOrder.rawValue:
            let selectedOrder = ECSTestMasterData.sharedInstance.placedOrderDetail?.orderID
            let orderTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectOrder.rawValue) as? UITextField
            orderTextField?.text = selectedOrder
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            guard let addresses = ECSTestMasterData.sharedInstance.savedAddresses, addresses.count > 0 else {
                return
            }
            let selectedAddress = addresses[row].addressID
            let addressTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectAddress.rawValue) as? UITextField
            addressTextField?.text = selectedAddress
        default:
            break
        }
    }
    
    func executeRequest() {
        
        var responseData, errorData: String?
        let orderDetailTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectOrder.rawValue) as? UITextField
        let addressTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectAddress.rawValue) as? UITextField
        
        if let _ = orderDetailTextField?.text,
            let selectedOrder = ECSTestMasterData.sharedInstance.placedOrderDetail,
            let selectedAddress = ECSTestMasterData.sharedInstance.savedAddresses?.first(where: { $0.addressID == addressTextField?.text }) {
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.makePaymentFor(order: selectedOrder, billingAddress: selectedAddress, completionHandler: { (payment, error) in
                if let payment = payment {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(payment) {
                        responseData = String(data: data, encoding: .utf8)
                    }
                }
                errorData = error?.fetchResponseErrorMessage()
                self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
            })
        } else {
            inputViewController?.executeRequestButton.isActivityIndicatorVisible = false
            inputViewController?.navigationController?.view.isUserInteractionEnabled = true
        }
    }
}
