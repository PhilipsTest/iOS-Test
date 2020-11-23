/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol MECAddressPopoverPresentationProtocol: NSObjectProtocol {
    func displaySalutationPopoverFrom(textField: MECAddressTextField)
    func displayStatePopoverFrom(textField: MECAddressTextField)
}

protocol MECAddressFetchLocaleProtocol: NSObjectProtocol {
    func fetchLocaleOfAddress() -> String?
}

class MECAddressFieldView: UIView {

    var mainAddressView: UIView!

    @IBOutlet var addressFieldsSectionView: [UIDView]!
    @IBOutlet var addressFieldViews: [MECAddressView]!
    /*
     This workaround is added to fix the compiler warning which gets generated when Build library for distribution is enabled.
     */
    @IBOutlet var addressFieldBaseTextFields: [UIDTextField]!
    var addressFieldTextFields: [MECAddressTextField]! {
        return addressFieldBaseTextFields as? [MECAddressTextField]
    }
    @IBOutlet weak var firstNameLabel: UIDLabel!
    @IBOutlet weak var lastNameLabel: UIDLabel!

    weak var popoverDisplayDelegate: MECAddressPopoverPresentationProtocol?
    weak var addressFetchLocaleDelegate: MECAddressFetchLocaleProtocol?

    subscript(textFieldIdentifier: String) -> MECAddressTextField? {
        return addressFieldTextFields.first { $0.addressTextFieldIdentifier == textFieldIdentifier }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

extension MECAddressFieldView {

    private func setupView() {
        mainAddressView = loadViewFromNib()
        mainAddressView.frame = bounds
        addSubview(mainAddressView)
        addAccessibilityTags()
        addressFieldsSectionView.forEach { (section) in
            section.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
            section.layer.cornerRadius = UIDSize8/4
            section.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground?.cgColor
            section.layer.borderWidth = 1.5
        }
        addressFieldViews.forEach { $0.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground }
        addressFieldTextFields
            .forEach { $0.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground }
        addressFieldTextFields.forEach { (textField) in
            textField.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultFocusBackground
            textField.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultText
        }
    }

    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: MECNibName.MECAddressFieldView, bundle: MECUtility.getBundle())
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView(frame: .zero)
        }
        return view
    }

    func addAccessibilityTags() {
        if let identifier = accessibilityIdentifier {
            addressFieldTextFields.forEach { $0.accessibilityIdentifier = "\(identifier)_\($0.accessibilityIdentifier ?? "")" }
        }
    }
}

extension MECAddressFieldView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? MECAddressTextField {
            switch textField.addressTextFieldIdentifier {
            case MECConstants.MECAddressStateKey:
                popoverDisplayDelegate?.displayStatePopoverFrom(textField: textField)
                mainAddressView.endEditing(true)
                return false
            case MECConstants.MECAddressSalutationKey:
                popoverDisplayDelegate?.displaySalutationPopoverFrom(textField: textField)
                mainAddressView.endEditing(true)
                return false
            default:
                break
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textField = textField as? MECAddressTextField {
            textField.validateAndReturnValidationResult(locale: addressFetchLocaleDelegate?.fetchLocaleOfAddress() ?? "")
        }
    }
}
