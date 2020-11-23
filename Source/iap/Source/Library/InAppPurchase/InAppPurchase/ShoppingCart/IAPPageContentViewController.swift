/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AFNetworking

class IAPPageContentViewController: UIViewController {
    
    @IBOutlet weak var productDetailImageView: UIImageView!
    
    var imageUrlString: String!
    var index: Int = 0
    var containerHeight : CGFloat!
    var containerWidth : CGFloat!
    var isErrorToBeShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productDetailImageView.contentMode = .scaleToFill
        guard false == isErrorToBeShown else {
            self.productDetailImageView.contentMode = .center
            let defaultImage = UIImage.init(named: "Product Image", in: IAPUtility.getBundle(), compatibleWith: nil)
            self.productDetailImageView.image = defaultImage
            return
        }
        AFImageDownloader.defaultInstance().sessionManager
            .responseSerializer
            .acceptableContentTypes?
            .insert(IAPConstants.IAPPRXConsumerKeys.kImageJP2Format)
        self.productDetailImageView.setImageWith(URL(string: String(format: self.imageUrlString, String(Int(self.containerWidth)),String(Int(self.containerHeight))))!, placeholderImage: nil)
    }
}
