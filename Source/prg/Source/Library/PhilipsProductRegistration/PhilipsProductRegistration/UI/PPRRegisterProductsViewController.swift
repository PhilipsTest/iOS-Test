//
//  PPRegisterProductsViewController.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//


import Foundation
import PhilipsUIKitDLS
import PhilipsPRXClient
import PlatformInterfaces

class PPRRegisterProductsViewController: PPRBaseViewController {
    
    @IBOutlet weak var registerButton: UIDProgressButton!
    @IBOutlet var dateNoContainerView: UIStackView!
    @IBOutlet var serialNoContainerView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameLabel: UIDLabel!
    @IBOutlet var modelLabel: UIDLabel!
    @IBOutlet var ctnLabel: UIDLabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var datetextFeild: UIDTextField!
    @IBOutlet var datePicker: UIDDatePicker!
    @IBOutlet var serailNumberField: UIDTextField!
    @IBOutlet var serailNumberLink: UIDHyperLinkLabel!    
    
    fileprivate var selectedProduct: PPRRegisteredProduct?
    internal var metadataInfo: PRXProductMetaDataInfoData?
    private var productSummaryResponse: PRXResponseData?
    private var productListResponse: PPRProductListResponse?
    
    lazy var dipatch_group = {
        return DispatchGroup()
    }()
    
    private var isValidDate: Bool = true
    private var isValidSerialNumber: Bool = true
    private var isErrorAlertShown: Bool = false
    fileprivate var isViewDisAppeared: Bool = false
    
    lazy var registrtaionHelper: PPRProductRegistrationHelper = {
        return PPRProductRegistrationHelper()
    }()
    
