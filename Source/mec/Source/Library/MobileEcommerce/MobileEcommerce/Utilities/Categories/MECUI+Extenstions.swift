/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

extension UILabel {

    // swiftlint:disable legacy_constructor

    func setStrikeThroughAttributedText(_ inputString: String?) {
        guard let stringValue = inputString else { return }
        let attributeString =  NSMutableAttributedString(string: stringValue)
        attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }

    // swiftlint:enable legacy_constructor

    func displayOutOfStock() {
        text = MECLocalizedString("mec_out_of_stock")
        textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextError
    }

    func displayInStock() {
        text = MECLocalizedString("mec_in_stock")
        textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextSuccess
    }

    func displayRetailerProductPrice(price: String?) {
        if let price = price {
            if !price.isEmpty && price.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                text = price
            }
        }
    }

    @IBInspectable
    var MECLocalizedText: String? {
        get {
            return text
        }
        set (key) {
            text = MECLocalizedString(key)
        }
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }

    static func instantiateFromAppStoryboard(appStoryboard: MECAppStoryboard) -> Self? {
        return appStoryboard.viewcontroller(viewControllerClass: self)
    }

    func isModal() -> Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}

 extension UIFont {
    private static let mecCustomIconFontName = "mec_iconfont"

    class func mecIconFont(size: CGFloat) -> UIFont? {
        guard let font = UIFont(name: mecCustomIconFontName, size: size) else {
            loadMECCustomIconFont()
            return UIFont(name: mecCustomIconFontName, size: size)
        }
        return font
    }

    private class func loadMECCustomIconFont() {
        guard let fontPath = MECUtility.getBundle().path(forResource: mecCustomIconFontName, ofType: "ttf") else {
            return
        }
        if let fontData = NSData(contentsOfFile: fontPath) {
            loadMECCustomFont(fontData: fontData)
        }
    }

    private class func loadMECCustomFont(fontData: NSData?) {
        if let fontData = fontData {
            let fontDataProvider = CGDataProvider(data: fontData)
            _ = UIFont.familyNames
            if let fontDataProvider = fontDataProvider {
                if let font = CGFont(fontDataProvider) {
                    CTFontManagerRegisterGraphicsFont(font, nil)
                }
            }
        }
    }
}

extension UIImage {

  class func imageWithMECIconFontType(_ type: MECIconFontType, iconSize: CGFloat, iconColor: UIColor = .black) -> UIImage? {
       let label = UILabel()
       label.font = UIFont.mecIconFont(size: iconSize)
       label.text = MECIconFont.unicode(iconType: type)
       label.textColor = iconColor
       label.sizeToFit()
       return label.drawImage()
   }
}

extension UINavigationController {

    func moveToProductCatalogueScreen() {
        for viewController in viewControllers {
            if let productList = viewController as? MECProductCatalogueViewController {
                popToViewController(productList, animated: true)
                return
            }
        }
        if let productCatalogue = MECProductCatalogueViewController.instantiateFromAppStoryboard(appStoryboard: .productCatalogue) {
            pushViewController(productCatalogue, animated: true)
        }
    }

    func moveToShoppingCartScreen() {
        for viewController in viewControllers {
            if let shoppingCart = viewController as? MECShoppingCartViewController {
                popToViewController(shoppingCart, animated: true)
                return
            }
        }
        if let shoppingCart = MECShoppingCartViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart) {
            pushViewController(shoppingCart, animated: true)
        }
    }

    func replaceLastViewControllerWith(controller: UIViewController, animated: Bool) {
        var viewControllerStack = viewControllers
        viewControllerStack.removeLast()
        viewControllerStack.append(controller)
        setViewControllers(viewControllerStack, animated: animated)
    }

    func popToProductListScreen() {
        for viewController in viewControllers {
            if let productList = viewController as? MECProductCatalogueViewController {
                popToViewController(productList, animated: true)
                return
            }
        }
        if let productCatalogue = MECProductCatalogueViewController.instantiateFromAppStoryboard(appStoryboard: .productCatalogue) {
            var viewControllers = self.viewControllers
            viewControllers.removeAll { $0 is MECBaseViewController }
            viewControllers.append(productCatalogue)
            setViewControllers(viewControllers, animated: true)
        }
    }
}

extension UITextField {
    @IBInspectable
     var MECLocalizedPlaceHolderText: String? {
        get {
            return placeholder
        }
        set (key) {
            placeholder = MECLocalizedString(key)
        }
    }
}

extension UIButton {
    @IBInspectable
    var MECLocalizedButtonNormalTitle: String? {
        get {
            return title(for: .normal)
        } set (key) {
            setTitle(MECLocalizedString(key), for: .normal)
        }
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIDHeaderView {
    static func createMECHeaderView(frame: CGRect) -> UIDHeaderView {
        let headerView = UIDHeaderView(frame: frame)
        headerView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        headerView.headerLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        return headerView
    }
}
