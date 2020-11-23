//
//  NSMutableAttributedString.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    private func getParaGraphStyle() -> NSMutableParagraphStyle {
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.lineSpacing = 5
        paragrahStyle.paragraphSpacing = 4.0
        paragrahStyle.paragraphSpacingBefore = 3
        paragrahStyle.firstLineHeadIndent = 0.0 // First line is the one with bullet point
        paragrahStyle.headIndent = 10.5    // Set the indent for given bullet character and size font
        return paragrahStyle
    }
    
    func applyDefaultParagraphStyle(font: UIFont, textColor: UIColor)  {
        let paragrahStyle = self.getParaGraphStyle()
        let attributes = [NSAttributedString.Key.paragraphStyle: paragrahStyle, NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font]
        self.addAttributes(attributes, range: NSMakeRange(0, self.length))
    }
    
    func highlightText(linkAttribute: String,
                       range: NSRange,
                       font: UIFont,
                       textColor: UIColor)
    {
        let font = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font]
        
        self.addAttributes([NSAttributedString.Key.link : linkAttribute, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue], range: range)
        self.addAttributes(font, range: range)
    }
}