    var userWithProduct: PPRUserWithProducts = {
        return PPRInterfaceInput.sharedInstance.userWithProduct
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()      
        
        self.registerForUIKeyboardNotification()
        self.datePicker.maximumDate = PPRInterfaceInput.sharedInstance.appDependency.appInfra.time.getUTCTime()
        self.datePicker.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        self.datePicker.locale = PPRInterfaceInput.sharedInstance.appDependency.appInfra.internationalization.getUILocale()
        
        self.serailNumberField.validationMessage = LocalizableString(key: "PRG_Invalid_SerialNum_ErrMsg")
        self.intiateRegistration()
        
        self.setDefaultHeights()
        
        serailNumberLink.text = LocalizableString(key: "PRG_Find_Serial_Number")
        let model = UIDHyperLinkModel()
        model.isUnderlined = false
        serailNumberLink.addLink(model) { (range) in }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isViewDisAppeared = false
        self.trackPageName()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == PPRStoryBoardIDs.successScreen) {
            let detailVC = segue.destination as! PPRSuccessViewController
            if let product = sender {
                detailVC.product  = product as? PPRRegisteredProduct
            }
            detailVC.configuration = self.configuration
            detailVC.userWithProduct = self.userWithProduct
            detailVC.delegate = self.delegate
            detailVC.productSummaryResponse = self.productSummaryResponse
            detailVC.metadataInfo = self.metadataInfo
        }
        else if(segue.identifier == PPRStoryBoardIDs.findSerialNumberScreen) {
            
            let registeredProductViewController = (segue.destination as! PPRFindSerialNumberViewController)
            registeredProductViewController.metadataSerialContentData = self.metadataInfo?.serialNumberData
            registeredProductViewController.selectedProduct = self.selectedProduct
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendarToDateTextField()
        NotificationCenter.default.addObserver(self, selector: #selector(PPRWelcomeViewController.orientationChanged(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isViewDisAppeared = true
        self.serailNumberField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationChanged (_ notification: NSNotification?) {
        if self.scrollView.contentSize.height < self.scrollView.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom - self.scrollView.frame.size.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func addCalendarToDateTextField() {
        let calendarImage = UIImage(named: "calendar", in: Bundle.localBundle(), compatibleWith: nil)
        let calendarImageView = UIImageView(image: calendarImage)
        calendarImageView.frame = CGRect(x: 5, y: 5, width: calendarImageView.image!.size.width + 10.0, height: calendarImageView.image!.size.height)
        calendarImageView.contentMode = UIView.ContentMode.center
        
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: calendarImageView.image!.size.width + 20.0, height: calendarImageView.image!.size.height + 10))
        aView.backgroundColor = UIColor.clear
        aView.addSubview(calendarImageView)
        
        self.datetextFeild.rightViewMode = UITextField.ViewMode.always
        self.datetextFeild.rightView = aView
    }
    
    // MARK: Fetch Product data from PRX
    func intiateRegistration() {
        guard (self.products?.count)! > 0 else {
            // TODO: Need to show error message when list is zero
            self.hideActivityIndicator()
            return
        }
        
        let uuid = try? self.userWithProduct.user.userDetails([UserDetailConstants.UUID])[UserDetailConstants.UUID]
        self.selectedProduct = PPRProduct.registeredProduct(product: self.products![0],
                                                            uuid: uuid as? String)
        self.perform(#selector(PPRRegisterProductsViewController.proceedToRegister), with: nil, afterDelay: 0.0)
    }
    
    @objc private func proceedToRegister()  {
        self.showActivityIndicator(message: LocalizableString(key: "PRG_Looking_For_Products_Lbltxt"))
        self.userWithProduct.getRegisteredProducts({[weak self] (data) in
            self?.productListResponse = data as? PPRProductListResponse
            self?.fetechSummaryAndMetadata((self?.selectedProduct!)!)
            }, failure: { (error) in
                self.hideActivityIndicator()
                self.isErrorAlertShown = true
                self.showAlert(With: error, tag: .PRODUCT_REGISTRATION_VIEW)
        })
    }
    
    private func checkIsProductAlreadyRegistered() {
        if let list = self.productListResponse?.data {
            let productStore = PPRRegisteredProductListStore()
            let result = productStore.isProductAlreadyRegistered(product: self.selectedProduct!, list: list)
            if result.isReigistered && list[result.index].state == State.REGISTERED {
                self.showAlreadyProductRegisteredAlert(product: list[result.index])
            }
        }
    }
    
    private func fetechSummaryAndMetadata(_ product: PPRRegisteredProduct) {
        self.fetechProductSummary(product: product)
        self.fetechProductMetadata(product: product)
        self.dipatch_group.notify(queue: DispatchQueue.global(qos: .default), execute: {
            [weak self] in
            self?.hideActivityIndicator()
            if (self?.isErrorAlertShown)! {
                self?.isErrorAlertShown = false
            } else {
                self?.checkIsProductAlreadyRegistered()
            }
        });
    }
    
    private func fetechProductMetadata(product: PPRRegisteredProduct)
    {
        self.dipatch_group.enter()
        product.getProductMetaData(success: { [weak self] (data) in
            self?.dipatch_group.leave()
            let response: PRXProductMetaDataResponse = data as! PRXProductMetaDataResponse
            if let metadata  = response.data {
                self?.metadataInfo = metadata
                self?.userWithProduct.validateRequiredFieldsWithMetadata(data: (self?.metadataInfo!)!, product: product,
                    valid: { [weak self] in
                        self?.isValidSerialNumber = true
                        self?.isValidDate = true
                    }, error: { [weak self] (error) in
                        self?.updateRequiredFields(product: product, error: error)
                })
            } else {
                self?.isErrorAlertShown = true;
                let userInfo = [NSLocalizedDescriptionKey: PPRError.UNKNOWN.localizedDescription]
                let customError = NSError(domain: PPRError.UNKNOWN.domain, code: PPRError.UNKNOWN.rawValue, userInfo: userInfo)
                self?.showAlert(With: customError, tag: .PRODUCT_DETAIL_VIEW)
            }
        }) { [weak self] (error) in
            self?.dipatch_group.leave()
            self?.isErrorAlertShown = true;
            self?.showAlert(With: error, tag: .PRODUCT_DETAIL_VIEW)
        }
    }
    
    private func fetechProductSummary(product: PPRRegisteredProduct)
    {
        self.dipatch_group.enter()
        product.getProductSummary(success: { [weak self] (response) in
            self?.productSummaryResponse = response
            self?.dipatch_group.leave()
            self?.updateProductDetails(product: product, prxResponse: response as? PRXProductSummaryDataResponse)
            }, failure: {[weak self](error) in
                self?.dipatch_group.leave()
                self?.updateProductDetails(product: product, prxResponse: nil)
        })
    }
    
    private func updateProductDetails(product: PPRProduct, prxResponse : PRXProductSummaryDataResponse?) {
        self.update_userinterface_on_main_queue { [weak self] in
            self?.scrollView.isHidden = false
            //self.nameLabel.text = product.friendlyName
            self?.ctnLabel.text = product.ctn
            let data: PRXSummaryData? = prxResponse?.data
            self?.modelLabel.text = data?.productTitle
            guard let urlStr = data?.imageURL else {
                return
            }
            guard let url = NSURL(string: (urlStr)) else {
                return
            }
            guard let imageData = NSData(contentsOf: url as URL) else {
                return
            }
            self?.imageView.image = UIImage(data: imageData as Data)
            if let sop =  data?.sop{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let date = dateFormatter.date(from: sop){
                    self?.datePicker.minimumDate = date
                }
                
            }
        }
    }
    
    // MARK: Update UI
    func setDefaultHeights() {
        self.serialNoContainerView.isHidden = true
        self.dateNoContainerView.isHidden = true
        self.datePicker.isHidden = true
    }
    
    fileprivate func update_userinterface_on_main_queue(_ block: @escaping ()->()) {
        DispatchQueue.main.async(execute: block)
    }
    
    
    private func updateRequiredFields(product: PPRRegisteredProduct, error: NSError?) {
        self.update_userinterface_on_main_queue { 
            [weak self] in
            switch error!.code {
            case PPRError.REQUIRED_PURCHASE_DATE.rawValue:
                self?.trackRequiredPurchaseDate()
                self?.isValidDate = false
                self?.dateNoContainerView.isHidden = false
            case PPRError.INVALID_SERIAL_NUMBER.rawValue:
                self?.trackRequiredSerialNumber()
                self?.isValidSerialNumber = false
                self?.serailNumberField.text = product.serialNumber
                self?.serialNoContainerView.isHidden = false
                self?.showValidationView()
            case PPRError.PRODUCT_ALREADY_REGISTERD.rawValue:
                self?.trackProductAlreadyRegistered()
            case PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE.rawValue:
                self?.trackRequiredPurchaseDate()
                self?.isValidDate = false
                self?.isValidSerialNumber = false
                self?.serailNumberField.text = product.serialNumber
                self?.dateNoContainerView.isHidden = false
                self?.serialNoContainerView.isHidden = false
                
                self?.hideValidationView()
            default : break
                // DO nothing
            }
        }
    }
    
    fileprivate func updateConstratint(constraint: NSLayoutConstraint, constant: CGFloat) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.50) { 
            constraint.constant = constant
        }
    }
    
