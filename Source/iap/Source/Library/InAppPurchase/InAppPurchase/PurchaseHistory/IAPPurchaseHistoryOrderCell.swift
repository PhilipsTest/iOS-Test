//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
import UIKit
import PhilipsUIKitDLS
import PhilipsIconFontDLS

class IAPPurchaseHistoryOrderCell: UITableViewCell {

    @IBOutlet weak var orderStatusLabel: UIDLabel!
    @IBOutlet weak var rightArrowIcongray: UIButton!
    @IBOutlet weak var productHolderView: UIDView!
    @IBOutlet weak var totalLabel: UIDLabel!
    @IBOutlet weak var productHolderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderTextLabel: UIDLabel!
    @IBOutlet weak var totalPriceLabel: UIDLabel!
    @IBOutlet weak var statusIconImage: UIDLabel!
    var productModelCollection = [IAPProductModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    func updatewithOrder(purchaseHistory: IAPPurchaseHistoryModel) {
        orderTextLabel.text = IAPLocalizedString("iap_order_number")! +
            " " + String(format: "\(purchaseHistory.getOrderID())")
        orderStatusLabel.text = IAPLocalizedString("iap_order_state", purchaseHistory.getOrderDisplayStatus())
        productModelCollection = purchaseHistory.products
        totalPriceLabel.text = purchaseHistory.getOrderPriceValue()
    }

    func addProductsDescriptionView(_ inWidth: CGFloat) {
        var previousView:IAPOrderHistoryProductDescriptionView?

        for product in productModelCollection {
            guard let viewToBeAdded = IAPOrderHistoryProductDescriptionView.getProductView() else { continue }
            viewToBeAdded.translatesAutoresizingMaskIntoConstraints = false
            viewToBeAdded.updateUIWithModel(product)
            viewToBeAdded.adjustUIForProductTitleWithWidthConstraint(inWidth)
            self.productHolderView.addSubview(viewToBeAdded)
            self.adjustCurrentViewPosition(viewToBeAdded, afterProductView: previousView)

            if previousView != nil {
                self.productHolderHeightConstraint.constant += viewToBeAdded.viewHeight.constant
            } else {
                self.productHolderHeightConstraint.constant = viewToBeAdded.viewHeight.constant
            }
            previousView = viewToBeAdded
        }
    }

    private func updateUI() {
        rightArrowIcongray = IAPUtility.getButtonWithFontIcon(button: rightArrowIcongray,
                                                              fontName: IAPConstants.IAPFontIconName.rightArrowIcon,
                                                              fontColor: UIColor.color(range: .blue,
                                                                                       level: .color15)!)
        rightArrowIcongray.tintColor = UIColor.darkGray
        statusIconImage?.textColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryFocusBackground
        statusIconImage?.font =  UIFont.iconFont(size: 14.0)
        statusIconImage?.text = PhilipsDLSIcon.unicode(iconType: .infoCircle)
        totalLabel.text = IAPLocalizedString("iap_total")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productHolderView.subviews.forEach({ $0.removeFromSuperview() })
        self.productHolderHeightConstraint.constant = IAPConstants.IAPOrderHistoryUIConstants.kProductViewDefaultHeight
    }
    
    private func adjustCurrentViewPosition(_ inViewAdded: IAPOrderHistoryProductDescriptionView,
                                           afterProductView:IAPOrderHistoryProductDescriptionView?) {

        let leadSpacing = NSLayoutConstraint(item: inViewAdded, attribute: NSLayoutConstraint.Attribute.leading,
                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                             toItem: self.productHolderView,
                                             attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0.0)
        let trailSpacing = NSLayoutConstraint(item: inViewAdded, attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self.productHolderView,
                                              attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: inViewAdded, attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1,
                                                  constant: inViewAdded.viewHeight.constant)
        
        guard let previousView = afterProductView else {
            let topSpacing = NSLayoutConstraint(item: inViewAdded, attribute: NSLayoutConstraint.Attribute.top,
                                                relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.productHolderView,
                                                attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0.0)
            self.productHolderView.addConstraints([topSpacing, leadSpacing, trailSpacing,heightConstraint])
            return
        }
        let topSpacing = NSLayoutConstraint(item: inViewAdded, attribute: NSLayoutConstraint.Attribute.top,
                                            relatedBy: NSLayoutConstraint.Relation.equal, toItem: previousView,
                                            attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0.0)
        self.productHolderView.addConstraints([topSpacing, leadSpacing, trailSpacing, heightConstraint])
    }
}
