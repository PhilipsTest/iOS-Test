//
//  CoppaDemoViewController.swift
//  RegistrationiOS
//
//  Created by Adarsh Kumar Rai on 02/04/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import PhilipsUIKitDLS
import PhilipsRegistration

class CoppaDemoViewController: UIViewController {
    
    private var coppaExtension = DICOPPAExtension()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Coppa Demo"
        
        if ((DIUser.getInstance().userLoggedInState.rawValue <= UserLoggedInState.pendingTnC.rawValue)) {
            presentAlert(title: "User not logged in", message: "User is not logged in. Coppa status will not behave properly.", actionTitle: "Ok")
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func message(for consentStatus: DICOPPASTATUS) -> String {
        var consentStatusMessage = "No idea what you are talking about"
        switch consentStatus {
        case .dicoppaConsentPending:
            consentStatusMessage = "First consent pending"
        case .dicoppaConsentNotGiven:
            consentStatusMessage = "First consent declined"
        case .dicoppaConsentGiven:
            consentStatusMessage = "First consent accepted"
        case .dicoppaConfirmationPending:
            consentStatusMessage = "Second consent pending"
        case .dicoppaConfirmationNotGiven:
            consentStatusMessage = "Second consent declined"
        case .dicoppaConfirmationGiven:
            consentStatusMessage = "Second consent accepted"
        }
        return consentStatusMessage
    }
    
    
    func presentAlert(title: String, message: String, actionTitle: String) {
        let alert = UIDAlertController(title: title, icon: nil, message: message)
        alert.addAction(UIDAction(title: actionTitle, style: .primary))
        present(alert, animated: true);
    }
    
    
    func update(title: inout String, message: inout String, for error: Error?)  {
        if let error = error {
            title = "Error"
            message = (error as NSError).localizedDescription
        }
    }
    

    @IBAction func showCoppaConsentStatus(_ sender: UIDButton) {
        let consentStatusMessage = message(for: coppaExtension.getCoppaEmailConsentStatus())
        presentAlert(title:"Coppa consent status", message: consentStatusMessage, actionTitle: "Ok")
    }
    
    
    @IBAction func showConsentStatusFromServer(_ sender: UIDButton) {
        coppaExtension.fetchCoppaEmailConsentStatus { [weak self] (status, error) in
            var title = "Coppa consent status"
            var message = ""
            if let error = error {
                title = "Error"
                message = (error as NSError).localizedDescription
            } else {
                message = self?.message(for: status) ?? ""
            }
            self?.presentAlert(title: title, message: message, actionTitle: "Ok")
        }
    }
    
    
    @IBAction func acceptFirstConsent(_ sender: UIDButton) {
        DIUser.getInstance().updateConsent(true) { [weak self] (error) in
            var title = "Success"
            var message = "First consent has been accepted. You can check the status."
            self?.update(title: &title, message: &message, for: error)
            self?.presentAlert(title: title, message: message, actionTitle: "Ok")
        }
    }
    
    
    @IBAction func denyFirstConsent(_ sender: UIDButton) {
        DIUser.getInstance().updateConsent(false) { [weak self] (error) in
            var title = "Success"
            var message = "First consent has been declined. You can check the status."
            self?.update(title: &title, message: &message, for: error)
            self?.presentAlert(title: title, message: message, actionTitle: "Ok")
        }
    }
    
    
    @IBAction func acceptSecondConsent(_ sender: UIDButton) {
        DIUser.getInstance().updateConsentApproval(true) { [weak self] (error) in
            var title = "Success"
            var message = "Second consent has been accepted. You can check the status."
            self?.update(title: &title, message: &message, for: error)
            self?.presentAlert(title: title, message: message, actionTitle: "Ok")
        }
    }
    
    
    @IBAction func denySecondConsent(_ sender: UIDButton) {
        DIUser.getInstance().updateConsentApproval(false) { [weak self] (error) in
            var title = "Success"
            var message = "Second consent has been declined. You can check the status."
            self?.update(title: &title, message: &message, for: error)
            self?.presentAlert(title: title, message: message, actionTitle: "Ok")
        }
    }
}
