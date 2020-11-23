/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import AppAuth
import PhilipsUIKitDLS
import PlatformInterfaces
import SafariServices

class PIMViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var progressIndicator: UIDProgressIndicator!
    
    private var oidcConfig:PIMOIDCConfiguration?
    private var loginManager:PIMLoginManager?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var configDownloadStatus: OIDCConfigDownload = .notDownloaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PIM_Login_TitleTxt".localiseString(args: [])
        initializePIMFlow()
    }
    
    func initializePIMFlow() {
        progressIndicator.startAnimating()
        let userManager = PIMSettingsManager.sharedInstance.pimUserManagerInstance()
        guard userManager.getUserLoggedInState() == UserLoggedInState.userNotLoggedIn else {
            return
        }
        guard getConfigDownloadStatus() == .downloaded else {
            _ = PIMConfigManager(PIMSettingsManager.sharedInstance.appInfraInstance()!.serviceDiscovery, userManager)
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(configDownloadCompleted), name: .configDownloadCompleted, object: nil)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startAuthentication(oidcConfig: PIMSettingsManager.sharedInstance.pimOIDCConfig()!)
        }
    }
    
    func startAuthentication(oidcConfig: PIMOIDCConfiguration) {
        loginManager = PIMLoginManager(oidcConfig)
        loginManager?.oidcLogin(self, completion: { (error)  in
            self.progressIndicator.stopAnimating()
            self.exitOutOfPIM(with: error)
        })
    }
    
    @objc func configDownloadCompleted() {
        if let oidcConfiguration = PIMSettingsManager.sharedInstance.pimOIDCConfig() {
            startAuthentication(oidcConfig: oidcConfiguration)
        }
    }
    
    func getConfigDownloadStatus() -> OIDCConfigDownload {
        if PIMSettingsManager.sharedInstance.pimOIDCConfig() != nil {
            return .downloaded
        }
        return .inProgress
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// TODO: currently showing profile page if user is logged in. Need to take decission about this feature
extension PIMViewController {
    
    func handleURLRedirection(_ url: URL) {
        currentAuthorizationFlow?.resumeExternalUserAgentFlow(with: url)
    }
    
    func exitOutOfPIM(with error: Error?) {
        PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: error)
        self.navigationController?.popViewController(animated: true)
    }
}
