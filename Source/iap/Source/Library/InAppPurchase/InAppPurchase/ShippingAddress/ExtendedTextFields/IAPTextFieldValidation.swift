/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import ObjectiveC
import UIKit
import PhilipsUIKitDLS

extension UITextField {
    
    fileprivate struct AssociatedKeys {
        static var validationRegExpKey = "validationRegExpKey"
        static var validityErrorMessageKey = "validityErrorMessageKey"
        static var maximumCharactersKey = "maximumCharactersKey"
    }
    
    @IBInspectable
    var validationRegExp:String! {
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.validationRegExpKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.validationRegExpKey) as? String
        }
    }
    
    @IBInspectable
    var validityErrorMessage:String! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.validityErrorMessageKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.validityErrorMessageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable
    var maximumCharacters:NSNumber! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.maximumCharactersKey) as? NSNumber
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.maximumCharactersKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    func validate(_ showError:Bool)->Bool {
        
        var validity:Bool = false
        let whitespaceSet = CharacterSet.whitespaces
        
        if self.text?.trimmingCharacters(in: whitespaceSet).count != 0 {
            validity = true
        }
        return validity
        
//        if (self.text?.count == 0 || self.text?.trimmingCharacters(in: whitespaceSet) != "" ){
//            guard (self.validationRegExp != nil) else { return validity }
//
//            let predicate = NSPredicate(format:"SELF MATCHES %@", self.validationRegExp)
//            validity = predicate.evaluate(with: self.text!)
//        }
//        return validity
    }
    
    func limitMaxCharacter(_ range:NSRange, string:String)->Bool {
        
        let currentCharacterCount = self.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        guard (self.maximumCharacters != nil) else { return true }
        return newLength <= self.maximumCharacters.intValue
    }
    
}
