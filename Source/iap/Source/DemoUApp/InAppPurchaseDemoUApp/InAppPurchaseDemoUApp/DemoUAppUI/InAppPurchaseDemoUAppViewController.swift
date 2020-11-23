/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import InAppPurchase
import PhilipsRegistration
import UAPPFramework
import PhilipsUIKitDLS

class InAppPurchaseDemoUAppViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIDButton!
    @IBOutlet weak var ctnTextField: UIDTextField!
    @IBOutlet weak var autoApplyVoucherTextField: UIDTextField!
    @IBOutlet weak var prepositionIDTextField: UIDTextField!

    @IBOutlet weak var productCountTextField: UIDTextField!
    @IBOutlet weak var mockingSwitch: UISwitch!
    @IBOutlet weak var progressView: UIView?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet weak var flowCompletionSwitch: UISwitch!
    @IBOutlet weak var hybrisSupportSwitch: UISwitch!
    @IBOutlet weak var voucherStatusControl: UISwitch!
    @IBOutlet weak var bannerSwitch: UISwitch!
    var bannerView: UIDView?
    
    private var iapHandler: IAPInterface!
    private var cartButton: UIBarButtonItem?
    private var logOutButton: UIBarButtonItem?
    var ctnArray: [String] = []
    private var isHybrisEnabled: Bool = false {
        didSet {
            updateUIControl(enabled: userDataInterface!.loggedInState().rawValue == UserLoggedInState.userLoggedIn.rawValue)
        }
    }
    
    /*IAP dependencies*/
    var iapAppInfraHandler: AIAppInfra?
    var iapLaunchInput: IAPLaunchInput?
    var iapSettings: IAPSettings?
    var iapAppDependencies: IAPDependencies?
    var urLaunchInput: URLaunchInput?
    var urInterface: URInterface?
    var userDataInterface: UserDataInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupURHandler()
        title = iapAppInfraHandler?.appIdentity.getAppVersion()
        setUpVoucherControl()
        do {
            try prepositionIDTextField.text = (iapAppInfraHandler?.appConfig.getPropertyForKey("propositionId", group: "IAP") as? String) ?? ""
        } catch let error {
            iapAppInfraHandler?.logging?.log(.error, eventId: "ErrorWhileSettingProperty", message: "\(error)")
        }
        let dic = ProcessInfo.processInfo.environment
        mockingSwitch.isOn = (dic["APIMock"] == "1") ? true : false
        configureHybrisSupportSwitch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ctnArray.removeAll()
        self.ctnTextField.text = ""
        self.autoApplyVoucherTextField.text = ""
        initializeIAPConfiguration()
        self.userDataInterface?.addUserDataInterfaceListener(self)
        if userDataInterface!.loggedInState() == .userLoggedIn {
            self.registerButton.setTitle("Log out", for: .normal)
            updateUIControl(enabled: true)
        } else {
            self.registerButton.setTitle("Register", for: .normal)
            updateUIControl(enabled: false)
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func mockingSwitchValueChanged(_ sender: UISwitch) {
        let value = sender.isOn ? "1" : "0"
        setenv("APIMock",value, 1)          // 1 - value will overrite
    }
    
    
    @IBAction func hybrisSwitchClicked(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "mecBlockHybris")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func voucherStatusChanged(_ sender: UISwitch) {
        try? iapAppInfraHandler?.appConfig.setPropertyForKey("voucherCode.enable", group: "IAP", value: sender.isOn)
    }
    
    func configureHybrisSupportSwitch() {
        if let blockHybris = UserDefaults.standard.value(forKey: "mecBlockHybris") as? Bool {
            hybrisSupportSwitch.isOn = blockHybris
        } else {
            UserDefaults.standard.set(false, forKey: "mecBlockHybris")
            UserDefaults.standard.synchronize()
            hybrisSupportSwitch.isOn = false
        }
    }
    
    func createBannerView() {
        bannerView = UIDView.makePreparedForAutoLayout()
        bannerView?.backgroundColor = .groupTableViewBackground
        let textLabel  = UIDLabel.makePreparedForAutoLayout()
        textLabel.text = "Promotional Banner View"
        bannerView?.addSubview(textLabel)
        textLabel.constrainCenterToParent()
    }
    
    func setUpVoucherControl() {
        do {
            if let voucherStatus = try iapAppInfraHandler?.appConfig.getPropertyForKey("voucherCode.enable", group: "IAP") as? Int {
                voucherStatusControl.isOn = voucherStatus == 1
            }
        } catch {
            voucherStatusControl.isOn = false
        }
    }
    
    private func updateUIControl(enabled: Bool) {
        autoApplyVoucherTextField.isEnabled = enabled
    }
    
    func initializeIAPConfiguration() {
        self.startActivityProgressIndicator()
        self.iapLaunchInput?.cartIconDelegate = self
        setUpHybrisDependency()
        self.iapHandler = IAPInterface(dependencies: self.iapAppDependencies!, andSettings: self.iapSettings)
        self.iapHandler.isCartVisible({ (isEnabled) in
            self.isHybrisEnabled = isEnabled
            if isEnabled {
                self.cartButton = UIBarButtonItem(badge: "0", title: "",
                                                  target: self,
                                                  action: #selector(InAppPurchaseDemoUAppViewController.cartButtonAction))
                self.navigationItem.rightBarButtonItem = self.cartButton
                self.autoApplyVoucherTextField.isHidden = false
                self.refetchCart()
            } else {
                self.navigationItem.rightBarButtonItem = nil
                self.autoApplyVoucherTextField.isHidden = true
            }
            
        }) { (inError) in
            print("****Error in isCartVisible")
        }
        self.stopActivityProgressIndicator()
    }
    
    func logOutAction() {
        self.startActivityProgressIndicator()
        self.userDataInterface?.logoutSession()
        updateUIControl(enabled: false)
    }
    
    @IBAction func addCTN(_ sender: AnyObject) {
        self.ctnTextField.resignFirstResponder()
        guard self.ctnTextField.text == "" else {
            let trimmedString = self.ctnTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            self.ctnArray.append(trimmedString!)
            self.ctnTextField.text = ""
            return
        }
        self.ctnTextField.text = ""
    }
    
    @IBAction func setPrepositionIdButtonTapped(_ sender: Any) {

        let alert = UIDAlertController(title: "To reflect the changes the app needs to restart", message: "Do you want to continue?")
        let continueAction = UIDAction(title: "Continue", style: .primary) { (action) in
            do {
                let trimmedVal = self.prepositionIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                try self.iapAppInfraHandler?.appConfig.setPropertyForKey("propositionId",
                                                                         group: "IAP",
                                                                         value: trimmedVal)
            } catch let error {
                self.iapAppInfraHandler?.logging?.log(.error, eventId: "ErrorWhileSettingProperty", message: "\(error)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                exit(0)
            })
        }
        let cancelAction = UIDAction(title: "Cancel", style: .secondary)
        alert.addAction(cancelAction)
        alert.addAction(continueAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: Show/Hide Progress Indicator
    func startActivityProgressIndicator () {
        
        if self.progressView == nil {
            let bundle:Bundle = Bundle(identifier: "org.cocoapods.InAppPurchaseDemoUApp")!
            let activityView :UIView? = bundle.loadNibNamed("CustomActivityView", owner: self, options: nil)![0] as? UIView
            
            self.progressView = activityView
            self.view.addSubview(self.progressView!)
        }
        
        self.progressView!.frame = self.view.bounds
        self.progressView?.isHidden = false
        self.activityIndicatorView?.startAnimating()
        self.navigationController?.view.isUserInteractionEnabled = false
    }
    
    func stopActivityProgressIndicator () {
        
        self.progressView?.isHidden = true
        self.progressView?.removeFromSuperview()
        
        if self.progressView != nil {
            self.progressView = nil
        }
        self.activityIndicatorView?.stopAnimating()
        self.navigationController?.view.isUserInteractionEnabled = true
    }
    
    @objc func cartButtonAction() {
        guard let isInternetReachable = iapAppInfraHandler?.restClient.isInternetReachable(), isInternetReachable else {
            displayNetworkError()
            return
        }
        
        if let voucherText = autoApplyVoucherTextField.text,
            voucherText.count > 0 {
            self.iapLaunchInput?.voucherId = voucherText
        }
        
        self.startActivityProgressIndicator()
        
        let iapSeetingsInputHelper = IAPFlowInput()
        
        self.iapLaunchInput?.setIAPFlow(.iapShoppingCartView, withSettings: iapSeetingsInputHelper)
        addOrderFlowCompletionDelegate()
        addBannerDelegate()
        setMaximumCartCount()
        
        let shoppingCartVC = self.iapHandler.instantiateViewController(self.iapLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            inError!.displayMessage(self)
        }
        if let shoppingVC = shoppingCartVC {
            self.navigationController?.pushViewController(shoppingVC, animated: true)
        }
    }
    
    @IBAction func shopNowCategorized(_ sender: AnyObject) {
        guard let isInternetReachable = iapAppInfraHandler?.restClient.isInternetReachable(), isInternetReachable else {
            displayNetworkError()
            return
        }
        guard self.ctnArray.count != 0 else { return }
        self.startActivityProgressIndicator()
        
        let iapSeetingsInputHelper = IAPFlowInput(inCTNList: self.ctnArray)
        self.iapLaunchInput?.setIAPFlow(.iapProductCatalogueView, withSettings: iapSeetingsInputHelper)
        addOrderFlowCompletionDelegate()
        addBannerDelegate()
        setMaximumCartCount()
        let shopCategorizedVC = self.iapHandler.instantiateViewController(self.iapLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            inError!.displayMessage(self)
        }
        guard let shoppingCategorizedVC = shopCategorizedVC else {
            self.stopActivityProgressIndicator();
            return
        }
        self.navigationController?.pushViewController(shoppingCategorizedVC, animated: true)
    }
    
    @IBAction func productDetailClicked(_ sender: AnyObject) {
        
        guard let isInternetReachable = iapAppInfraHandler?.restClient.isInternetReachable(), isInternetReachable else {
            displayNetworkError()
            return
        }
        guard self.ctnArray.count != 0 else { return }
        self.startActivityProgressIndicator()
        
        guard self.ctnArray.count > 0 else { return }
        let iapSeetingsInputHelper = IAPFlowInput(inCTN: self.ctnArray[0])
        
        self.iapLaunchInput?.setIAPFlow(.iapProductDetailView, withSettings: iapSeetingsInputHelper)
        addOrderFlowCompletionDelegate()
        addBannerDelegate()
        setMaximumCartCount()
        let productDetailVC = self.iapHandler.instantiateViewController(self.iapLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            inError!.displayMessage(self)
        }
        if let productVC = productDetailVC {
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
    
    @IBAction func shopNowAction(_ sender: UIButton!) {
        guard let isInternetReachable = iapAppInfraHandler?.restClient.isInternetReachable(), isInternetReachable else {
            displayNetworkError()
            return
        }
        self.startActivityProgressIndicator()
        let iapSeetingsInputHelper = IAPFlowInput(inCTNList: [])
        self.iapLaunchInput?.setIAPFlow(.iapCategorizedCatalogueView, withSettings: iapSeetingsInputHelper)
        addOrderFlowCompletionDelegate()
        addBannerDelegate()
        setMaximumCartCount()
        let productCatalogueVC = self.iapHandler.instantiateViewController(self.iapLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            inError?.displayMessage(self)
        }
        if let productCatalogueViewCntrlr = productCatalogueVC {
            self.navigationController?.pushViewController(productCatalogueViewCntrlr, animated: true)
        }
    }

    @IBAction func purchaseHistoryClicked(_ sender: AnyObject) {
        guard let isInternetReachable = iapAppInfraHandler?.restClient.isInternetReachable(), isInternetReachable else {
            displayNetworkError()
            return
        }
        self.startActivityProgressIndicator()
        let iapSeetingsInputHelper = IAPFlowInput()
        self.iapLaunchInput?.setIAPFlow(.iapPurchaseHistoryView, withSettings: iapSeetingsInputHelper)
        addOrderFlowCompletionDelegate()
        addBannerDelegate()
        setMaximumCartCount()
        let purchaseHistoryVC = self.iapHandler.instantiateViewController(self.iapLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            inError!.displayMessage(self)
        }
        if let purchaseVC = purchaseHistoryVC {
            self.navigationController?.pushViewController(purchaseVC, animated: true)
        }
    }
    
    fileprivate func displayNetworkError() {
        let error = NSError(domain: NSURLErrorDomain, code: -1009, userInfo:[NSLocalizedDescriptionKey:"The Internet connection appears to be offline."])
        error.displayMessage(self)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton!) {
        if self.userDataInterface!.loggedInState() == .userLoggedIn {
            self.logOutAction()
            self.registerButton.setTitle("Register", for: .normal)
        }else{
            self.setupURHandler()
            self.setupURLaunchInput()
            let urViewController = urInterface?.instantiateViewController(urLaunchInput!, withErrorHandler: { (error) in
                print("not able to launch uesr registration")
            })
            if let urVC = urViewController {
                self.navigationController?.pushViewController(urVC, animated: true)
            }
        }
    }
    
    func addOrderFlowCompletionDelegate() {
        iapLaunchInput?.orderFlowCompletionDelegate = flowCompletionSwitch.isOn ? self : nil
    }
    
    func setUpHybrisDependency() {
        iapLaunchInput?.supportsHybris = !hybrisSupportSwitch.isOn
    }
    
    func setMaximumCartCount() {
        if let productCountText = productCountTextField.text, let maximumCount = Int(productCountText) {
            self.iapLaunchInput?.maximumCartCount = maximumCount
        } else {
            self.iapLaunchInput?.maximumCartCount = 0
        }
    }
    
    func addBannerDelegate() {
        iapLaunchInput?.bannerConfigDelegate = bannerSwitch.isOn ? self : nil
    }
    
    func setupURHandler() {
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = iapAppInfraHandler
        urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
    }
    
    func setupURLaunchInput() {
        urLaunchInput = URLaunchInput()
    }
    
    fileprivate func refetchCart() {
        self.startActivityProgressIndicator()
        self.iapHandler.getProductCartCount({ (inCount:Int) -> () in
            DispatchQueue.main.async(execute: {
                
                self.stopActivityProgressIndicator()
                
                let barButton = self.navigationItem.rightBarButtonItem
                barButton?.badgeString = "\(inCount)"
            })
        }) { (inError:NSError) -> () in
            
            self.stopActivityProgressIndicator()
            
            let barButton = self.navigationItem.rightBarButtonItem
            barButton?.badgeString = "0"
            
            inError.displayMessage(self)
        }
    }
    
    func showAlert(_ withMessage:String?, firstButtonTitle: String?, moreButtonTitle: String?) {
        let alert = UIAlertController(title: "Alert", message: withMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: firstButtonTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        iapLaunchInput?.orderFlowCompletionDelegate = nil
        iapLaunchInput?.bannerConfigDelegate = nil
    }
}

// MARK: IAPCartIconProtocol methods
extension InAppPurchaseDemoUAppViewController: IAPCartIconProtocol {

    func didUpdateCartCount() {
        self.refetchCart()
    }

    func updateCartIconVisibility(_ shouldShow: Bool) {
        guard userDataInterface?.loggedInState() == .userLoggedIn else {
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
            return
        }
        guard shouldShow == true else {
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
            return
        }
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = self.cartButton
    }
}

// MARK: IAPOrderFlowCompletionProtocol methods
extension InAppPurchaseDemoUAppViewController: IAPOrderFlowCompletionProtocol {
    
    func shouldPopToProductList() -> Bool {
        return true
    }
    
    func didPlaceOrder() {
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    func didCancelOrder() {
        self.navigationController?.popToViewController(self, animated: true)
    }
}

// MARK: IAPBannerConfigurationProtocol methods
extension InAppPurchaseDemoUAppViewController: IAPBannerConfigurationProtocol {
    
    func viewForBannerInCatalogueScreen() -> UIView? {
        if bannerView == nil {
            createBannerView()
        }
        return bannerView
    }
}

// MARK: JanrainFlowDownloadDelegate methods
extension InAppPurchaseDemoUAppViewController:UserDataDelegate {
    func logoutSessionSuccess() {
        self.stopActivityProgressIndicator()
        _ = self.navigationController?.popViewController(animated: true)
    }

    func logoutSessionFailed(_ error: Error) {
        self.stopActivityProgressIndicator()
    }
}

// MARK: UITextFieldDelegate methods
extension InAppPurchaseDemoUAppViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
