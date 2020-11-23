//
//  LocalizationExt.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit

@objc protocol Localization {
    var productRegistrationLocalizedText: String {get set}
    @objc optional
    var productRegistrationPlaceholderLocalizedText: String {get set}
}

extension UILabel: Localization {
    @IBInspectable
    var productRegistrationLocalizedText: String {
        set {
            self.text = LocalizableString(key: newValue)
        }
        get {
            return self.text!
        }
    }
}

extension UIControl: Localization {
    @IBInspectable
    var productRegistrationLocalizedText: String {
            set {
                if self.isKind(of: UIButton.self) {
                    let buttonObj = self as? UIButton
                    buttonObj!.setTitle(LocalizableString(key: newValue), for: .normal)
                }else if(self.isKind(of: UITextField.self)){
                    let textFieldObj = self as? UITextField
                    textFieldObj!.text = LocalizableString(key: newValue)
                }
            }
            get {
                if self.isKind(of: UIButton.self) {
                    let buttonObj = self as? UIButton
                    return buttonObj!.title(for: .normal)!
                }else if(self.isKind(of: UITextField.self)){
                    let textFieldObj = self as? UITextField
                    return textFieldObj!.text!
                }
                return ""
            }
    }
}

extension UITextField {
    @IBInspectable
    var productRegistrationPlaceholderLocalizedText: String {
        set {
            self.placeholder = LocalizableString(key: newValue)
        }
        get {
            return self.placeholder!
        }
    }
}

extension UIViewController: Localization {
    @IBInspectable
    var productRegistrationLocalizedText: String {
        set {
            self.title = LocalizableString(key: newValue)
        }
        get {
            return self.title!
        }
    }
}
