/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import AppInfra

class IAPBuyDirectViewController: IAPBaseViewController, IAPProductAndHistoryProtocol {
    fileprivate var cartSyncHelper:IAPCartSyncHelper!
    fileprivate var defaultAddress:IAPUserAddress!
    fileprivate var paymentInfo: IAPPaymentInfo!
    fileprivate var cartInfo: IAPCartInfo!
    var productCTN:String!
    var wasCartCreatedForBuyDirect = false

    @IBOutlet weak var buyDirectStageLabel: UIDLabel!
    @IBOutlet weak var buyDirectActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartSyncHelper = IAPCartSyncHelper()
        self.initialiseAndLoadData()
    }
    /*
     * TEMP: Below three methods are added to pass the build. As buy direct feature is out of scope now,
        below methods are commented. Once it becomes part of feature release, code flow needs to be walked through
        and verified.
     */
    func initialiseAndLoadData() {
        
    }
    func fetchDataForPage(_ currentPage:Int) {
        
    }
    
    func userSwipedToGetBack() {
        
    }
}
