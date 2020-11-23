/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

// swiftlint:disable file_length

import PhilipsUIKitDLS
import PlatformInterfaces
import PhilipsEcommerceSDK

class MECAddAddressViewController: MECBaseViewController {

    var presenter: MECAddAddressPresenter!
    var addressScreenType: MECAddressScreenType = .addAddress

    @IBOutlet weak var addressScrollView: UIScrollView!
    @IBOutlet weak var addressMainStackView: UIStackView!
    @IBOutlet weak var shippingAddressFields: MECAddressFieldView!
    @IBOutlet weak var addressToggleCheckBox: UIDCheckBox!
    @IBOutlet weak var billingAddressSection: UIStackView!
    @IBOutlet weak var shippingAddressSection: UIStackView!
    @IBOutlet weak var billingAddressFields: MECAddressFieldView!
    @IBOutlet weak var addressBottomView: UIDView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addressToggleCheckBox.title = MECLocalizedString("mec_use_as_billing_address")
        startActivityProgressIndicator(messageText: "")
        let locale = presenter.shippingAddress?.country?.isocode ?? MECConfiguration.shared.locale?.fetchMECCountryCode()
        presenter.configureRegionField(for: locale) { [weak self] in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                self?.configureUI()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var pageName = ""
        switch addressScreenType {
        case .addAddress:
            pageName = MECAnalyticPageNames.createShippingAddressPage
        case .addFirstAddress:
            pageName = MECAnalyticPageNames.createShippingAddressPage
        case .editAddress:
            pageName = MECAnalyticPageNames.editShippingAddressPage
        case .addBillingAddress:
            pageName = MECAnalyticPageNames.createBillingAddressPage
        case .editBillingAddress:
            pageName = MECAnalyticPageNames.editBillingAddressPage
        }
        trackPage(pageName: pageName)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    deinit {
        deregisterFromKeyboardNotifications()
    }
}

extension MECAddAddressViewController {

    @IBAction func addressScreenTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func billingAddressCheckBoxToggled(_ sender: UIDCheckBox) {
        configureBillingAddressSection(isChecked: sender.isChecked)
    }

    @IBAction func saveAddressButtonClicked(_ sender: Any) {
        if isAddressFieldValuesCorrect() {
            saveAddress()
        }
    }
}

extension MECAddAddressViewController {

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MECAddAddressViewController.keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MECAddAddressViewController.keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterFromKeyboardNotifications() {
        let center: NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(_ notification: Notification) {
        if let info = notification.userInfo,
            let keyboardRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            let insets = UIEdgeInsets(top: addressScrollView.contentInset.top,
                                                    left: 0,
                                                    bottom: keyboardRect.size.height+UIDSize20,
                                                    right: 0)
            addressScrollView.contentInset = insets
            addressScrollView.scrollIndicatorInsets = insets
        }
    }

    @objc func keyboardWillBeHidden(_ notification: Notification) {
        addressScrollView.contentInset = UIEdgeInsets(top: addressScrollView.contentInset.top, left: 0, bottom: 0, right: 0)
        addressScrollView.scrollIndicatorInsets = UIEdgeInsets(top: addressScrollView.contentInset.top, left: 0, bottom: 0, right: 0)
    }

    func isAddressFieldValuesCorrect() -> Bool {
        switch addressScreenType {
        case .addFirstAddress:
            return validateFirstAddress()
        case .addAddress, .editAddress:
            return validateShippingAddress()
        case .addBillingAddress, .editBillingAddress:
            return validateBillingAddress()
        }
    }

    func validateFirstAddress() -> Bool {
        if !billingAddressSection.isHidden {
            let isShippingAddressValid = isAddressFieldsValidForSection(addressSection: shippingAddressFields)
            let isBillingAddressValid = isAddressFieldsValidForSection(addressSection: billingAddressFields)
            return isShippingAddressValid && isBillingAddressValid
        }
        return isAddressFieldsValidForSection(addressSection: shippingAddressFields)
    }

    func validateBillingAddress() -> Bool {
        return isAddressFieldsValidForSection(addressSection: billingAddressFields)
    }

    func validateShippingAddress() -> Bool {
        return isAddressFieldsValidForSection(addressSection: shippingAddressFields)
    }

