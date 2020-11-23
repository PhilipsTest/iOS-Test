//
//  AboutViewController.swift
//  DemoUApp
//
//  Created by leslie on 24/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import PhilipsIconFontDLS

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutView: UIDAboutView!
    let alertMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit," +
    "sed do eiusmod tempor incididunt ut labore et dolore."
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadCrossButton()
        aboutView.delegate = self
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            aboutView.version = "Version \(version)"
        }
    }
}

extension AboutViewController {
    
    func loadCrossButton() {
        let dismissButton = UIButton()
        dismissButton.addTarget(self, action: #selector(crossButtonClicked), for: .touchUpInside)
        
        let titleLabel = UILabel()
        dismissButton.addSubview(titleLabel)
        titleLabel.font = UIFont.iconFont(size: UIDBarButtonSize)
        titleLabel.text = PhilipsDLSIcon.unicode(iconType: .cross24)
        
        dismissButton.frame = CGRect(x: 0, y: 0, width: UIDSize24, height: UIDSize24)
        titleLabel.frame = dismissButton.frame
        titleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.navigationPrimaryText
        titleLabel.center = dismissButton.center
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }
    
   @objc func crossButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlertWith(title: String, message: String) {
        let aboutAlert = UIDAlertController(title: title, message: message)
        let aboutActionButton = UIDAction(title: "Got it", style: .primary)
        aboutAlert.addAction(aboutActionButton)
        present(aboutAlert, animated: true, completion: nil)
    }
}

extension AboutViewController: UIDAboutViewDelegate {
    
    func termsAndConditionsLinkClicked() {
        showAlertWith(title: aboutView.termsAndConditionsLinkText, message: alertMessage)
    }
    
    func privacyPolicyLinkClicked() {
        showAlertWith(title: aboutView.privacyPolicyLinkText, message: alertMessage)
    }
}
