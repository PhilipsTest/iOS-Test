/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

class Launcher : NSObject {
    
    static func navigateToViewController(_ fromViewController : UIViewController?,toViewController : UIViewController?, loadDetails : ScreenToLoadModel) {
        
        switch loadDetails.viewControllerLoadType {
        case .Segue:
            if loadDetails.segueId != nil {
                fromViewController?.performSegue(withIdentifier: loadDetails.segueId!, sender: fromViewController)
            }
        case .Push:
            if toViewController != nil {
                let newViewController = (toViewController is UINavigationController) ? (toViewController as? UINavigationController)?.topViewController : toViewController
                if newViewController != nil {
                    fromViewController?.navigationController?.pushViewController(newViewController!, animated: loadDetails.animates)
                }
            }
        case .EmbedSubview:
            if toViewController != nil {
                fromViewController?.view.addSubview((toViewController?.view)!)
            }
        case .Modal:
            if toViewController != nil {
                fromViewController?.present(toViewController!, animated: loadDetails.animates, completion: nil)
                fromViewController?.modalTransitionStyle = loadDetails.modalTransitionStyle != nil ? loadDetails.modalTransitionStyle! : UIModalTransitionStyle.coverVertical
                fromViewController?.modalPresentationStyle = loadDetails.modalPresentationStyle != nil ? loadDetails.modalPresentationStyle! : UIModalPresentationStyle.fullScreen
            }
        case .Root:
            let window = UIApplication.shared.keyWindow != nil ? UIApplication.shared.keyWindow! : (Constants.APPDELEGATE?.window)!
            window.rootViewController = toViewController
        case .EmbedChild:
            if toViewController != nil {
                fromViewController?.addChild(toViewController!)
                toViewController?.view.frame =  CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: (fromViewController?.view.frame)!.width, height: (fromViewController?.view.frame)!.height))
                fromViewController?.view.addSubview((toViewController?.view)!)
                toViewController?.didMove(toParent: fromViewController)
            }
        case .RemoveChild:
            toViewController?.willMove(toParent: nil)
            toViewController?.view.removeFromSuperview()
            toViewController?.removeFromParent()
        }
    }
}
