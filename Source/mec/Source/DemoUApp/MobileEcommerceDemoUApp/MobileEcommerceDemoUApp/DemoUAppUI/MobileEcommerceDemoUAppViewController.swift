/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsRegistration
import UAPPFramework
import PhilipsUIKitDLS
import MobileEcommerce

let MEC_BAZAARVOICE_ENVIRONMENT_KEY = "MEC_BazaarVoice_Environment_Key"

class MobileEcommerceDemoUAppViewController: UIViewController {

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
    @IBOutlet weak var bazaarVoiceEnvrionmentSwitch: UISwitch!
    @IBOutlet weak var blockRetailerSwitch: UISwitch!
    @IBOutlet weak var productCategoryTextField: UIDTextField!
    private var cartButton: UIBarButtonItem?
    
    var bannerView: UIDView?
    var userDataInterface: UserDataInterface?
    var mecAppInfraHandler: AIAppInfra?
    
    private var mecHandler: MECInterface!
    
    var mecLaunchInput: MECLaunchInput?
    var mecSettings: MECSettings?
    var mecAppDependencies: MECDependencies?
    var urLaunchInput: URLaunchInput?
    var urInterface: URInterface?

    var ctnArray: [String] = []
    var productCategory: String? {
        didSet {
            productCategoryTextField.text = productCategory
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try prepositionIDTextField.text = (mecAppInfraHandler?.appConfig.getPropertyForKey("propositionId", group: "MEC") as? String) ?? ""
        } catch let error {
            mecAppInfraHandler?.logging?.log(.error, eventId: "ErrorWhileSettingProperty", message: "\(error)")
        }
        
        title = mecAppInfraHandler?.appIdentity.getAppVersion()
        self.mecHandler = MECInterface(dependencies: self.mecAppDependencies!, andSettings: self.mecSettings)
        setupURHandler()
        if let bazaarVoiceEnvironment = UserDefaults.standard.value(forKey: MEC_BAZAARVOICE_ENVIRONMENT_KEY) as? String {
            bazaarVoiceEnvrionmentSwitch.isOn = bazaarVoiceEnvironment == MECBazaarVoiceEnvironment.production.rawValue
        } else {
            UserDefaults.standard.set(MECBazaarVoiceEnvironment.production.rawValue, forKey: MEC_BAZAARVOICE_ENVIRONMENT_KEY)
            UserDefaults.standard.synchronize()
            bazaarVoiceEnvrionmentSwitch.isOn = true
        }
        configureSupportSwitches()
        setUpVoucherControl()
        setUpSupportDependency()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        self.userDataInterface?.removeUserDataInterfaceListener(self)
    }
    
