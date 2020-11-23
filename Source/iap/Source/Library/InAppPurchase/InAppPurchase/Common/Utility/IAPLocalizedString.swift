/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

func IAPLocalizedString(_ key: String?, _ args: CVarArg...) -> String? {
    guard let inKey = key else {
        return nil
    }
    let localizedFormat = NSLocalizedString(inKey, bundle: IAPUtility.getBundle(), comment: inKey)
    return args.count == 0
        ? localizedFormat
        : String(format: localizedFormat, arguments: args)
}

func IAPUNWrappedLocaliseString(_ key: String, _ args: CVarArg...) -> String {
    return (IAPLocalizedString(key, args) ?? "")
}

extension UILabel {
    @IBInspectable
     var IAPlocalizedText: String {
        set (key) {
            text = IAPLocalizedString(key)
        }
        get {
            return text!
        }
    }
}

extension UIButton {
    @IBInspectable
     var IAPlocalizedTitleForNormal: String {
        set (key) {
            setTitle(IAPLocalizedString(key), for: UIControl.State())
        }
        get {
            return title(for: UIControl.State())!
        }
    }
}

extension UITextField {
    @IBInspectable
     var IAPlocalizedTitleForPlaceHolder: String {
        set (key) {
            placeholder = IAPLocalizedString(key)
        }
        get {
            guard let text = placeholder else { return ""}
            return text
        }
    }
}
