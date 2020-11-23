/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK
import PhilipsRegistration
import AppInfra

class ECSTestMicroservicesGroupViewController: UIViewController {
    
    @IBOutlet weak var groupMicroserviceTableView: UITableView!
    @IBOutlet weak var propositionIDTextField: UIDTextField!
    @IBOutlet weak var loginButton: UIDButton!
    var urLaunchInput: URLaunchInput?
    var urInterface: URInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appInfra = ECSTestDemoConfiguration.sharedInstance.sharedAppInfra {
            let propositionID = try? (appInfra.appConfig.getPropertyForKey("propositionId", group: "MEC") as? String) ?? ""
            propositionIDTextField.text = propositionID
            setupAPIKeyForPIL()
            initialiseECommerceSDK()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLoginButton()
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.addUserDataInterfaceListener(self)
        let janrainAccessToken = try? ECSTestDemoConfiguration.sharedInstance.userDataInterface?.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN] as? String
        ECSTestMasterData.sharedInstance.janrainAccessToken = janrainAccessToken ?? ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.removeUserDataInterfaceListener(self)
    }
    
    @IBAction func setPropositionID(_ sender: Any) {
        let trimmedVal = propositionIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        try? ECSTestDemoConfiguration.sharedInstance.sharedAppInfra?.appConfig.setPropertyForKey("propositionId",
                                                                                                 group: "MEC",
                                                                                                 value: trimmedVal)
        initialiseECommerceSDK()
        ECSTestMasterData.sharedInstance.clearAllData()
        propositionIDTextField.resignFirstResponder()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIDButton) {
        if let userDataInterface = ECSTestDemoConfiguration.sharedInstance.userDataInterface {
            if userDataInterface.loggedInState() == .userLoggedIn {
                logOutAction()
            } else {
                setupURHandler()
                setupURLaunchInput()
                ECSTestDemoConfiguration.sharedInstance.userDataInterface?.addUserDataInterfaceListener(self)
                let urViewController = urInterface?.instantiateViewController(urLaunchInput!, withErrorHandler: { (_) in })
                if let urVC = urViewController {
                    navigationController?.pushViewController(urVC, animated: true)
                }
            }
        }
    }
    
    deinit {
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.removeUserDataInterfaceListener(self)
    }
}

extension ECSTestMicroservicesGroupViewController {
    
    func setupAPIKeyForPIL() {
        let apiKey = ECSTestDemoConfiguration.sharedInstance.sharedAppInfra?.appIdentity.getAppState() == AIAIAppState.PRODUCTION ? "yaTmSAVqDR4GNwijaJie3aEa3ivy7Czu22BxZwKP" : "yaTmSAVqDR4GNwijaJie3aEa3ivy7Czu22BxZwKP"
        try? ECSTestDemoConfiguration.sharedInstance.sharedAppInfra?.appConfig.setPropertyForKey("PIL_ECommerce_API_KEY",
                                                                                                 group: "MEC",
                                                                                                 value: apiKey)
    }
    
    func logOutAction() {
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.logoutSession()
    }
    
    func configureLoginButton() {
        if let userDataInterface = ECSTestDemoConfiguration.sharedInstance.userDataInterface {
            userDataInterface.loggedInState() == .userLoggedIn ?
                loginButton.setTitle("Log out", for: .normal) :
                loginButton.setTitle("Login", for: .normal)
        }
    }
    
    func setupURHandler() {
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = ECSTestDemoConfiguration.sharedInstance.sharedAppInfra
        urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
    }
    
    func setupURLaunchInput() {
        urLaunchInput = URLaunchInput()
    }
    
    func initialiseECommerceSDK() {
        if let appInfra = ECSTestDemoConfiguration.sharedInstance.sharedAppInfra {
            ECSTestDemoConfiguration.sharedInstance.ecsServices = ECSServices(appInfra: appInfra)
        }
    }
}

extension ECSTestMicroservicesGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "ECSTestMicroservices", bundle: Bundle(for: type(of: self)))
        let selectedMicroServiceGroup = ECSTestDemoConfiguration.sharedInstance.displayData?.microservices?[indexPath.section].microServiceGroups?[indexPath.row]
        if let viewController = storyBoard.instantiateViewController(withIdentifier: "ECSTestMicroservicesViewController") as? ECSTestMicroservicesViewController {
            viewController.microServiceEmbedded = selectedMicroServiceGroup
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        headerView.headerLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        headerView.title = "\(ECSTestDemoConfiguration.sharedInstance.displayData?.microservices?[section].microserviceGroupDisplayName ?? "")"
        return headerView
    }
}

extension ECSTestMicroservicesGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ECSTestDemoConfiguration.sharedInstance.displayData?.microservices?[section].microServiceGroups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ECSTestDemoConfiguration.sharedInstance.displayData?.microservices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let microserviceGroupCell = tableView.dequeueReusableCell(withIdentifier: "ECSTestGroupCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ECSTestGroupCell")
        let microServiceGroupName = ECSTestDemoConfiguration.sharedInstance.displayData?.microservices?[indexPath.section].microServiceGroups?[indexPath.row].microServiceGroupName ?? ""
        microserviceGroupCell.textLabel?.text = microServiceGroupName
        return microserviceGroupCell
    }
}

extension ECSTestMicroservicesGroupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension ECSTestMicroservicesGroupViewController: UserDataDelegate {
    
    func logoutSessionSuccess() {
        configureLoginButton()
        ECSTestMasterData.sharedInstance.janrainAccessToken = nil
        ECSTestMasterData.sharedInstance.refreshToken = nil
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.removeUserDataInterfaceListener(self)
    }
}