    deinit {
        mecLaunchInput?.orderFlowCompletionDelegate = nil
        mecLaunchInput?.bannerConfigDelegate = nil
        mecHandler.dataInterface().removeCartUpdateDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ctnArray.removeAll()
        productCategory = nil
        self.userDataInterface?.addUserDataInterfaceListener(self)
        
        if userDataInterface!.loggedInState() == .userLoggedIn {
            self.registerButton.setTitle("Log out", for: .normal)
            updateUIControl(enabled: true)
        } else {
            self.registerButton.setTitle("Register", for: .normal)
            updateUIControl(enabled: false)
        }
        startActivityProgressIndicator()
        mecHandler.dataInterface().isHybrisAvailable { [weak self](isHyrisAvailable, error) in
            self?.stopActivityProgressIndicator()
            guard error == nil else {
                let alert = UIDAlertController(title: "Mobile Ecommerce", message: error?.localizedDescription)
                let continueAction = UIDAction(title: "Ok", style: .primary)
                alert.addAction(continueAction)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            guard self?.userDataInterface?.loggedInState() == .userLoggedIn else {
                self?.navigationItem.rightBarButtonItem = nil
                return
            }
            if isHyrisAvailable {
                self?.startActivityProgressIndicator()
                self?.mecHandler.dataInterface().fetchCartCount(completionHandler: { (count, error) in
                    self?.stopActivityProgressIndicator()
                    if error != nil {
                        let alert = UIDAlertController(title: "Mobile Ecommerce", message: error?.localizedDescription)
                        let continueAction = UIDAction(title: "Ok", style: .primary)
                        alert.addAction(continueAction)
                        self?.present(alert, animated: true, completion: nil)
                    } else {
                        
                        if self?.cartButton == nil {
                            self?.cartButton = UIBarButtonItem(badge: "\(count)", title: "", target: self,
                                                               action: #selector(MobileEcommerceDemoUAppViewController.cartButtonAction))
                        }
                        self?.cartButton?.badgeLabel?.text = "\(count)"
                        self?.navigationItem.rightBarButtonItem = self?.cartButton
                    }
                })
            } else {
                self?.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @IBAction func setProductCategoryClicked(_ sender: UIDButton) {
        productCategoryTextField.resignFirstResponder()
        guard productCategoryTextField.text == "" else {
            let trimmedCategory = productCategoryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            productCategory = trimmedCategory
            return
        }
        productCategory = nil
    }
    
    @objc func cartButtonAction() {
        let mecFlowConfiguration = MECFlowConfiguration(landingView: .mecShoppingCartView)
        mecFlowConfiguration.productCategory = productCategory
        mecLaunchInput?.flowConfiguration = mecFlowConfiguration
        mecLaunchInput?.voucherCode = autoApplyVoucherTextField.text
        if let maxCount = productCountTextField.text, maxCount.count > 0 {
            mecLaunchInput?.maxCartCount = Int(maxCount) ?? 0
        } else {
            mecLaunchInput?.maxCartCount = 0
        }
        mecHandler.dataInterface().addCartUpdateDelegate(self)
        self.mecLaunchInput?.bazaarVoiceEnvironment = bazaarVoiceEnvrionmentSwitch.isOn ? .production : .staging
        setUpSupportDependency()
        addBannerDelegate()
        addOrderFlowCompletionDelegate()
        
        let shoppingCartVC = self.mecHandler.instantiateViewController(self.mecLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            if inError != nil {
                let alert = UIDAlertController(title: "Mobile Ecommerce", message: inError?.localizedDescription)
                let continueAction = UIDAction(title: "Ok", style: .primary)
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        if let shoppingCartVC = shoppingCartVC {
            self.navigationController?.pushViewController(shoppingCartVC, animated: true)
        }
    }
    
    @IBAction func mockingSwitchValueChanged(_ sender: UISwitch) {
        
    }
    
    @IBAction func hybrisSwitchClicked(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "mec_BlockHybris")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func blockRetailersValueChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "mec_BlockRetailers")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func voucherStatusChanged(_ sender: UISwitch) {
        try? mecAppInfraHandler?.appConfig.setPropertyForKey("voucherCode.enable", group: "MEC", value: sender.isOn)
    }
    
    func setUpVoucherControl() {
        do {
            if let voucherStatus = try mecAppInfraHandler?.appConfig.getPropertyForKey("voucherCode.enable", group: "MEC") as? Int {
                voucherStatusControl.isOn = voucherStatus == 1
            }
        } catch {
            voucherStatusControl.isOn = false
        }
    }
    
    @IBAction func addCTN(_ sender: AnyObject) {
        self.ctnTextField.resignFirstResponder()
        guard self.ctnTextField.text == "" else {
            let trimmedString = self.ctnTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            
            guard let ctnList = trimmedString?.components(separatedBy: ",") else { return }
            self.ctnArray.append(contentsOf: ctnList)
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
                try self.mecAppInfraHandler?.appConfig.setPropertyForKey("propositionId",
                                                                         group: "MEC",
                                                                         value: trimmedVal)
            } catch _ {
                
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
    
    @IBAction func shopNowCategorized(_ sender: AnyObject) {
        guard self.ctnArray.count != 0 else { return }
        
        let mecFlowConfiguration = MECFlowConfiguration(landingView: .mecCategorizedProductListView)
        mecFlowConfiguration.productCTNs = ctnArray
        mecFlowConfiguration.productCategory = productCategory
        mecLaunchInput?.flowConfiguration = mecFlowConfiguration
        mecLaunchInput?.voucherCode = autoApplyVoucherTextField.text
        if let maxCount = productCountTextField.text, maxCount.count > 0 {
            mecLaunchInput?.maxCartCount = Int(maxCount) ?? 0
        } else {
            mecLaunchInput?.maxCartCount = 0
        }
        mecHandler.dataInterface().addCartUpdateDelegate(self)
        self.mecLaunchInput?.bazaarVoiceEnvironment = bazaarVoiceEnvrionmentSwitch.isOn ? .production : .staging
        setUpSupportDependency()
        addBannerDelegate()
        addOrderFlowCompletionDelegate()
        let shopCategorizedVC = self.mecHandler.instantiateViewController(self.mecLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            if inError != nil {
                let alert = UIDAlertController(title: "Mobile Ecommerce", message: inError?.localizedDescription)
                let continueAction = UIDAction(title: "Ok", style: .primary)
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        guard let shoppingCategorizedVC = shopCategorizedVC else {
            self.stopActivityProgressIndicator();
            return
        }
        self.navigationController?.pushViewController(shoppingCategorizedVC, animated: true)
    }
       
    @IBAction func productDetailClicked(_ sender: AnyObject) {
        guard ctnArray.count > 0 else { return }
        
        let mecFlowConfiguration = MECFlowConfiguration(landingView: .mecProductDetailsView)
        mecFlowConfiguration.productCTNs = [ctnArray[0]]
        mecFlowConfiguration.productCategory = productCategory
        mecLaunchInput?.flowConfiguration = mecFlowConfiguration
        mecLaunchInput?.voucherCode = autoApplyVoucherTextField.text
        if let maxCount = productCountTextField.text, maxCount.count > 0 {
            mecLaunchInput?.maxCartCount = Int(maxCount) ?? 0
        } else {
            mecLaunchInput?.maxCartCount = 0
        }
        mecHandler.dataInterface().addCartUpdateDelegate(self)
        self.mecLaunchInput?.bazaarVoiceEnvironment = bazaarVoiceEnvrionmentSwitch.isOn ? .production : .staging
        addBannerDelegate()
        addOrderFlowCompletionDelegate()
        setUpSupportDependency()
        let productDetailVC = self.mecHandler.instantiateViewController(self.mecLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            if inError != nil {
                let alert = UIDAlertController(title: "Mobile ecommerce", message: inError?.localizedDescription)
                let continueAction = UIDAction(title: "Ok", style: .primary)
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        if let productDetailVC = productDetailVC {
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    
    @IBAction func orderHistoryButtonClicked(_ sender: Any) {
        let mecFlowConfiguration = MECFlowConfiguration(landingView: .mecOrderHistoryView)
        mecLaunchInput?.flowConfiguration = mecFlowConfiguration
        mecLaunchInput?.voucherCode = autoApplyVoucherTextField.text
        if let maxCount = productCountTextField.text, maxCount.count > 0 {
            mecLaunchInput?.maxCartCount = Int(maxCount) ?? 0
        } else {
            mecLaunchInput?.maxCartCount = 0
        }
        mecHandler.dataInterface().addCartUpdateDelegate(self)
        self.mecLaunchInput?.bazaarVoiceEnvironment = bazaarVoiceEnvrionmentSwitch.isOn ? .production : .staging
        addBannerDelegate()
        addOrderFlowCompletionDelegate()
        setUpSupportDependency()
        
        let orderHistoryVC = self.mecHandler.instantiateViewController(self.mecLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            if inError != nil {
                let alert = UIDAlertController(title: "Mobile Ecommerce", message: inError?.localizedDescription)
                let continueAction = UIDAction(title: "Ok", style: .primary)
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        if let orderHistoryVC = orderHistoryVC {
            self.navigationController?.pushViewController(orderHistoryVC, animated: true)
        }
    }
       
    @IBAction func shopNowAction(_ sender: UIButton!) {
        let mecFlowConfiguration = MECFlowConfiguration(landingView: .mecProductListView)
        mecFlowConfiguration.productCategory = productCategory
        mecLaunchInput?.flowConfiguration = mecFlowConfiguration
        mecLaunchInput?.voucherCode = autoApplyVoucherTextField.text
        if let maxCount = productCountTextField.text, maxCount.count > 0 {
            mecLaunchInput?.maxCartCount = Int(maxCount) ?? 0
        } else {
            mecLaunchInput?.maxCartCount = 0
        }
        mecHandler.dataInterface().addCartUpdateDelegate(self)
        self.mecLaunchInput?.bazaarVoiceEnvironment = bazaarVoiceEnvrionmentSwitch.isOn ? .production : .staging
        addBannerDelegate()
        addOrderFlowCompletionDelegate()
        setUpSupportDependency()
        let productCatalogueVC = self.mecHandler.instantiateViewController(self.mecLaunchInput!) { (inError) in
            self.stopActivityProgressIndicator()
            if inError != nil {
                let alert = UIDAlertController(title: "Mobile ecommerce", message: inError?.localizedDescription)
                let continueAction = UIDAction(title: "Ok", style: .primary)
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        if let productCatalogueVC = productCatalogueVC {
            self.navigationController?.pushViewController(productCatalogueVC, animated: true)
        }
    }
       
    @objc func addTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton!) {
        if self.userDataInterface?.loggedInState() == .userLoggedIn {
            self.logOutAction()
            self.registerButton.setTitle("Register", for: .normal)
        } else {
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
    
    @IBAction func bazaarVoiceEnvironmentChanged(_ sender: UISwitch) {
        let alert = UIDAlertController(title: "To reflect the changes the app needs to restart",
                                       message: "To change the Bazaar Voice Environment, the app needs to restart. Do you want to continue?")
        let continueAction = UIDAction(title: "Continue", style: .primary) { (action) in
            let bazaarVoiceEnvironment = sender.isOn ? MECBazaarVoiceEnvironment.production.rawValue : MECBazaarVoiceEnvironment.staging.rawValue
            UserDefaults.standard.set(bazaarVoiceEnvironment, forKey: MEC_BAZAARVOICE_ENVIRONMENT_KEY)
            UserDefaults.standard.synchronize()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                exit(0)
            })
        }
        let cancelAction = UIDAction(title: "Cancel", style: .secondary) { (action) in
            if let bazaarVoiceEnvironment = UserDefaults.standard.value(forKey: MEC_BAZAARVOICE_ENVIRONMENT_KEY) as? String {
                self.bazaarVoiceEnvrionmentSwitch.isOn = bazaarVoiceEnvironment == MECBazaarVoiceEnvironment.production.rawValue
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(continueAction)
        present(alert, animated: true, completion: nil)
    }
    
    func createBannerView() {
        bannerView = UIDView.makePreparedForAutoLayout()
        bannerView?.backgroundColor = .groupTableViewBackground
        let imageView = UIImageView.makePreparedForAutoLayout()
        let bundle = Bundle(for: MobileEcommerceDemoUAppViewController.self)
        if let imagePath = bundle.path(forResource: "ka", ofType: "png") {
            imageView.image = UIImage(contentsOfFile: imagePath)
        }
        imageView.contentMode = .scaleAspectFill
        bannerView?.addSubview(imageView)
        imageView.constrainCenterToParent()
        imageView.constrainToSuperviewAccordingToLanguage()
    }
    
    func addBannerDelegate() {
        mecLaunchInput?.bannerConfigDelegate = bannerSwitch.isOn ? self : nil
    }
    
    func addOrderFlowCompletionDelegate() {
        mecLaunchInput?.orderFlowCompletionDelegate = flowCompletionSwitch.isOn ? self : nil
    }
    
    func setUpSupportDependency() {
        mecLaunchInput?.supportsHybris = !hybrisSupportSwitch.isOn
        mecLaunchInput?.supportsRetailers = !blockRetailerSwitch.isOn
    }
}

extension MobileEcommerceDemoUAppViewController: MECCartUpdateProtocol {
    func didUpdateCartCount(cartCount: Int) {
        cartButton?.badgeLabel?.text = "\(cartCount)"
    }
    
    func shouldShowCart(_ shouldShow: Bool) {
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

extension MobileEcommerceDemoUAppViewController {
    
    func setupURHandler() {
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = mecAppInfraHandler
        urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
    }
    
    func setupURLaunchInput() {
        urLaunchInput = URLaunchInput()
    }
    
    func logOutAction() {
        self.startActivityProgressIndicator()
        self.userDataInterface?.logoutSession()
        updateUIControl(enabled: false)
    }
    
    func configureSupportSwitches() {
        if let blockHybris = UserDefaults.standard.value(forKey: "mec_BlockHybris") as? Bool {
            hybrisSupportSwitch.isOn = blockHybris
        } else {
            UserDefaults.standard.set(false, forKey: "mec_BlockHybris")
            UserDefaults.standard.synchronize()
            hybrisSupportSwitch.isOn = false
        }
        
        if let blockRetailers = UserDefaults.standard.value(forKey: "mec_BlockRetailers") as? Bool {
            blockRetailerSwitch.isOn = blockRetailers
        } else {
            UserDefaults.standard.set(false, forKey: "mec_BlockRetailers")
            UserDefaults.standard.synchronize()
            blockRetailerSwitch.isOn = false
        }
    }
    
    private func updateUIControl(enabled: Bool) {
        autoApplyVoucherTextField.isEnabled = enabled
    }
    
    // MARK: Show/Hide Progress Indicator
    func startActivityProgressIndicator () {
        if self.progressView == nil {
            let bundle:Bundle = Bundle(for:type(of: self))    //Bundle(identifier: "org.cocoapods.InAppPurchaseDemoUApp")!
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
}

// MARK: MECBannerConfigurationProtocol methods
extension MobileEcommerceDemoUAppViewController: MECBannerConfigurationProtocol {
    
    func viewForBannerInProductListScreen() -> UIView? {
        if bannerView == nil {
            createBannerView()
        }
        return bannerView
    }
}

// MARK: JanrainFlowDownloadDelegate methods
extension MobileEcommerceDemoUAppViewController: UserDataDelegate {
    func logoutSessionSuccess() {
        self.stopActivityProgressIndicator()
        _ = self.navigationController?.popViewController(animated: true)
    }

    func logoutSessionFailed(_ error: Error) {
        self.stopActivityProgressIndicator()
    }
}

// MARK: MECOrderFlowCompletionProtocol methods
extension MobileEcommerceDemoUAppViewController: MECOrderFlowCompletionProtocol {
    
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

// MARK: UITextFieldDelegate methods
extension MobileEcommerceDemoUAppViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