    func populateValuesForSection(addressSection: MECAddressFieldView) {
        populateDefaultValuesForSection(addressSection: addressSection)
        if let salutationCode = presenter.shippingAddress?.titleCode,
            let salutation = MECAddressSalutation(rawValue: salutationCode) {
            addressSection[MECConstants.MECAddressSalutationKey]?.text = salutation.titleForItem()
        }
        addressSection[MECConstants.MECAddressPhoneKey]?.text = presenter.shippingAddress?.phone1
        addressSection[MECConstants.MECAddressHouseNumberKey]?.text = presenter.shippingAddress?.houseNumber
        addressSection[MECConstants.MECAddressLineOneKey]?.text = presenter.shippingAddress?.line1
        addressSection[MECConstants.MECAddressLineTwoKey]?.text = presenter.shippingAddress?.line2
        addressSection[MECConstants.MECAddressTownKey]?.text = presenter.shippingAddress?.town
        addressSection[MECConstants.MECAddressPostalCodeKey]?.text = presenter.shippingAddress?.postalCode
        addressSection[MECConstants.MECAddressStateKey]?.text = presenter.shippingAddress?.region?
            .displayNameFromRegion(fetchedRegions: presenter.fetchedRegions)
    }

    func populateDefaultValuesForSection(addressSection: MECAddressFieldView) {
        let userData = MECConfiguration.shared.getUserDetails([UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME])
        let country = MECConfiguration.shared.locale?.fetchMECCountryCode()
        addressSection[MECConstants.MECAddressFirstNameKey]?.text = presenter.shippingAddress?.firstName
            ?? userData?[UserDetailConstants.GIVEN_NAME]
        addressSection[MECConstants.MECAddressLastNameKey]?.text = presenter.shippingAddress?.lastName
            ?? userData?[UserDetailConstants.FAMILY_NAME]
        addressSection[MECConstants.MECAddressCountryKey]?.text = presenter.shippingAddress?.country?.isocode ?? country
    }

    func configureBillingAddressSection(isChecked: Bool) {
        billingAddressSection.isHidden = isChecked
    }

    func configureUI() {
        title = MECLocalizedString("mec_address")
        addressBottomView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.bottomSheetDefaultBackground
        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
           addressBottomView.apply(dropShadow: UIDDropShadow(level: .level3, theme: theme))
        }
        configureAddressScreen()
        registerForKeyboardNotifications()
    }

    func configureAddressScreen() {
        switch addressScreenType {
        case .addFirstAddress:
            configureFirstAddressScreen()
        case .addAddress:
            configureAddAddressScreen()
        case .editAddress:
            configureEditAddressScreen()
        case .addBillingAddress:
            configureAddBillingAddressSection()
        case .editBillingAddress:
            configureEditBillingAddressSection()
        }
    }

    func saveAddress() {
        switch addressScreenType {
        case .addFirstAddress:
            saveFirstAddress()
        case .addAddress:
            saveNewAddress()
        case .editAddress:
            saveEditedAddress()
        case .addBillingAddress:
            saveNewBillingAddress()
        case .editBillingAddress:
            saveEditedBillingAddress()
        }
    }

    func configureFirstAddressScreen() {
        configureAddressFields(field: shippingAddressFields)
        configureAddressFields(field: billingAddressFields)
        configureBillingAddressSection(isChecked: true)
        populateDefaultValuesForSection(addressSection: shippingAddressFields)
        populateDefaultValuesForSection(addressSection: billingAddressFields)
        shippingAddressFields.popoverDisplayDelegate = self
        billingAddressFields.popoverDisplayDelegate = self
        shippingAddressFields.addressFetchLocaleDelegate = self
        billingAddressFields.addressFetchLocaleDelegate = self
        billingAddressFields.firstNameLabel.text = MECLocalizedString("mec_card_holder_first_name")
        billingAddressFields.lastNameLabel.text = MECLocalizedString("mec_card_holder_last_name")
    }

