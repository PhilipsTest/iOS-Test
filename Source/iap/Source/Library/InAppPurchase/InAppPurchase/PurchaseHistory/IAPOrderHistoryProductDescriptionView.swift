/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class IAPOrderHistoryProductDescriptionView: UIView {

    @IBOutlet weak var productTitleLabel: UIDLabel!
    @IBOutlet weak var productThumbnailImage: UIImageView!
    @IBOutlet weak var productQuantityLabel: UIDLabel!
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    
    class func getProductView() -> IAPOrderHistoryProductDescriptionView? {

        return UINib(nibName: IAPNibName.IAPOrderHistoryProductDescriptionView,
                     bundle: IAPUtility.getBundle()).instantiate(
                        withOwner: nil, options: nil)[0] as? IAPOrderHistoryProductDescriptionView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func adjustUIForProductTitleWithWidthConstraint(_ inWidth: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.viewWidth.constant = inWidth
        self.viewHeight.constant = IAPConstants.IAPOrderHistoryUIConstants.kProductViewDefaultHeight
        
        guard let productTitle = self.productTitleLabel.text else { return }
        let widthToBeUsed = inWidth - self.productThumbnailImage.frame.size.width - IAPConstants.IAPOrderHistoryUIConstants.kWidthValueToBeUsed
        let labelHeight = productTitle.heightWithConstrainedWidth(widthToBeUsed, font: self.productTitleLabel.font)
        let difference = labelHeight - IAPConstants.IAPOrderHistoryUIConstants.kProductTitleDefaultHeight
        
        guard difference > 0.0 else { return }
        self.titleLabelHeight.constant = labelHeight
        self.viewHeight.constant += difference
    }
    
    func updateUIWithModel(_ inProduct: IAPProductModel) {
        self.productQuantityLabel.text = IAPLocalizedString("iap_quantity",String(inProduct.getQuantity()))!
        if (inProduct.getProductThumbnailImageURL() != "") {
            self.productThumbnailImage.setImageWith(URL(string: inProduct.getProductThumbnailImageURL())!,
                                                    placeholderImage: nil)
        }
        self.productTitleLabel.text = inProduct.getProductTitle()
    }
}
