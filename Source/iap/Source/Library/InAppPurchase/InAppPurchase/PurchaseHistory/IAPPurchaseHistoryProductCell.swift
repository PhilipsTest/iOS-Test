/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol IAPOrderTrackingProtocol: NSObjectProtocol {
    func didSelectTrackOrder(trackingURL: String)
}

class IAPPurchaseHistoryProductCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UIDLabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UIDLabel!
    @IBOutlet weak var productQuantityLabel: UIDLabel!
    @IBOutlet weak var trackOrderButton: UIDButton!
    
    weak var orderTrackDelegate: IAPOrderTrackingProtocol?
    var orderTrackingURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
    }
    
    func updateUI() {
        self.selectionStyle = .none
    }
    
    @IBAction func trackOrderButtonTapped(_ sender: Any) {
        guard let delegate = orderTrackDelegate, let trackURL = orderTrackingURL else {
            return
        }
        delegate.didSelectTrackOrder(trackingURL: trackURL)
    }
}
