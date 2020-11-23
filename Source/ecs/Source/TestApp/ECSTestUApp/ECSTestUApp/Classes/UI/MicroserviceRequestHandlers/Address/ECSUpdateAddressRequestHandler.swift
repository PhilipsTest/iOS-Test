/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK

class ECSUpdateAddressRequestHandler: ECSBaseAddressRequestHandler, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    var textFieldValueMapper = [ECSMicroServiceInputIndentifier.selectAddress.rawValue: "",
                                ECSMicroServiceInputIndentifier.firstName.rawValue: "",
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
                                ECSMicroServiceInputIndentifier.country.rawValue: ""]
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.savedAddresses = nil
    }
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        return true
    }
    
    func populateDefaultValue(textField: UITextField?) {
        if let textField = textField {
            if textField.tag == ECSMicroServiceInputIndentifier.selectAddress.rawValue {
                if let text = textField.text, text.count > 0 {
                    textField.text = textFieldValueMapper[textField.tag]
                } else {
                    if let address = ECSTestMasterData.sharedInstance.savedAddresses?.first,
                        let addressId = address.addressID {
                        textField.text = addressId
                        textFieldValueMapper[textField.tag] = textField.text
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.updateAllValuesFor(addressID: addressId)
                        }
                        return
                    }
                }
            } else {
                textField.text = textFieldValueMapper[textField.tag]
            }
        }
    }
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            return ECSTestMasterData.sharedInstance.savedAddresses?.count ?? 0
        case ECSMicroServiceInputIndentifier.countryISO.rawValue:
            return ECSTestMasterData.sharedInstance.regions?.count ?? 0
        default:
            return 0
        }
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            return ECSTestMasterData.sharedInstance.savedAddresses?[row].addressID ?? ""
        case ECSMicroServiceInputIndentifier.countryISO.rawValue:
            return ECSTestMasterData.sharedInstance.regions?[row].name ?? ""
        default:
            return ""
        }
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            guard let addresses = ECSTestMasterData.sharedInstance.savedAddresses, addresses.count > 0 else {
                return
            }
            if let selectedAddressID = addresses[row].addressID {
                let addressTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectAddress.rawValue) as? UITextField
                addressTextField?.text = selectedAddressID
                updateAllValuesFor(addressID: selectedAddressID)
            }
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
        textFieldValueMapper = [ECSMicroServiceInputIndentifier.selectAddress.rawValue: "",
                                ECSMicroServiceInputIndentifier.firstName.rawValue: "",
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
                                ECSMicroServiceInputIndentifier.country.rawValue: ""]
    }
    
    func executeRequest() {

        if let inputViewController = inputViewController,
            let selectedAddress = ECSTestMasterData.sharedInstance.savedAddresses?.first(where: { $0.addressID == textFieldValueMapper[ECSMicroServiceInputIndentifier.selectAddress.rawValue] })  {
            let newAddress = constructAddress(valueMapper: textFieldValueMapper, savedAddress: selectedAddress)
            var responseData, errorData: String?
            
            switch inputViewController.microServiceInput?.microServiceIdentifier {
            case ECSMicroServicesIndentifier.updateAddressWithSuccessReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.updateAddress(address: newAddress, completionHandler: { (success, error) in
                    if success {
                        if let addressIndex = ECSTestMasterData.sharedInstance.savedAddresses?.firstIndex(where: { $0.addressID == selectedAddress.addressID }) {
                            ECSTestMasterData.sharedInstance.savedAddresses?[addressIndex] = newAddress
                        }
                    }
                    responseData = success.description
                    errorData = error?.fetchResponseErrorMessage()
                    self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
                })
            case ECSMicroServicesIndentifier.updateAddressWithAddressListReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.updateAddressWith(address: newAddress, completionHandler: { (addresses, error) in
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
        } else {
            inputViewController?.executeRequestButton.isActivityIndicatorVisible = false
            inputViewController?.navigationController?.view.isUserInteractionEnabled = true
        }
    }
}

extension ECSUpdateAddressRequestHandler {
    
    func updateAllValuesFor(addressID: String) {
        if let selectedAddress = ECSTestMasterData.sharedInstance.savedAddresses?.first(where: { $0.addressID == addressID }) {
            let addressFieldValueMapper = [ECSMicroServiceInputIndentifier.firstName: selectedAddress.firstName,
                                           ECSMicroServiceInputIndentifier.houseNumber: selectedAddress.firstName,
                                           ECSMicroServiceInputIndentifier.lastName: selectedAddress.lastName,
                                           ECSMicroServiceInputIndentifier.line1: selectedAddress.line1,
                                           ECSMicroServiceInputIndentifier.line2: selectedAddress.line2,
                                           ECSMicroServiceInputIndentifier.town: selectedAddress.town,
                                           ECSMicroServiceInputIndentifier.phone: selectedAddress.phone,
                                           ECSMicroServiceInputIndentifier.phone1: selectedAddress.phone1,
                                           ECSMicroServiceInputIndentifier.phone2: selectedAddress.phone2,
                                           ECSMicroServiceInputIndentifier.postalCode: selectedAddress.postalCode,
                                           ECSMicroServiceInputIndentifier.titleCode: selectedAddress.titleCode,
                                           ECSMicroServiceInputIndentifier.countryISO: selectedAddress.region?.isocodeShort,
                                           ECSMicroServiceInputIndentifier.country: selectedAddress.country?.isocode]
            
            addressFieldValueMapper.forEach { (tag, value) in
                if let textField = inputViewController?.microserviceInputTableView.viewWithTag(tag.rawValue) as? UITextField {
                    textField.text = value
                    textFieldValueMapper[textField.tag] = value
                }
            }
        }
    }
}
