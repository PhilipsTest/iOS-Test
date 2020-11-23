/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import PlatformInterfaces

enum TextFieldIndex: Int {
    case salutation = 0
    case firstName
    case lastName
    case email
    case phone
    case houseNumber
    case line1
    case line2
    case town
    case postalCode
    case regionCode
    case countryCode
}

protocol IAPAddressListViewDelegate: class {
    func showStatesSelectorPopover(textField: UIDTextField)
    func addSalutationSelectorPopover(addressListView: IAPAddressListView, textField: UIDTextField)
    func didUpdateTextFieldValues()
}

class IAPAddressListView: UIView {
    @IBOutlet var addressFieldCollection: [UIDTextField]!
    @IBOutlet var addressViewCollection: [IAPAddressItemView]!
    private var selectedSalutation: Salutation!
    var configurator = IAPAddressFieldConfigurator()
    var view: UIView!
    weak var delegate: IAPAddressListViewDelegate?
    var savedAddress: IAPUserAddress? {
        didSet {
            configureUIControl()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "IAPAddressListView", bundle: IAPUtility.getBundle())
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView(frame: .zero)
        }
        return view
    }

    func configureUIControl() {
        setupDefaultValues()
        configurator.configureAddressView(viewList: addressViewCollection,
                                          for: (savedAddress?.countryIsoCode ?? IAPConfiguration.sharedInstance.sharedAppInfra.serviceDiscovery.getHomeCountry()))
    }

    func updateSelectedSalution(salutation: Salutation) {
        selectedSalutation = salutation
        addressFieldCollection[TextFieldIndex.salutation.rawValue].text = salutation.getLocalizedText()
    }

    func disableOrEnableFieldEntries(_ isEnabled: Bool) {
        let startingRangeIndex = TextFieldIndex.salutation.rawValue
        let endRangeIndex = TextFieldIndex.countryCode.rawValue
        for indexRange in startingRangeIndex ... endRangeIndex {
            self.addressFieldCollection[indexRange].isEnabled = isEnabled
        }
    }

    func updateStateFieldVisibility(isHidden: Bool) {
        addressViewCollection[TextFieldIndex.regionCode.rawValue].isHidden = isHidden
    }

    private func setupDefaultValues() {
        guard let addressCollection = self.addressFieldCollection else {
            return
        }

        if let userDetails = IAPConfiguration.sharedInstance.getUserDetails([UserDetailConstants.EMAIL,UserDetailConstants.GIVEN_NAME,UserDetailConstants.FAMILY_NAME]) {
            addressCollection[TextFieldIndex.email.rawValue].text = userDetails[UserDetailConstants.EMAIL]
            addressCollection[TextFieldIndex.countryCode.rawValue].text = IAPConfiguration.sharedInstance.sharedAppInfra.serviceDiscovery.getHomeCountry()
            addressCollection[TextFieldIndex.firstName.rawValue].text = userDetails[UserDetailConstants.GIVEN_NAME]
            addressCollection[TextFieldIndex.lastName.rawValue].text = userDetails[UserDetailConstants.FAMILY_NAME]
            setupAccessibilityTags()
        }
    }
    
    func setupAccessibilityTags() {
        if let identifier = accessibilityIdentifier {
            addressFieldCollection.forEach { $0.accessibilityIdentifier = "\(identifier)_\($0.accessibilityIdentifier ?? "")" }
        }
    }

    func clearAddressFields() {
        updateUI(address: nil)
        setupDefaultValues()
    }

    func updateViewWithAddress(address: IAPUserAddress) {
        updateUI(address: address)
    }

    private func updateUI(address: IAPUserAddress?) {
        guard let addressCollection = self.addressFieldCollection else {
            return
        }
        if let inAddress = address {
            selectedSalutation = Salutation(rawValue: inAddress.titleCode)
            addressCollection[TextFieldIndex.salutation.rawValue].text  = selectedSalutation.getLocalizedText()?.capitalized
        } else {
            addressCollection[TextFieldIndex.salutation.rawValue].text  = nil
        }
        addressCollection[TextFieldIndex.firstName.rawValue].text   = address?.firstName ?? nil
        addressCollection[TextFieldIndex.lastName.rawValue].text    = address?.lastName ?? nil
        addressCollection[TextFieldIndex.houseNumber.rawValue].text = address?.houseNumber ?? nil
        addressCollection[TextFieldIndex.line1.rawValue].text       = address?.addressLine1 ?? nil
        addressCollection[TextFieldIndex.line2.rawValue].text       = address?.addressLine2 ?? nil
        addressCollection[TextFieldIndex.town.rawValue].text        = address?.town ?? nil
        addressCollection[TextFieldIndex.postalCode.rawValue].text  = address?.postalCode ?? nil
        if let userDetails = IAPConfiguration.sharedInstance.getUserDetails([UserDetailConstants.EMAIL]){
            addressCollection[TextFieldIndex.email.rawValue].text       = userDetails[UserDetailConstants.EMAIL]
        }
        addressCollection[TextFieldIndex.phone.rawValue].text       = address?.phone1 ?? nil
        addressCollection[TextFieldIndex.countryCode.rawValue].text = address?.countryIsoCode ?? nil

        if let countryWithStateCode = address?.regionCode {
            addressCollection[TextFieldIndex.regionCode.rawValue].text = countryWithStateCode.iapCountryCode
        } else {
            addressCollection[TextFieldIndex.regionCode.rawValue].text = nil
        }
    }

    @IBAction func textUpdated(_ sender: UITextField) {
        guard let addressCollection = self.addressFieldCollection else {
            return
        }
        if sender == addressCollection[TextFieldIndex.phone.rawValue] {
            IAPAddressValidator().showPhoneNumberFieldError(sender, country: savedAddress?.countryIsoCode)
        } else {
            IAPAddressValidator().showTextFieldError(sender)
        }
    }

    func updateContinueButtonState(_ showError: Bool) -> Bool {
        guard let addressCollection = self.addressFieldCollection else {
            return false
        }
        var validity = true
        let startingRangeIndex = TextFieldIndex.salutation.rawValue
        let endRangeIndex = TextFieldIndex.countryCode.rawValue
        for indexRange in startingRangeIndex ... endRangeIndex {
            if !addressViewCollection[indexRange].isHidden {
                let textField = addressCollection[indexRange]
                if textField == addressCollection[TextFieldIndex.phone.rawValue] {
                    validity = IAPAddressValidator().isValidMobileNumber(textField.text, country: savedAddress?.countryIsoCode) && validity
                    if showError {
                        IAPAddressValidator().showPhoneNumberFieldError(textField, country: savedAddress?.countryIsoCode)
                    }
                } else {
                    validity = textField.validate(false) && validity
                    if showError {
                        IAPAddressValidator().showTextFieldError(textField)
                    }
                }
            }
        }
        return validity
    }

    func addressForSaving(with savedAddress: IAPUserAddress?) -> IAPUserAddress? {
        let address = IAPUserAddress()
        address.firstName = addressFieldCollection[TextFieldIndex.firstName.rawValue].text
        address.lastName = addressFieldCollection[TextFieldIndex.lastName.rawValue].text
        address.houseNumber = addressFieldCollection[TextFieldIndex.houseNumber.rawValue].text
        address.addressLine1 = addressFieldCollection[TextFieldIndex.line1.rawValue].text
        if let address2 = addressFieldCollection[TextFieldIndex.line2.rawValue].text, address2.length > 0 {
            address.addressLine2 = address2
        } else {
            address.addressLine2 = ""
        }
        address.town = addressFieldCollection[TextFieldIndex.town.rawValue].text
        address.postalCode = addressFieldCollection[TextFieldIndex.postalCode.rawValue].text
        address.countryIsoCode = addressFieldCollection[TextFieldIndex.countryCode.rawValue].text
        address.phone1 = addressFieldCollection[TextFieldIndex.phone.rawValue].text?.replacingOccurrences(of: " ", with: "")
        if savedAddress?.phone2 != nil {
            address.phone2 = savedAddress?.phone2
        } else {
            address.phone2 = address.phone1
        }
        address.titleCode = selectedSalutation.rawValue
        if !addressViewCollection[TextFieldIndex.regionCode.rawValue].isHidden {
            if let countryCode = address.countryIsoCode, let region = addressFieldCollection[TextFieldIndex.regionCode.rawValue].text {
                address.regionCode = countryCode + "-" + region
                address.regionName = address.regionCode
            }
        } else {
            address.regionCode = nil
            address.regionName = nil
        }

        //        if self.selectedState != nil {
        //            let countryCode = shippingAddress.countryIsoCode
        //            shippingAddress.regionCode = countryCode! + "-" + self.collectionOfTextFields![self.textFieldNameLookup("regionCode")].text!
        //            shippingAddress.regionName = shippingAddress.regionCode
        //        } else {
        //            shippingAddress.regionCode = self.savedAddress?.regionCode
        //            shippingAddress.regionName = self.savedAddress?.regionCode
        //        }
        return address
    }
}

extension IAPAddressListView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let dlsTextField = textField as? UIDTextField  else {
            return true
        }

        guard let addressCollection = self.addressFieldCollection else {
            return false
        }
        if textField == addressCollection[TextFieldIndex.regionCode.rawValue] {
            delegate?.showStatesSelectorPopover(textField: dlsTextField)
            view.endEditing(true)
            return false
        } else if textField == addressCollection[TextFieldIndex.salutation.rawValue] {
            delegate?.addSalutationSelectorPopover(addressListView: self, textField: dlsTextField)
            view.endEditing(true)
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let currentTextField = textField as? UIDTextField else {
            return false
        }
        return currentTextField.limitMaxCharacter(range, string: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textUpdated(textField)
        self.delegate?.didUpdateTextFieldValues()
    }
}
