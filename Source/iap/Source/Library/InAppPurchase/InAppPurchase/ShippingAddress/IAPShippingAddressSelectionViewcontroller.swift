/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS
import AppInfra

class IAPShippingAddressSelectionViewcontroller: IAPBaseViewController, IAPAddressDecoratorProtocol {

    var cartInfo: IAPCartInfo!
    var productList = [IAPProductModel]()
    fileprivate var iapCartHelper: IAPCartSyncHelper!
    var addressDecorator: IAPAddressDecorator!
    
    @IBOutlet weak var addressSelectionTableView: UITableView!
    @IBOutlet weak var stepLabel: UIDLabel!
    @IBOutlet weak var headerLabel: UIDLabel!
    @IBOutlet weak var stepView: UIDView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kShippingAddressSelectionPageName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = IAPLocalizedString("iap_checkout")
        self.stepLabel.text = IAPLocalizedString("iap_checkout_steps","1")
        self.headerLabel.text = IAPLocalizedString("iap_selection_select_address")
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.updateCartIconVisibility(false)
        if IAPConfiguration.sharedInstance.isInternetReachable() {
            self.getAddresses()
        }
    }
    
    func getAddresses() {
        super.startActivityProgressIndicator()
        IAPAddressSyncHelper().getDeliveryAddressesForUser({[weak self] (addressInfo:IAPUserAddressInfo) -> () in
            self?.stopActivityProgressIndicator()
            self?.getDefaultAddress(addressInfo)
            }) { (inError:NSError) -> () in
                super.stopActivityProgressIndicator()
                super.displayErrorMessage(inError, shouldDisplayNoInternetView: (0 == self.addressDecorator.address.count))
        }
    }
    
    // MARK:
    // MARK: No internet related methods
    // MARK:
    override func didTapTryAgain() {
        super.didTapTryAgain()
        self.getAddresses()
    }
    
    func getDefaultAddress(_ addressInfo: IAPUserAddressInfo) {
        super.startActivityProgressIndicator()
        IAPAddressSyncHelper().getDefaultAddress({[weak self] (defaultAddress:IAPUserAddress?) -> () in
            self?.stopActivityProgressIndicator()
            self?.removeNoInternetView()
            addressInfo.mergeDefaultAddress(defaultAddress)
            self?.loadDecoratorWithAddress(addressInfo)
            }) { (inError: NSError) -> () in
                super.stopActivityProgressIndicator()
                super.displayErrorMessage(inError, shouldDisplayNoInternetView: (0 == self.addressDecorator.address.count))
        }
    }
    
    func loadDecoratorWithAddress(_ inAddressInfo: IAPUserAddressInfo) {
        self.addressDecorator.address = inAddressInfo.address
        self.addressDecorator.delegate = self
        self.addressDecorator.reloadDataForAddresses()
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: IAPAddressDecoratorProtocol methods
    func didSelectAddAddress(_ inAddress: IAPUserAddress?) {
        let shippingAddressEditViewController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        shippingAddressEditViewController.cartInfo = self.cartInfo
        shippingAddressEditViewController.productList = self.productList
        shippingAddressEditViewController.isEditMode = false
        shippingAddressEditViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(shippingAddressEditViewController, animated: true)
    }
    
    func didSelectDeliverToAddress(_ inAddress:IAPUserAddress) {
        super.startActivityProgressIndicator()
        IAPAddressSyncHelper().setDeliveryAddressID(inAddress.addressId, success: {[weak self] (inSuccess:Bool) -> () in
            self?.stopActivityProgressIndicator()
            guard self?.cartInfo.deliveryModeName == nil else {
                self?.fetchPaymentDetails(inAddress)
                return
            }
            self?.sendRequestToSetDeliveryMode(inAddress)
            }) { (inError:NSError) -> () in
                super.stopActivityProgressIndicator()
                super.displayErrorMessage(inError)
        }
    }
    
    func updateUI() {
        stepView.backgroundColor? = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryBackground)!
        stepLabel.textColor = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryText)!
        self.iapCartHelper = IAPCartSyncHelper()
        self.addressDecorator = IAPAddressDecorator(withTableView: self.addressSelectionTableView)
    }
    
    func sendRequestToSetDeliveryMode(_ inAddress:IAPUserAddress) {
        super.startActivityProgressIndicator()
        
        IAPDeliveryModeSyncHelper().deliveryMode({ (withDeliveryModeDetails:IAPDeliveryModeDetails) in
            
            guard withDeliveryModeDetails.deliveryModeDetails.count == 0 else {
                guard let defaultDeliveryMode  = withDeliveryModeDetails.deliveryModeDetails.first else {return}
                self.updateDeliveryMode(defaultDeliveryMode.getdeliveryCodeType(), inAddress: inAddress)
                return
            }
            super.stopActivityProgressIndicator()
            
            let uidOkAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary, handler: { (uidAction) in
                self.uidAlertController?.dismiss(animated: true, completion: nil)
            })
            
            super.displayDLSAlert(IAPLocalizedString("iap_server_error"),
                                  withMessage: IAPLocalizedString("iap_something_went_wrong"),
                                  firstButton: uidOkAction,
                                  secondButton: nil,
                                  usingController: self,
                                  viewTag: IAPConstants.IAPAlertViewTags.kApologyAlertViewTag)
            
        }) { (inError:NSError) in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
    }
    
    func updateDeliveryMode(_ deliveryModeValue:String, inAddress:IAPUserAddress) {
        IAPDeliveryModeSyncHelper().updateDeliveryMode(deliveryModeValue, success: { (success:Bool) in
            super.stopActivityProgressIndicator()
            self.fetchPaymentDetails(inAddress)
        }) { (inError:NSError) in
            super.stopActivityProgressIndicator()
            let uidOkAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary, handler: { (uidAction) in
                self.uidAlertController?.dismiss(animated: true, completion: nil)
            })
            
            super.displayDLSAlert(IAPLocalizedString("iap_server_error"),
                                  withMessage: IAPLocalizedString("iap_server_error"),
                                  firstButton: uidOkAction,
                                  secondButton: nil,
                                  usingController: self,
                                  viewTag: IAPConstants.IAPAlertViewTags.kErrorAlertViewTag)
        }
    }
    
    func fetchPaymentDetails(_ inAddress:IAPUserAddress) {
        super.startActivityProgressIndicator()
        self.iapCartHelper.getPaymentDetails({[weak self] (paymentInfoArray:IAPPaymentDetailsInfo) -> () in
            self?.stopActivityProgressIndicator()
            let paymentDetails = paymentInfoArray.arrayOfPaymentDetails
            self?.navigateToBillingDetailsScreen(paymentDetails,address: inAddress)
            }) { (inError:NSError) -> () in
                super.stopActivityProgressIndicator()
                super.displayErrorMessage(inError)
        }
    }

    func navigateToBillingDetailsScreen(_ arrayOfPaymentDetails: [IAPPaymentInfo], address: IAPUserAddress) {
        guard arrayOfPaymentDetails.count == 0 else {
            let paymentSelectionVC = IAPPaymentSelectionViewController.instantiateFromAppStoryboard(appStoryboard: .worldPay)
            paymentSelectionVC.paymentDetailsInfo = arrayOfPaymentDetails
            paymentSelectionVC.cartInfo        = self.cartInfo
            paymentSelectionVC.productList     = self.productList
            paymentSelectionVC.shippingAddress = address
            paymentSelectionVC.cartIconDelegate = self.cartIconDelegate
            navigationController?.pushViewController(paymentSelectionVC, animated: true)
            return
        }

        let shippingAddressEditViewController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        shippingAddressEditViewController.isEditMode = false
        shippingAddressEditViewController.isBillingAddressModeOnly = true
        shippingAddressEditViewController.savedAddress = address
        shippingAddressEditViewController.productList = self.productList
        shippingAddressEditViewController.cartInfo = self.cartInfo
        shippingAddressEditViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(shippingAddressEditViewController, animated: true)
    }

    func didSelectEditAddress(_ inAddress: IAPUserAddress) {
        let shippingAddressEditViewController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        shippingAddressEditViewController.isEditMode = true
        shippingAddressEditViewController.savedAddress = inAddress
        shippingAddressEditViewController.productList = self.productList
        shippingAddressEditViewController.cartInfo = self.cartInfo
        shippingAddressEditViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(shippingAddressEditViewController, animated: true)
    }
    
    func didSelectDeleteAddress(_ inAddress:IAPUserAddress) {
            //For delete option first show an alert for confirmation
        let uidCancelAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_cancel"), style: .secondary, handler: { (uidAction) in
            self.uidAlertController?.dismiss(animated: true, completion: nil)
        })
        
        let uidDeleteAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_remove"), style: .primary, handler: { (uidAction) in
            self.uidAlertController?.dismiss(animated: true, completion: nil)
            super.startActivityProgressIndicator()
            IAPAddressSyncHelper().deleteAddress(inAddress.addressId, success: {[weak self] (inSuccess) -> () in
                self?.getAddresses()
            }) { (inError:NSError) -> () in
                super.stopActivityProgressIndicator()
                super.displayErrorMessage(inError)
            }
        })
        
        displayDLSAlert(IAPLocalizedString("iap_confirm"),
                        withMessage: IAPLocalizedString("iap_removed_address")!,
                        firstButton: uidCancelAction,
                        secondButton: uidDeleteAction,
                        usingController: self, viewTag: IAPConstants.IAPAlertViewTags.kDeleteAlertViewTag)
    } 
}
