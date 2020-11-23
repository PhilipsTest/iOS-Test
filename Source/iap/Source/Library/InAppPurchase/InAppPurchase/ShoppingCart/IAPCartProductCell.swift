/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

protocol IAPDeleteProductDelegate {
    func deleteSelectedProduct(cell:IAPCartProductCell)
}

class IAPCartProductCell: UITableViewCell {
    
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLbl: UIDLabel!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var quantityBtn: UIButton!
    @IBOutlet weak var productTotalPriceLbl: UIDLabel!
    @IBOutlet weak var outOfStockLbl: UIDLabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    @IBOutlet weak var outOfStockLblHeight: NSLayoutConstraint!
    
    var delegate: IAPDeleteProductDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    func updateUI() {        
        self.outOfStockLbl.sizeToFit()
        self.productQuantityLbl.textColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonQuietEmphasisText
    }
    
    func configureUIWithModel(_ inModel: IAPProductModel) {
        self.productNameLbl.text = inModel.getProductTitle()
        self.productQuantityLbl.text = IAPLocalizedString("iap_quantity", String(inModel.getQuantity()))!
        self.productTotalPriceLbl.text = inModel.getDiscountPrice().isEmpty ? inModel.getProductBasePriceValue() : inModel.getDiscountPrice()
        if (inModel.getProductThumbnailImageURL() != "") {
            self.productImgView!.setImageWith(URL(string: inModel.getProductThumbnailImageURL())!, placeholderImage: nil)
        }
    }
    
    @IBAction func deleteProducts(_ sender: Any) {
        delegate?.deleteSelectedProduct(cell: self)
    }
    
}
