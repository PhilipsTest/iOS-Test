/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSCreateAddressRequestHandler: ECSBaseAddressRequestHandler, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    var textFieldValueMapper = [ECSMicroServiceInputIndentifier.firstName.rawValue: "",
    ECSMicroServiceInputIndentifier.houseNumber.rawValue: "",
    ECSMicroServiceInputIndentifier.lastName.rawValue: "",
    ECSMicroServiceInputIndentifier.line1.rawValue: "",
    ECSMicroServiceInputIndentifier.line2.rawValue: "",
    ECSMicroServiceInputIndentifier.town.rawValue: "",
    ECSMicroServiceInputIndentifier.phone.rawValue: "",
    ECSMicroServiceInputIndentifier.phone1.rawValue: "",
    ECSMicroServiceInputIndentifier.phone2.rawValue: "",
    ECSMicroServiceInputIndentifier.postalCode.rawValue: "",
    ECSMicroServiceInputIndentifier.titleCode.rawValue: "",
    ECSMicroServiceInputIndentifier.countryISO.rawValue: "",
    ECSMicroServiceInputIndentifier.country.rawValue: ECSTestDemoConfiguration.sharedInstance.sharedAppInfra?.serviceDiscovery.getHomeCountry() ?? ""]
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.savedAddresses = nil
    }
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        return true
    }
    
    func populateDefaultValue(textField: UITextField?) {
        textField?.text = textFieldValueMapper[textField?.tag ?? 0]
    }
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.countryISO.rawValue:
            return ECSTestMasterData.sharedInstance.regions?.count ?? 0
        default:
            return 0
        }
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.countryISO.rawValue:
            return ECSTestMasterData.sharedInstance.regions?[row].name ?? ""
        default:
            return ""
        }
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.countryISO.rawValue:
            guard let regions = ECSTestMasterData.sharedInstance.regions, regions.count > 0 else {
                return
            }
            let selectedRegion = regions[row]
            let regionTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.countryISO.rawValue) as? UITextField
            regionTextField?.text = selectedRegion.name
        default:
            break
        }
    }
    
    func inputTextFieldDidEndEditing(_ textField: UITextField) {
        textFieldValueMapper[textField.tag] = textField.text
    }
    
    func removeInputValues() {
        textFieldValueMapper = [ECSMicroServiceInputIndentifier.firstName.rawValue: "",
                ECSMicroServiceInputIndentifier.houseNumber.rawValue: "",
                ECSMicroServiceInputIndentifier.lastName.rawValue: "",
                ECSMicroServiceInputIndentifier.line1.rawValue: "",
                ECSMicroServiceInputIndentifier.line2.rawValue: "",
                ECSMicroServiceInputIndentifier.town.rawValue: "",
                ECSMicroServiceInputIndentifier.phone.rawValue: "",
                ECSMicroServiceInputIndentifier.phone1.rawValue: "",
                ECSMicroServiceInputIndentifier.phone2.rawValue: "",
                ECSMicroServiceInputIndentifier.postalCode.rawValue: "",
                ECSMicroServiceInputIndentifier.titleCode.rawValue: "",
                ECSMicroServiceInputIndentifier.countryISO.rawValue: "",
                ECSMicroServiceInputIndentifier.country.rawValue: ECSTestDemoConfiguration.sharedInstance.sharedAppInfra?.serviceDiscovery.getHomeCountry() ?? ""]
    }
    
    func executeRequest() {
        if let inputViewController = inputViewController {
            let newAddress = constructAddress(valueMapper: textFieldValueMapper)
            var responseData, errorData: String?
            
            switch inputViewController.microServiceInput?.microServiceIdentifier {
            case ECSMicroServicesIndentifier.createAddressWithSingleAddressReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.createAddress(address: newAddress, completionHandler: { (address, error) in
                    if let address = address {
                        ECSTestMasterData.sharedInstance.savedAddresses?.append(address)
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        if let data = try? encoder.encode(address) {
                            responseData = String(data: data, encoding: .utf8)
                        }
                    }
                    errorData = error?.fetchResponseErrorMessage()
                    self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
                })
            case ECSMicroServicesIndentifier.createAddressWithAddressListReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.createAddressWith(address: newAddress, completionHandler: { (addresses, error) in
                    if let addresses = addresses {
                        ECSTestMasterData.sharedInstance.savedAddresses = addresses
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        if let data = try? encoder.encode(addresses) {
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
}
