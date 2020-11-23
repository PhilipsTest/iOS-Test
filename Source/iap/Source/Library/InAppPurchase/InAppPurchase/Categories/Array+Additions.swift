//
//  Array+Additions.swift
//  InAppPurchase
//
//  Created by Rayan Sequeira on 22/06/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

import Foundation
import PhilipsUIKitDLS

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension UITextView {
    
    func getTextViewSize() -> CGSize {
        self.isScrollEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        let size = self.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        return size;
    }
    
    func addLinkAttributesAsPerIAP(fontSize:CGFloat) {
        self.isSelectable = true
        self.isUserInteractionEnabled = true
        self.isEditable = false
        
        self.linkTextAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):(UIDThemeManager.sharedInstance.defaultTheme?.hyperlinkDefaultPressedText ?? UIColor.blue),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font : UIFont(uidFont: .bold, size: fontSize) ?? UIDFont.bold
        ]
    }
    
}

extension NSMutableAttributedString {
    func addIAPLinkAttributes(links:[(url:URL,range:NSRange)],fontSize:CGFloat) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        self.setAttributes([.foregroundColor : (UIDThemeManager.sharedInstance.defaultTheme?.labelRegularText ?? UIColor.black), .font : UIFont(uidFont: .medium, size: fontSize) ?? UIDFont.bold], range: NSRange(location: 0, length: self.length))
        
        for aLink in links {
            self.addAttribute(.link, value: aLink.url, range: aLink.range)
        }
    }
}