    func saveFirstAddress() {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        let newShippingAddress = presenter.constructAddressFor(addressView: shippingAddressFields)
        presenter.saveAddress(address: newShippingAddress, completionHandler: { [weak self] (_, error) in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                guard error == nil else {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_address"),
                                    message: error?.localizedDescription,
                                    okButton: okButton, cancelButton: nil)
                    return
                }
                if let deliveryDetailsScreen = MECDeliveryDetailsViewController
                    .instantiateFromAppStoryboard(appStoryboard: .deliveryDetails) {
                    let presenter = MECDeliveryDetailsPresenter(deliveryDetailsDataBus: self?.presenter.dataBus)
                    deliveryDetailsScreen.presenter = presenter
                    self?.navigationController?.replaceLastViewControllerWith(controller: deliveryDetailsScreen, animated: true)
                }
            }
        }, saveAddressCompletionHandler: { [weak self] in
            self?.saveFirstBillingAddress(shippingAddress: newShippingAddress)
        })
    }

    func saveNewAddress() {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        let newShippingAddress = presenter.constructAddressFor(addressView: shippingAddressFields)
        presenter.saveAddress(address: newShippingAddress, completionHandler: { [weak self] (_, error) in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                guard error == nil else {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_address"),
                                    message: error?.localizedDescription,
                                    okButton: okButton,
                                    cancelButton: nil)
                    return
                }
                self?.navigationController?.popViewController(animated: true)
            }
        })
    }

    func configureAddAddressScreen() {
        configureShippingAddressScreen()
        populateDefaultValuesForSection(addressSection: shippingAddressFields)
    }

    func configureEditAddressScreen() {
        configureShippingAddressScreen()
        populateValuesForSection(addressSection: shippingAddressFields)
    }

    func configureShippingAddressScreen() {
        configureAddressFields(field: shippingAddressFields)
        addressToggleCheckBox.isHidden = true
        configureBillingAddressSection(isChecked: true)
        shippingAddressFields.popoverDisplayDelegate = self
        shippingAddressFields.addressFetchLocaleDelegate = self
    }

    func configureAddBillingAddressSection() {
        configureBillingAddressScreen()
        populateDefaultValuesForSection(addressSection: billingAddressFields)
    }

    func configureEditBillingAddressSection() {
        configureBillingAddressScreen()
        populateValuesForSection(addressSection: billingAddressFields)
    }

    func configureBillingAddressScreen() {
        configureAddressFields(field: billingAddressFields)
        addressToggleCheckBox.isHidden = true
        shippingAddressSection.isHidden = true
        configureBillingAddressSection(isChecked: false)
        billingAddressFields.popoverDisplayDelegate = self
        billingAddressFields.addressFetchLocaleDelegate = self
        billingAddressFields.firstNameLabel.text = MECLocalizedString("mec_card_holder_first_name")
        billingAddressFields.lastNameLabel.text = MECLocalizedString("mec_card_holder_last_name")
    }

    func saveEditedAddress() {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        let editedShippingAddress = presenter.constructAddressFor(addressView: shippingAddressFields,
                                                                  currentAddress: presenter.shippingAddress)
        presenter.saveEditedAddress(address: editedShippingAddress) { [weak self] (_, error) in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                guard error == nil else {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_address"),
                                    message: error?.localizedDescription,
                                    okButton: okButton,
                                    cancelButton: nil)
                    return
                }
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    func saveFirstBillingAddress(shippingAddress: ECSAddress?) {
        let newBillingAddress = billingAddressSection.isHidden == true ?
            shippingAddress :
            presenter.constructAddressFor(addressView: billingAddressFields)
        let newPayment = createNewPaymentMethodWith(billingAddress: newBillingAddress)
        presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.append(newPayment)
    }

    func saveNewBillingAddress() {
        let newBillingAddress = presenter.constructAddressFor(addressView: billingAddressFields)
        let newPayment = createNewPaymentMethodWith(billingAddress: newBillingAddress)
        presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.append(newPayment)
        navigationController?.popViewController(animated: true)
    }

    func saveEditedBillingAddress() {
        let editedBillingAddress = presenter.constructAddressFor(addressView: billingAddressFields)
        if let payment = presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.first(where: { $0.isNewPayment() }) {
            payment.billingAddress = editedBillingAddress
        }
        navigationController?.popViewController(animated: true)
    }

    func createNewPaymentMethodWith(billingAddress: ECSAddress?) -> ECSPayment {
        let newPayment = ECSPayment()
        let newCard = ECSCardType()
        newPayment.paymentId = MECConstants.MECNewCardIdentifier
        newCard.name = MECLocalizedString("mec_new_card_text")
        newPayment.card = newCard
        newPayment.billingAddress = billingAddress
        return newPayment
    }

    func isAddressFieldsValidForSection(addressSection: MECAddressFieldView) -> Bool {
        var numberOfInvalidFields: Int = 0
        let locale = presenter.shippingAddress?.country?.isocode ?? MECConfiguration.shared.locale?.fetchMECCountryCode()
        addressSection.addressFieldTextFields.forEach { (textField) in
            if textField.validateAndReturnValidationResult(locale: locale ?? "") {
                numberOfInvalidFields += 1
            }
        }
        return numberOfInvalidFields == 0
    }

    func configureAddressFields(field: MECAddressFieldView) {
        let locale = presenter.shippingAddress?.country?.isocode ?? MECConfiguration.shared.locale?.fetchMECCountryCode()
        if let addressConfigModel = presenter.addressFieldConfigurationData {
            addressConfigModel.addressFields?.forEach({ (addressConfig) in
                if let currentLocale = locale {
                    if addressConfig.unsupportedLocales?.contains(currentLocale) == true {
                        if let addressField = field.addressFieldViews
                            .first(where: { $0.addressViewIdentifier == addressConfig.identifier }) {
                            addressField.isHidden = true
                        }
                    } else {
                        if let identifier = addressConfig.identifier, let textField = field[identifier] {
                            if addressConfig.isEditable == false {
                                textField.isEnabled = false
                            } else {
                                textField.delegate = field
                                configureInputTypeFor(textField: textField, addressConfig: addressConfig)
                            }
                            configureValidatorsFor(textField: textField, addressConfig: addressConfig)
                            if addressConfig.identifier == MECConstants.MECAddressStateKey {
                                configureRegionFieldVisibilityFor(field: field)
                            }
                        }
                    }
                }
            })
        }
    }

    func configureRegionFieldVisibilityFor(field: MECAddressFieldView) {
        if let addressField = field.addressFieldViews.first(where: { $0.addressViewIdentifier == MECConstants.MECAddressStateKey }) {
            if let regions = presenter.fetchedRegions {
                addressField.isHidden = regions.count <= 0
            }
        }
    }

    func configureInputTypeFor(textField: MECAddressTextField, addressConfig: MECAddressFieldConfig) {
        switch addressConfig.inputType {
        case MECAddressTextFieldInputType.integerType.rawValue:
            textField.keyboardType = .phonePad
        case MECAddressTextFieldInputType.stringType.rawValue:
            textField.keyboardType = .default
        case MECAddressTextFieldInputType.dropDownType.rawValue:
            textField.rightViewMode = .always
            textField.rightView = createDropDownIcon()
            textField.layoutSubviews()
            textField.rightView?.isUserInteractionEnabled = false
        default:
            textField.keyboardType = .default
        }
    }

    func configureValidatorsFor(textField: MECAddressTextField, addressConfig: MECAddressFieldConfig) {
        addressConfig.validation?.forEach({ (validation) in
            if let validationType = validation.validationType,
                let fieldValidator = MECAddressValidationFactory.fetchValidatorFor(validationType: validationType) {
                fieldValidator.validationMessage = MECLocalizedString(validation.validationMessage)
                fieldValidator.englishValidationMessage = MECEnglishString(validation.validationMessage)
                textField.validators?.append(fieldValidator)
            }
        })
    }

    func createDropDownIcon() -> UIView? {
        let dropDownStackView = UIStackView.makePreparedForAutoLayout()
        let dropDownIconLabel = UIDLabel.makePreparedForAutoLayout()
        dropDownIconLabel.backgroundColor = .clear
        dropDownIconLabel.font = UIFont.mecIconFont(size: UIDSize16)
        dropDownIconLabel.text = MECIconFont.unicode(iconType: .downArrow)
        dropDownIconLabel.textColor = .lightGray
        dropDownStackView.addArrangedSubview(dropDownIconLabel)
        dropDownStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: UIDSize8)
        dropDownStackView.isLayoutMarginsRelativeArrangement = true
        return dropDownStackView
    }
}

