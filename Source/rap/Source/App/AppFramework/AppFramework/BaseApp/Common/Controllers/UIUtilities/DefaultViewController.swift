/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import PhilipsUIKitDLS

class DefaultViewController: UIViewController {
    
    //MARK: Default methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DefaultViewController : StateCommunicationListener{
    
    func communicateFromState(_ state: BaseState?) -> AnyObject? {
        switch (state?.stateId)! {
        case AppStates.InAppPurchase :
            let errorFromState = (state as? InAppPurchaseCatalogueViewState)?.errorFromIAP
            let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
            guard errorFromState != nil else{
                Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: nil)
                return nil
            }
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: errorFromState?.localizedDescription, buttonAction: [alertAction], usingController: nil)
            return nil
        default:
            return nil
        }
    }
}
