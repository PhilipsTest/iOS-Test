//
//  PPRSuccessViewControllerExt.swift
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

extension PPRSuccessViewController: PPRNavigationControllerBackButtonDelegate {
    func viewControllerShouldPopOnBackButton() -> Bool {
        return (self.navigationController?.skipViewControllerWhenBackPressed(viewController: PPRRegisterProductsViewController()))!
    }
}

/// - Since: 1.0.0
@IBDesignable
class UIViewSeperator: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        seperationCustomInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        seperationCustomInit()
    }
    func seperationCustomInit(){
        backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorInputBackground
        
    }
}
