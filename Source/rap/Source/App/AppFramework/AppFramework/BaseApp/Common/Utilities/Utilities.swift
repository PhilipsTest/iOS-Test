/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import PhilipsUIKitDLS
import PlatformInterfaces


class Utilites : NSObject {
    
    //MARK: Variable Declarations
      static var defaultViewController :UIViewController?
      static var uidAlertController : UIDAlertController?
      static var dialogController: UIDDialogController?
    //MARK: Helper methods
    
    static func readDataFromFile(_ keyType : String!) -> [AnyObject] {
        let filePath = Bundle.main.path(forResource: Constants.CONFIGURATION_FILE_NAME, ofType: Constants.PLIST_TYPE)
        let fileContents = NSDictionary(contentsOfFile: filePath!)
        let screenContents = fileContents?.value(forKey: keyType) as? [AnyObject]
        return screenContents!
    }
    
    static func showDLSAlert(withTitle title:String?, withMessage message:String?,buttonAction actions:[UIDAction]?, usingController controller:UIViewController?) {
        let presentingViewController : UIViewController? = controller ?? UIApplication.shared.keyWindow?.rootViewController
        uidAlertController = UIDAlertController(title: title, message: message)
        if let uidActions = actions{
            for action in uidActions{
                uidAlertController?.addAction(action)
            }
        }
        if let uidAlert = uidAlertController{
            presentingViewController?.present(uidAlert, animated: true, completion: nil)
        }
    }
    
    static func showActivityIndicator(with message: String = "",  using controller: UIViewController) {
        let progressIndicatorLabel = UIDProgressIndicatorWithLabel()
        progressIndicatorLabel.circularProgressIndicatorLabelAlignment = .bottom
        progressIndicatorLabel.circularProgressIndicatorSize = .large
        progressIndicatorLabel.progressIndicatorStyle = .indeterminate
        progressIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        progressIndicatorLabel.labelText = message
        dialogController =  UIDDialogController(title: nil, icon: nil, backgroundStyle: .strong)
        dialogController?.containerView = progressIndicatorLabel
        if let dialogControl = dialogController {
            controller.present(dialogControl, animated: true, completion: nil)
        }

    }
    
    static func removeActivityIndicator(onCompletionExecute completion: (() -> Swift.Void)?) {
        dialogController?.dismiss(animated: true, completion: completion)
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
    }
    
    static func addCartIconTo(_ viewController : UIViewController) {
        viewController.navigationItem.rightBarButtonItem = getCartIcon()
    }
    static func removeCartIconTo(_ viewController : UIViewController) {
        viewController.navigationItem.rightBarButtonItem = nil
    }
    
    static func getCartIcon() -> UIBarButtonItem {
        if Constants.APPDELEGATE?.cartIcon == nil {
            Constants.APPDELEGATE?.cartIcon = UIBarButtonItem(badge: "0", title: "", target: Constants.APPDELEGATE, action: #selector(AppDelegate.cartIconPressed))
        }
        return ((UIApplication.shared.delegate as? AppDelegate)?.cartIcon)!
    }
    
    static func associatedObject(
        _ base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> Bool)
        -> Bool {
            if let associated = objc_getAssociatedObject(base, key)
                as? Bool { return associated }
            let associated = initialiser()
            objc_setAssociatedObject(base, key, associated,
                                     .OBJC_ASSOCIATION_RETAIN)
            return associated
    }
    
    static func associateObject(
        _ base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: Bool) {
        objc_setAssociatedObject(base, key, value,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
    
    static func getDefaultViewController() -> UIViewController? {
        guard defaultViewController == nil else {
            return defaultViewController
        }
        let storyboard = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil)
        defaultViewController = storyboard.instantiateViewController(withIdentifier: Constants.DEFAULT_VIEWCONTROLLER_STORYBOARD_ID)
        return defaultViewController
    }
    
    
    static func aFLocalizedString(_ key: String) -> String?{
      return AppInfraSharedInstance.sharedInstance.appInfraHandler?.languagePack.localizedString(forKey: key)
    }
    
    static func handlePropertyForKey(_ userRegState: UserRegistrationState, typeOfAccessor: PropertyAccessor, key: String , group: String, value: AnyObject?) -> AnyObject? {
        
        switch typeOfAccessor {
            
        case .get:
            return userRegState.getPropertyForKey(key, group: group)
        case .set:
            userRegState.setPropertyForKey(key, value: value! as AnyObject, group: group)
        }
        return nil
    }
    
    static func checkForDeviceJailbreakStatus()->String?{
        // Put gaurd 
        let checkJailbreak = AppInfraSharedInstance.sharedInstance.appInfraHandler?.storageProvider.getDeviceCapability()
        return checkJailbreak
    }
    static func checkForDevicePasscodeStatus()->Bool?{
        let checkPasscode = AppInfraSharedInstance.sharedInstance.appInfraHandler?.storageProvider.deviceHasPasscode()
        return checkPasscode
    }
    
    static func getCurrentDate()-> String{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        return "Last Updated: \(day)/\(month) - \(hour):\(minutes)"
    }
    
}
