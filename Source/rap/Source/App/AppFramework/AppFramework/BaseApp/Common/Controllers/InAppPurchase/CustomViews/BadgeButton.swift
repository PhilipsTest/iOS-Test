/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/** extended custom implementation of UILabel */
extension UILabel {
    convenience init(badgeText: String, color: UIColor = UIColor.red, fontSize: CGFloat = UIFont.smallSystemFontSize) {
        self.init()
        textColor = UIColor.white
        backgroundColor = color
        
        font = UIFont.systemFont(ofSize: fontSize)
        layer.cornerRadius = fontSize * CGFloat(0.6)
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0))
    }
}

/** extended custom implementation of UIBarButtonItem */
extension UIBarButtonItem {
    
    convenience init(badge: String?, title: String, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        button.frame =  CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:42.0,height:42.0))
        button.setImage(UIImage(named: Constants.INAPP_SHOPPING_TROLLY_IMAGE_NAME ), for: UIControl.State.normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        let badgeLabel = UILabel(badgeText: badge ?? "")
        button.addSubview(badgeLabel)
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 5))
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1, constant: 10))
        if nil == badge {
            badgeLabel.isHidden = true
        }
        badgeLabel.tag = UIBarButtonItem.badgeTag
        
        self.init(customView: button)
    }
    
 ///Custom label implementation for cart icon
    var badgeLabel: UILabel? {
        return customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }
    
///Custom Button implementation for cart icon
    var badgedButton: UIButton? {
        return customView as? UIButton
    }
    
    /// Assign value to label
    var badgeString: String? {
        get { return badgeLabel?.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            }
        set {
            if let badgeLabel = badgeLabel {
                badgeLabel.text = nil == newValue ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.isHidden = nil == newValue
                
                if let valueSet = newValue {
                    if let value = Int(valueSet) {
                        badgeLabel.isHidden = 0 == value
                    }
                }
            }
        }
    }
    
    var badgedTitle: String? {
        get { return badgedButton?.title(for: .normal) }
        set { badgedButton?.setTitle(newValue, for: .normal)/*; badgedButton?.sizeToFit()*/ }
    }
    
    fileprivate static let badgeTag = 7373
}
