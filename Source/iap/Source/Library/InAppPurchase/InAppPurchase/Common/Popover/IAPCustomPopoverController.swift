/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

protocol CustomPopoverControllerDelegate {
    func controllerDidDismissPopover(_ presentedViewController: AnyObject)
}

class IAPCustomPopoverController: UIViewController, UIPopoverPresentationControllerDelegate {
    var popoverDelegate: CustomPopoverControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func popOverMenuOnItem(_ sender:UIView, presentationController: UIViewController, presentingController: UIViewController, preferredContentSize: CGSize) {
        presentationController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = presentationController.popoverPresentationController!
        if popover == presentationController.popoverPresentationController {
            let viewForSource = sender as UIView
            popover.sourceView = viewForSource
            // the position of the popover where it's showed
            popover.sourceRect = viewForSource.bounds
            presentationController.preferredContentSize = preferredContentSize
            popover.delegate = self
        }
        presentingController.present(presentationController, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let popover = popoverPresentationController.presentedViewController
        if nil != self.popoverDelegate?.controllerDidDismissPopover {
            self.popoverDelegate?.controllerDidDismissPopover(popover)
        }
    }
}