    fileprivate func showAlreadyProductRegisteredAlert(product: PPRRegisteredProduct) {
        // let title: String = String(format: "%@ %@ %@", LocalizableString(key: "PRG_registered_serial"), product.serialNumber!, LocalizableString(key: "PRG_before"))
        var title = ""
        var message = ""
        /* if (product.userUuid != nil) && (product.userUuid == DIUser.getInstance().janrainUUID) {
         // Same User
         } else {
         // Different User
         } */
        
        if (product.serialNumber != nil) && (product.serialNumber!.length > 0) {
            title = String(format: "%@ %@ %@", LocalizableString(key: "PRG_This_Serial_No"), product.serialNumber!, LocalizableString(key: "PRG_Already_Registered"))
        } else {
            title = LocalizableString(key: "PRG_Already_Registered_ErrMsg")
        }
        if let pucrchaseDate = product.purchaseDate {
            message = LocalizableString(key: "PRG_registered_on") + " " + pucrchaseDate.localisedStringDate("dd-MM-yyyy")
        }
        
        if product.endWarrantyDate != nil {
            let endWarrantyDate = product.endWarrantyDate?.localisedStringDate("dd-MM-yyyy")
            message = message + "\n" + LocalizableString(key: "PRG_warranty_until") + " " + endWarrantyDate!
        }
        
        self.update_userinterface_on_main_queue {
            let uidAlert = UIDAlertController(title: title, message: message)
            let continueAction = UIDAction.init(title: LocalizableString(key: "PRG_Continue"), style: .primary, handler: { (action) in
                self.popOutOfProductRegistrationViewControllers()
                self.delegate?.productRegistrationContinue(userProduct: nil, products: [product])
                self.executeCompletionHandlerWithError(error: nil)
                self.trackAppNotification(title: PPRTagging.kPPRProductAlreadyRegistered, selected: "continue")
            })
            
            let cancelAction = UIDAction.init(title:LocalizableString(key:"PRG_Close") , style: .secondary, handler: { (action) in
                if let metadata = self.metadataInfo {
                    if (metadata.isRequiresSerialNumber){
                        self.serialNoContainerView.isHidden = false
                        self.trackAppNotification(title: PPRTagging.kPPRProductAlreadyRegistered, selected: "close")
                    }
                }
                
            })
            
            uidAlert.addAction(cancelAction)
            uidAlert.addAction(continueAction)
            self.present(uidAlert, animated: true, completion: nil)
        }
    }
    
    private func updateDateField(date: Date) {
        //TODO : WE NEED TO CHANGE DATE FORMAT
        self.datetextFeild.text = date.stringRepresentation()
        self.selectedProduct?.purchaseDate = Date.registrationShortDateFrom(date.stringDateWith("yyyy-MM-dd")!) as Date?
        self.isValidDate = true
        self.datetextFeild.setValidationView(false)
    }
    
