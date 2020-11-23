/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

class OverlayHostViewController: UIViewController {

    // If set, this is the view controller where the overlay is added. Also useful for unit testing
    var overlayTargetViewController: UIViewController?

    var overlayViewController: OverlayViewController?
    var overlayView: UIView?
    var nestedViewController: UIViewController?
    var overlayStoryBoardID: String!

    static func wrap(nestedViewController: UIViewController?, overlayStoryBoardID: String) -> UIViewController? {
        guard let contentViewController = nestedViewController else {
            return nil
        }

        let overlayHostVC = OverlayHostViewController(nibName: nil, bundle: nil)
        overlayHostVC.nestedViewController = contentViewController
        overlayHostVC.overlayStoryBoardID = overlayStoryBoardID
        return overlayHostVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let childViewController = nestedViewController {
            self.addChild(childViewController)
            self.view.addSubview(childViewController.view)
            setOverlay()
        }
    }

    func setOverlay() {
        let storyboard = UIStoryboard(name: Overlays.STORYBOARD, bundle: nil)
        overlayViewController = storyboard.instantiateViewController(withIdentifier: overlayStoryBoardID) as? OverlayViewController
        overlayViewController?.delegate = self
        overlayView = overlayViewController?.view

        if let overlay = overlayView {
            nestedViewController?.view.addSubview(overlay)
        }
    }

}

extension OverlayHostViewController: OverlayDelegate {
    func dismissOverlay() {
        overlayView?.removeFromSuperview()
    }
}
