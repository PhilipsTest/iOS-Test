//
//  PUILabel.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit

extension UILabel {
     
    func paragraph()  {
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.applyDefaultParagraphStyle(font: self.font, textColor: self.textColor)
        self.attributedText = attributedString;
    }
    
    func highlighteText(attributes:NSDictionary, isPragraph: Bool) {
        let attributedString = NSMutableAttributedString(string: self.text!)
        
        if isPragraph == true {
            attributedString.applyDefaultParagraphStyle(font: self.font, textColor: self.textColor)
        }
        
        for key: String in attributes.allKeys as! [String] {
            let range = (self.text! as NSString).range(of: key)
            attributedString.highlightText(linkAttribute: attributes[key] as! String, range: range, font: self.font, textColor: self.textColor)
        }
        
        self.attributedText = attributedString
    }
}
