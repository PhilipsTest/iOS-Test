//
//  PPRBaseViewController.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsUIKitDLS

class PPRBaseViewController: UIViewController {
    weak var delegate: PPRUserInterfaceDelegate?
    var products: [PPRProduct]?
    var configuration: PPRConfiguration?
    fileprivate var progressIndicator:  ProgressIndicatorController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizableString(key: "PRG_NavBar_Title")
    }
}

// MARK: UITextFieldDelegate methods
extension PPRBaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: CustomActivityIndicatorView methods
extension PPRBaseViewController {
    func showActivityIndicator(message: String) {
        DispatchQueue.main.async {
            [weak self] in
            if self?.progressIndicator == nil {
                self?.progressIndicator = ProgressIndicatorController(message: message)
            } else {
                self?.progressIndicator?.changeMessage(message)
            }
            if self?.presentedViewController == nil {
                self?.present((self?.progressIndicator!)!, animated: false, completion: nil)
            }
        }
    }
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            [weak self] in
            self?.progressIndicator?.dismiss(animated: false, completion: nil)
        }
    }
    
    //This method POPs out of PR only if there are controllers other than PRs on current navigation stack.
    //If there are no controllers other than PRs, it is assumed that PR is added to a fresh navigation controller
    //and that navigation controller is presented. In such case, no controller will be removed. Only completion block will be called
    //to allow applications gracefully dismiss the navigation controller.
    func popOutOfProductRegistrationViewControllers() {
        let filteredViewControllers = self.navigationController!.viewControllers.filter { !($0 is PPRBaseViewController) }
        if filteredViewControllers.count > 0 {
            self.navigationController!.setViewControllers(filteredViewControllers, animated:(configuration?.animateExit ?? true))
        }
    }

    func executeCompletionHandlerWithError(error: Error?) {
        if let completionHandler =  PPRInterfaceInput.sharedInstance.pprCompletionHandler {
            completionHandler(error)
        }
    }

}


class ProgressIndicatorController: UIDDialogController {
    var messageLabel = UIDLabel()
    
    public init(message: String) {
        super.init(nibName: nil, bundle: nil)
        instanceInitView(message: message)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInitView(message: nil)
    }
    
    
    private func instanceInitView(message: String?) {
        messageLabel.numberOfLines = 0
        messageLabel.theme = UIDThemeManager.sharedInstance.whiteTheme
        messageLabel.text = message
        
        let progressIndicator = UIDProgressIndicator()
        progressIndicator.circularProgressIndicatorSize = .large
        progressIndicator.progressIndicatorType = .circular
        progressIndicator.progressIndicatorStyle = .indeterminate
        progressIndicator.theme = UIDThemeManager.sharedInstance.whiteTheme
        progressIndicator.startAnimating()
        
        let verticalStackView = UIStackView(arrangedSubviews: [progressIndicator, messageLabel])
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 10
        verticalStackView.axis = .vertical
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        verticalStackView.layoutMargins = edgeInsets
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView = verticalStackView
        backgroundStyle = .subtle
    }
    
    
    fileprivate func changeMessage(_ message: String) {
        messageLabel.text = message
        self.view.layoutIfNeeded()
    }
}
