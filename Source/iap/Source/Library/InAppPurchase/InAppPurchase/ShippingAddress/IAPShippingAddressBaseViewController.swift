/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

class IAPShippingAddressBaseViewController: IAPBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var continueButton: UIDButton!
    @IBOutlet weak var billingAddressView: UIView!
    @IBOutlet weak var shippingAddressView: UIView!
    @IBOutlet weak var checkBoxView: UIDCheckBox!
    @IBOutlet weak var billingAddressViewheightConstraint: NSLayoutConstraint?
    @IBOutlet weak var shippingAddressListView: IAPAddressListView!
    @IBOutlet weak var billingAddressListView: IAPAddressListView!
    
    var salutationViewController: IAPSalutationViewController?
    var productList = [IAPProductModel]()
    let popoverController = IAPCustomPopoverController()
    var shippingAddressHelper = IAPShippingAddressUtility()
    var savedAddress: IAPUserAddress?
    fileprivate var states: NSArray! = []
    var selectedState: NSDictionary!
    var isStateFieldVisible: Bool = false
    var isEditMode: Bool = false
    var isBillingAddressModeOnly: Bool = false
    var newBillingAddress: IAPUserAddress?
    var selectedTextFieldForPopover: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shippingAddressListView.delegate = self
        shippingAddressListView.savedAddress = savedAddress
        billingAddressListView.delegate = self
        billingAddressListView.savedAddress = savedAddress
        self.checkBoxView.title = IAPLocalizedString("iap_use_as_billing_address")
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }

    func fetchStates() {
        if let countryCode = savedAddress?.countryIsoCode ?? IAPConfiguration.sharedInstance.sharedAppInfra.serviceDiscovery.getHomeCountry() {
            shippingAddressHelper.getRegionsForCountryCode(countryCode) { (regions) in
                self.states = regions
                if regions.count == 0 {
                    self.billingAddressListView.updateStateFieldVisibility(isHidden: true)
                    self.shippingAddressListView.updateStateFieldVisibility(isHidden: true)
                    self.updateContinueButtonState(false)
                }
            }
        }
    }

    func updateUIWithAddress(_ address: IAPUserAddress) {
        guard isBillingAddressModeOnly else {
            self.shippingAddressListView.updateViewWithAddress(address: address)
            return
        }
        self.billingAddressListView.updateViewWithAddress(address: address)
    }

    func updateContinueButtonState(_ showError: Bool) {
        var validity: Bool = true
        if isBillingAddressModeOnly {
            validity = billingAddressListView.updateContinueButtonState(showError)
        } else {
            validity = checkBoxView.isChecked ? shippingAddressListView.updateContinueButtonState(showError) : (shippingAddressListView.updateContinueButtonState(showError) && billingAddressListView.updateContinueButtonState(showError))
        }
        self.continueButton.isEnabled = validity
    }

    func registerForKeyboardNotifications() -> Void {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(IAPShippingAddressBaseViewController.keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(IAPShippingAddressBaseViewController.keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() -> Void {
        let center: NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown (_ notification: Notification) {

        let info: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        if let keyboardRect = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

            let insets: UIEdgeInsets = UIEdgeInsets(top: self.scrollView!.contentInset.top, left: 0, bottom: keyboardRect.size.height+20, right: 0)
            self.scrollView!.contentInset = insets
            self.scrollView!.scrollIndicatorInsets = insets
        }
    }
    
    @objc func keyboardWillBeHidden (_ notification: Notification) {
        self.scrollView!.contentInset = UIEdgeInsets(top: self.scrollView!.contentInset.top, left: 0, bottom: 0, right: 0)
        self.scrollView!.scrollIndicatorInsets = UIEdgeInsets(top: self.scrollView!.contentInset.top, left: 0, bottom: 0, right: 0)
    }
}

// MARK:- address list delegate methods
extension IAPShippingAddressBaseViewController: IAPAddressListViewDelegate {
    func didUpdateTextFieldValues() {
        self.updateContinueButtonState(false)
    }

    func addSalutationSelectorPopover(addressListView: IAPAddressListView, textField: UIDTextField) {
        selectedTextFieldForPopover = textField
        salutationViewController = IAPSalutationViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        salutationViewController?.completion = {(salutation: Salutation) -> Void in
            addressListView.updateSelectedSalution(salutation: salutation)
            self.dismiss(animated: true, completion: nil)
        }
        //Create popover
        popoverController.popOverMenuOnItem(textField.rightView!,
                                            presentationController: salutationViewController ?? UIViewController(),
                                            presentingController: self,
                                            preferredContentSize: CGSize(width: 80, height: 100))
    }

    func showStatesSelectorPopover(textField sender: UIDTextField) {
        selectedTextFieldForPopover = sender
        let viewController = IAPStatesSelectionViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        viewController.delegate = self
        viewController.states = self.states
        popoverController.popOverMenuOnItem(sender.rightView!,
                                            presentationController: viewController,
                                            presentingController: self,
                                            preferredContentSize: CGSize(width: 150,
                                                                         height: 44*CGFloat(self.states.count)))

    }
}

// MARK:- state selection delegate methods
extension IAPShippingAddressBaseViewController: IAPStatesSelectDelegate {
    func didSelectStates(_ states: NSDictionary) {
        self.selectedState = states
        let regionName = states["isocode"] as? String ?? ""
        let twoCharRegionName = regionName.iapCountryCode
        selectedTextFieldForPopover?.text = twoCharRegionName
        dismiss(animated: true, completion: nil)
        self.updateContinueButtonState(false)
    }
}
