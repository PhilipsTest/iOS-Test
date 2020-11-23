/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import AppInfra

class IAPShippingAddressEditViewController: IAPShippingAddressBaseViewController, IAPBuyDirectCartProtocol,
IAPNavigationControllerBackButtonDelegate, IAPBuyDirectLeftToRightSwipeProtocol {
    var cartInfo: IAPCartInfo!
    var cartSyncHelper = IAPCartSyncHelper()
    var addressSyncHelper = IAPAddressSyncHelper()

    @IBOutlet weak var stepLabel: UIDLabel!
    @IBOutlet weak var stepView: UIDView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = IAPLocalizedString("iap_checkout")
        updateUI()
        self.fetchStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var pageName: String = IAPConstants.IAPAppTaggingStringConstants.kShippingAddressPageName
        if self.isEditMode == true {
            stepLabel.text = IAPLocalizedString("iap_checkout_steps","1")
            pageName = IAPConstants.IAPAppTaggingStringConstants.kShippingAddressEditPageName
            shippingAddressView.isHidden = false
            billingAddressView.isHidden = true
            checkBoxView.isHidden = true
        } else {
            if isBillingAddressModeOnly {
                stepLabel.text = IAPLocalizedString("iap_chckout_payment_steps","2")
                shippingAddressView.isHidden = true
                billingAddressView.isHidden = false
                checkBoxView.isHidden = false
                disableOrEnableFieldEntries(false)
                pageName = IAPConstants.IAPAppTaggingStringConstants.kBillingAddressPageName
            } else {
                stepLabel.text = IAPLocalizedString("iap_checkout_steps","1")
                shippingAddressView.isHidden = false
                billingAddressView.isHidden = true
                checkBoxView.isHidden = false
                pageName = IAPConstants.IAPAppTaggingStringConstants.kShippingAddressPageName
            }
        }
        trackPage(pageName: pageName)
        guard true == self.isFromBuyDirect() else { return }
        self.navigationController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }
    
    // MARK: -
    // MARK: Navigation related methods
    // MARK: -
    func viewControllerShouldPopOnBackButton() -> Bool {
        guard false == self.isFromBuyDirect() else {
            self.deleteBuyDirectCartAndPop()
            return false
        }
        return true
    }
    
    @IBAction func cancel(_ sender: UIDButton) {
        self.handlePossibleBuyDirectCancel()
    }
    
    // MARK: Private methods
    private func updateUI () {
        stepView.backgroundColor? = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryBackground)!
        stepLabel.textColor = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryText)!
        self.continueButton.isEnabled = false
        if let address = savedAddress {
            self.populateTextFieldsForSavedAddress(address)
        }
        if self.isEditMode {
            self.continueButton.setTitle(IAPLocalizedString("iap_save"), for: UIControl.State())
        }
    }

    func navigationController(_ navigationController: UINavigationController,
                              willShowViewController viewController: UIViewController, animated: Bool) {
        self.handleSwipeLeftToRight(navigationController, willShowViewController: viewController, animated: animated)
    }

    func populateTextFieldsForSavedAddress(_ address: IAPUserAddress) {
        updateUIWithAddress(address)
        self.updateContinueButtonState(true)
    }
    
    func showHybrisErrors(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }

    //Mark: UIDCheckbox delegates
    @IBAction func checkBoxValueChanged(_ sender: UIDCheckBox) {
        guard isBillingAddressModeOnly else {
            guard sender.isChecked else {
                billingAddressView.isHidden = false
                updateContinueButtonState(false)
                return
            }
            billingAddressView.isHidden = true
            updateContinueButtonState(false)
            return
        }
        guard sender.isChecked else {
            resetBillingAddressTextFields()
            disableOrEnableFieldEntries(true)
            return
        }
        updateUIWithAddress(savedAddress!)
        disableOrEnableFieldEntries(false)
        updateContinueButtonState(true)
    }
    
    @IBAction func saveNewAddress(_ sender: UIDButton) {
        self.view.endEditing(true)
        guard isBillingAddressModeOnly else {
            guard isEditMode else {
                let newShippingAdd = getShippingAddressForSaving()
                if checkBoxView.isChecked {
                    newBillingAddress = newShippingAdd
                } else {
                    newBillingAddress = getBillingAddressForSaving()
                }
                addNewShippingAddress(newShippingAdd)
                return
            }
            let shippingAddressToBeUpdated = getShippingAddressForSaving()
            updateShippingAddress(shippingAddressToBeUpdated)
            return
        }
        newBillingAddress = getBillingAddressForSaving()
        navigateToOrderSummaryScreenFromBilling(newBillingAddress!, inShippingAddress: self.savedAddress!)
    }
    
    private func addNewShippingAddress(_ newAddress: IAPUserAddress) {
        self.startActivityProgressIndicator()
        addressSyncHelper.addDeliveryAddress(newAddress, success: {(address:IAPUserAddress) -> () in
            self.stopActivityProgressIndicator()
            self.setDefaultAddress(address)
            self.trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "newShippingAddressAdded"], action: IAPAnalyticsConstants.sendData)
        }, failure:{ (error: NSError) -> () in
            self.stopActivityProgressIndicator()
            self.handleFieldValidationErrors(error)
            self.displayErrorMessage(error)
        })
    }
    
    private func updateShippingAddress(_ updatedAddress:IAPUserAddress) {
        if let address = savedAddress {
            updatedAddress.addressId = address.addressId
            self.startActivityProgressIndicator()
            addressSyncHelper.updateDeliveryAddress(updatedAddress, isDefaultAddress: address.defaultAddress,
                                                    success: { (success:Bool) -> () in
                                                        self.showAddressSelectScreen(updatedAddress)
                                                        self.stopActivityProgressIndicator()
            }, failure: { (error: NSError) -> () in
                self.stopActivityProgressIndicator()
                self.handleFieldValidationErrors(error)
                self.displayErrorMessage(error)
            })
        }
    }
    
    private func setDefaultAddress(_ inAddress:IAPUserAddress) {
        self.startActivityProgressIndicator();
        addressSyncHelper.updateDeliveryAddress(inAddress, isDefaultAddress: true, success: { (inSuccess:Bool) -> () in
            self.stopActivityProgressIndicator()
            self.setNewAddressToDeliveryAddress(inAddress)
        }) { (error:NSError) -> () in
            self.stopActivityProgressIndicator()
            self.handleFieldValidationErrors(error)
        }
    }
    
    private func setNewAddressToDeliveryAddress(_ newAddress:IAPUserAddress) {
        self.startActivityProgressIndicator()
        addressSyncHelper.setDeliveryAddressID(newAddress.addressId, success: { (inSuccess:Bool) -> () in
            self.stopActivityProgressIndicator()
            self.showAddressSelectScreen(newAddress)
        }) { (inError:NSError) -> () in
            self.stopActivityProgressIndicator()
            self.displayErrorMessage(inError)
        }
    }
    
    @IBAction func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func handleFieldValidationErrors(_ error: NSError) {
        let errorDict: NSDictionary = error.userInfo as NSDictionary
        if errorDict["Error_Info_Dict"] != nil {
            if let errorInfoDict = errorDict["Error_Info_Dict"] as? NSDictionary,
                let errorsArray = errorInfoDict["errors"] as? NSArray {
                errorsArray.enumerateObjects({ object, index, stop in
                    if let objectDict = object as? NSDictionary,
                        let string = objectDict["subject"],
                        let _ = string as? String {
                        //                        if let number = self.textFieldLookup.value(forKey: textFieldName) as? NSInteger {
                        //                            let textFieldIndex: NSInteger = number
                        //                            let invalidField: UITextField = self.collectionOfTextFields![textFieldIndex]
                        //                            self.showHybrisErrors(invalidField)
                        //                        }
                    }
                })
            }
        }
    }
    
    private func showAddressSelectScreen(_ inAddress:IAPUserAddress) {
        guard self.isFromBuyDirect() == false else {
            guard self.cartInfo.deliveryModeName == nil else {
                self.navigateToOrderSummaryScreenFromBilling(self.newBillingAddress!, inShippingAddress: inAddress)
                return
            }
            self.sendRequestToSetDeliveryMode(inAddress)
            return
        }
        guard self.isEditMode == true else {
            guard self.cartInfo?.deliveryModeName == nil else {
                self.navigateToOrderSummaryScreenFromBilling(self.newBillingAddress!, inShippingAddress: inAddress)
                return
            }
            self.sendRequestToSetDeliveryMode(inAddress)
            return
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func sendRequestToSetDeliveryMode(_ inAddress:IAPUserAddress) {
        self.startActivityProgressIndicator()
        
        IAPDeliveryModeSyncHelper().deliveryMode({(withDeliveryModeDetails: IAPDeliveryModeDetails) in
            super.stopActivityProgressIndicator()

            guard withDeliveryModeDetails.deliveryModeDetails.count > 0 else {
                let uidOkAction: UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"),
                                                       style: .primary,
                                                       handler: { (uidAction) in
                                                        self.uidAlertController?.dismiss(animated: true,
                                                                                         completion: nil)
                })
                super.displayDLSAlert(IAPLocalizedString("iap_server_error"),
                                      withMessage: IAPLocalizedString("iap_something_went_wrong"),
                                      firstButton: uidOkAction,
                                      secondButton: nil,
                                      usingController: self,
                                      viewTag: IAPConstants.IAPAlertViewTags.kApologyAlertViewTag)
                
                return
            }
            guard let defaultDeliveryMode = withDeliveryModeDetails.deliveryModeDetails.first else {return}
            self.updateDeliveryMode(defaultDeliveryMode.getdeliveryCodeType(), inAddress: inAddress)
            
        }) { (inError:NSError) in
            self.stopActivityProgressIndicator()
            self.displayErrorMessage(inError)
        }
    }
    
    private func updateDeliveryMode(_ deliveryModeValue: String, inAddress: IAPUserAddress) {
        super.startActivityProgressIndicator()
        IAPDeliveryModeSyncHelper().updateDeliveryMode(deliveryModeValue, success: { (success: Bool) in
            super.stopActivityProgressIndicator()
            self.navigateToOrderSummaryScreenFromBilling(self.newBillingAddress!, inShippingAddress: inAddress)
        }) { (inError: NSError) in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
    }
    
    func resetBillingAddressTextFields() {
        self.continueButton.isEnabled = false
        self.billingAddressListView.clearAddressFields()
    }
    
    func disableOrEnableFieldEntries(_ isEnabled: Bool) {
        billingAddressListView.disableOrEnableFieldEntries(isEnabled)
    }

    func getShippingAddressForSaving() -> IAPUserAddress {
        return shippingAddressListView.addressForSaving(with: self.savedAddress)!
    }

    func getBillingAddressForSaving() -> IAPUserAddress {
        guard !checkBoxView.isChecked else {
            return savedAddress!
        }
        return billingAddressListView.addressForSaving(with: savedAddress)!
    }

    func navigateToOrderSummaryScreenFromBilling(_ inBillingAddress: IAPUserAddress, inShippingAddress: IAPUserAddress) {
        let orderViewController = IAPOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        orderViewController.shippingAddress = IAPUserAddress(address: inShippingAddress)
        if checkBoxView.isChecked {
            orderViewController.billingAddress = orderViewController.shippingAddress
        } else {
            orderViewController.billingAddress = inBillingAddress
        }
        orderViewController.isFirstTimeUser = true
        orderViewController.cartIconDelegate = self.cartIconDelegate
        self.navigationController?.pushViewController(orderViewController, animated: true)
    }
}
