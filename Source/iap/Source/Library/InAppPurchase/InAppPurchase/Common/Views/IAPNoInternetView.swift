/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

protocol IAPNoInternetProtocol:class {
    func didTapTryAgain()
}

class IAPNoInternetView : UIView {
    
    @IBOutlet weak var tryAgainButton: UIDButton!
    @IBOutlet weak var noInternetLabel: UIDLabel!
    weak var delegate:IAPNoInternetProtocol?
    
    class func instanceFromNib() -> IAPNoInternetView? {
        return UINib(nibName: IAPNibName.IAPNoInternetView,
                     bundle: IAPUtility.getBundle()).instantiate(withOwner: nil, options: nil)[0] as? IAPNoInternetView
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.initialiseText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialiseText()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialiseText()
    }
    
    func initialiseText() {
        self.noInternetLabel?.text = IAPLocalizedString("iap_check_internet_connection")
        self.tryAgainButton?.setTitle(IAPLocalizedString("iap_try_again"), for: UIControl.State())
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: AnyObject) {
        self.delegate?.didTapTryAgain()
    }
}
