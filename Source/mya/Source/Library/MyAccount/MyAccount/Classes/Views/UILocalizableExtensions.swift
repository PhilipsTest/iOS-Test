//
//  UILocalizableExtensions.swift
//  MyAccount
//
//  Created by Hashim MH on 26/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//
import Foundation
import UIKit

extension UILabel {
    @IBInspectable
    @objc var myaText: String? {
        set {
            if let value = newValue {
                self.text = MYALocalizable(key: value)
            }
        }
        get {
            return self.text
        }
    }
}

extension UIButton {
    @IBInspectable
    @objc var myaText: String {
        set {
            self.setTitle(MYALocalizable(key: newValue), for: .normal)
        }
        get {
            return self.title(for: .normal)!
        }
    }
}

extension UITextField {
    @IBInspectable
    @objc var myaText: String {
        set {
            self.text = MYALocalizable(key: newValue)
        }
        get {
            return self.text!
        }
    }
    
    @IBInspectable
    @objc var myaPlaceholderText: String {
        set {
            self.placeholder = MYALocalizable(key: newValue)
        }
        get {
            return self.placeholder!
        }
    }
}