extension MECAddAddressViewController: MECAddressPopoverPresentationProtocol {

    func displaySalutationPopoverFrom(textField: MECAddressTextField) {
        let sautationPopover = MECPopoverViewController.instantiateFromAppStoryboard(appStoryboard: .popoverList)
        let locale = presenter.shippingAddress?.country?.isocode ?? MECConfiguration.shared.locale?.fetchMECCountryCode()
        sautationPopover?.popoverItems = presenter.salutations
        if let textFieldRightView = textField.rightView {
            sautationPopover?.displayPopoverMenu(textFieldRightView,
                                                 presentationController: sautationPopover ?? UIViewController(),
                                                 presentingController: self,
                                                 preferredContentSize: CGSize(width: 80, height: 100),
                                                 completionHandler: { [weak self] (itemIndex: Int) -> Void in
                                                    textField.text = self?.presenter.salutations[itemIndex].titleForItem()
                                                    textField.validateAndReturnValidationResult(locale: locale ?? "")
                                                    self?.dismiss(animated: true, completion: nil)
            })
        }
    }

    func displayStatePopoverFrom(textField: MECAddressTextField) {
        if let fetchedRegions = presenter.fetchedRegions, fetchedRegions.count > 0 {
            let statePopover = MECPopoverViewController.instantiateFromAppStoryboard(appStoryboard: .popoverList)
            let locale = presenter.shippingAddress?.country?.isocode ?? MECConfiguration.shared.locale?.fetchMECCountryCode()
            statePopover?.popoverItems = fetchedRegions
            if let textFieldRightView = textField.rightView {
                statePopover?.displayPopoverMenu(textFieldRightView,
                                                 presentationController: statePopover ?? UIViewController(),
                                                 presentingController: self,
                                                 preferredContentSize: CGSize(width: 150, height: 0),
                                                 completionHandler: { [weak self] (itemIndex: Int) -> Void in
                                                    textField.text = self?.presenter.fetchedRegions?[itemIndex].name
                                                    textField.validateAndReturnValidationResult(locale: locale ?? "")
                                                    self?.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
}

extension MECAddAddressViewController: MECAddressFetchLocaleProtocol {

    func fetchLocaleOfAddress() -> String? {
        return presenter.shippingAddress?.country?.isocode ?? MECConfiguration.shared.locale?.fetchMECCountryCode()
    }
}

// swiftlint:enable file_length