    private func isValid() -> Bool {
        return ((self.isValidSerialNumber == true) && (self.isValidDate == true))
    }
    
    
    @IBAction func registerAction(_ sender: AnyObject) {
        self.serailNumberField.resignFirstResponder()
        self.datePicker.isHidden = true
        guard self.metadataInfo != nil else {
            // TODO: Need to show error message when metadata failed
            return
        }
        if self.isValidDate == false {
            self.datetextFeild.validationMessage =  LocalizableString(key: "PRG_Enter_Purchase_Date_ErrMsg")
            self.datetextFeild.setValidationView(true)
        }
        
        if self.isValidSerialNumber == false {
            self.showValidation(textFileld: self.serailNumberField, show: true)
        }
        
        guard isValid() == true else {
            return
        }
        
        self.registerButton.progressTitle =  LocalizableString(key: "PRG_Registering_Products_Lbltxt")
        self.registerButton.isActivityIndicatorVisible = true
        let product = self.selectedProduct
        self.userWithProduct.delegate = self
        
        //Check if product is already registered
        let listResponse = self.productListResponse
        let regProduct = self.selectedProduct
        if let list = listResponse!.data {
            let productStore = PPRRegisteredProductListStore()
            let result = productStore.isProductAlreadyRegistered(product: regProduct!, list: list)
            if result.isReigistered && list[result.index].state == State.REGISTERED {
                self.registerButton.isActivityIndicatorVisible = false
                self.showAlreadyProductRegisteredAlert(product: list[result.index])
            } else {
                self.userWithProduct.registerProduct(product!)
            }
        }
        else {
            self.registerButton.isActivityIndicatorVisible = false
            let userInfo = [NSLocalizedDescriptionKey: PPRError.UNKNOWN.localizedDescription]
            let customError = NSError(domain: PPRError.UNKNOWN.domain, code: PPRError.UNKNOWN.rawValue, userInfo: userInfo)
            self.showAlert(With: customError, tag: .PRODUCT_DETAIL_VIEW)
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let datePicker = sender
        self.updateDateField(date: datePicker.date)
    }
    
    @IBAction func tapAction(_ textField: UITextField) {
        self.serailNumberField.resignFirstResponder()
        self.updateDateField(date: self.datePicker.date)
    }
    
    @IBAction func dateTapAction(_ sender: UITapGestureRecognizer) {
        self.datePicker.isHidden =   !self.datePicker.isHidden
        self.serailNumberField.resignFirstResponder()
        self.updateDateField(date: self.datePicker.date)
        self.perform(#selector(PPRRegisterProductsViewController.orientationChanged),with:nil, afterDelay: 0.0)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
        }, completion: { finished in
            
        })
    }
    
    @IBAction func textFieldEditing(_ textField: UIDTextField) {
        if textField == self.serailNumberField {
            self.selectedProduct?.serialNumber = textField.text
            
            self.validateSerialNumber()
            self.showValidation(textFileld: self.serailNumberField, show: !self.isValidSerialNumber)
            // WORKAROUND
            // bringing text field up while editing 
            view.layoutIfNeeded()
        }
    }
    
    @IBAction func findSerialNumber(_ sender: AnyObject) {
        self.performSegue(withIdentifier: PPRStoryBoardIDs.findSerialNumberScreen, sender: self.metadataInfo)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.datetextFeild {
            self.datetextFeild.resignFirstResponder()
            self.tapAction(textField)
        }
    }
    
    
    func validateSerialNumber() {
        if let serialNumberFormat = self.metadataInfo?.serialNumberFormat {
            self.isValidSerialNumber = (self.selectedProduct?.serialNumber?.isMatchWith(pattern: serialNumberFormat))!
        } else {
            self.isValidSerialNumber = true
        }
    }
}

// MARK: PPRRegisterProductDelegate methods
extension PPRRegisterProductsViewController: PPRRegisterProductDelegate {
    func productRegistrationDidSucced(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct) {
        self.trackProductRegistrationSuccess()
        self.registerButton.isActivityIndicatorVisible = false
        if product.isSameProduct(product: self.selectedProduct) {
            if !self.isViewDisAppeared {
                self.performSegue(withIdentifier: PPRStoryBoardIDs.successScreen, sender: product)
            }
        }
    }
    
    func productRegistrationDidFail(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct) {
        self.registerButton.isActivityIndicatorVisible = false
        if product.isSameProduct(product: self.selectedProduct) {
            if product.error?.code == PPRError.PRODUCT_ALREADY_REGISTERD.rawValue || product.state == State.REGISTERED
            {
                self.showAlreadyProductRegisteredAlert(product: self.selectedProduct!)
            } else {
                self.showAlert(With: product.error, tag: .PRODUCT_REGISTRATION_VIEW)
            }
        }
    }
}

// MARK: Keyboard Notification methods
extension PPRRegisterProductsViewController {
    
    func registerForUIKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+30, right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}


extension PPRRegisterProductsViewController {
    
    func showValidation(textFileld: UIDTextField, show: Bool) {
        textFileld.setValidationView(show)
        guard show == true else {
            self.hideValidationView()
            return
        }
        self.showValidationView()
    }
    
    func showValidationView() {
        self.serailNumberField.setValidationView(true)
        
    }
    
    func hideValidationView() {
        self.serailNumberField.setValidationView(false)
    }
    
}
