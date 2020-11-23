/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

class IAPProductCatalogueCell: UITableViewCell {

    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UIDLabel!
    @IBOutlet weak var productDiscountLabel : UIDLabel!
    @IBOutlet weak var productNameLabel: UIDLabel!
    @IBOutlet weak var productCTNLabel: UIDLabel!
    @IBOutlet weak var stockStatusLabel: UIDLabel!
    @IBOutlet weak var stockStatusLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionView: UIView!
    
    func  removeUIElementsForNonHybris(){
        self.productPriceLabel.text = nil
        self.productDiscountLabel.text = nil
        self.stockStatusLabel.text = nil
    }
    
}
