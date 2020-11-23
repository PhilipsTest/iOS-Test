//
//  UIViewController.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit
import PhilipsUIKitDLS

enum MODEL_ALERT_TYPE: Int {
    case PRODUCT_DETAIL_VIEW = 560
    case PRODUCT_REGISTRATION_VIEW
    case WEB_VIEW
}

extension UIViewController {
    func decideToPopOrDismiss(launchOption:PPRUILaunchOption, animate: Bool, completion: (() -> Void)?) {
        let _ = self.navigationController?.skipViewControllerWhenBackPressed(viewController: (launchOption == .WelcomeScreen) ? PPRWelcomeViewController() : PPRRegisterProductsViewController())
        if let completion = completion {
            completion()
            return
        }
        return
    }
}

// MARK: PUIModalAlert methods
extension PPRBaseViewController {
    func showAlert(With error:NSError?, tag: MODEL_ALERT_TYPE) {
        //Note: added a delay of 0.5 secs for displaying alert as hiding activity indicator and showing alert was conflicting each other. So OS was not able to display the alert.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let uidAlert = UIDAlertController.init(title: error?.domain, icon: nil, message: error?.localizedDescription)
            let okAction = UIDAction.init(title: LocalizableString(key: "PRG_OK"), style:.secondary, handler: { [weak self] (action) in
                if(tag.rawValue == MODEL_ALERT_TYPE.PRODUCT_DETAIL_VIEW.rawValue) {
                    if case .WelcomeScreen = (self?.configuration?.launchOption ?? PPRUILaunchOption.WelcomeScreen) {
//                        shouldAnimate = true
                    }
                    self?.popOutOfProductRegistrationViewControllers()
                    self?.executeCompletionHandlerWithError(error: error)
                }
            })
            uidAlert.addAction(okAction)
            self.present(uidAlert, animated: true, completion: nil)
        }
    }
}
