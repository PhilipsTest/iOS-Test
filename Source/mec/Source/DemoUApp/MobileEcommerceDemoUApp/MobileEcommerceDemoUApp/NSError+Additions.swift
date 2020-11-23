/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

struct IAPOAuthNotFoundError {
    static let kOAuthDomainKey   = "OAUTH_NOT_FOUND"
    static let oauthNotFoundCode = 1001
    static let oauthErrorDescriptionKey = "OAUTH_ERROR_DESCRIPTION"
}

struct IAPOutOfStockError{
    static let kOutOfStockKey    = "OUT_OF_STOCK"
    static let productOutOfStock = 1002
    static let productStockDescriptionKey = "PRODUCT_OUT_OF_STOCK"
}

struct HTTPErrorResponseCode {
    static let apiErrorResponseCode = 4000
    static let kErrorDictionaryKey  = "Error_Info_Dict"
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    
    func displayMessage(_ withController:UIViewController) {
        
        var titleToDisplay:String?
        
        switch self.code
        {
            case IAPOAuthNotFoundError.oauthNotFoundCode,
                 IAPOutOfStockError.productOutOfStock,
                 HTTPErrorResponseCode.apiErrorResponseCode:
                 titleToDisplay = "Error"//NSLocalizedString("Error", bundle: Bundle(for: ), comment: "Error")
            break
            
            default:
                titleToDisplay = self.localizedDescription
            break
        }
        
        let okAction   = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { action -> Void in }
        self.displayAlert(titleToDisplay, withMessage: self.localizedDescription, actionArray: [okAction], usingController: withController)
    }
    
    func displayAlert(_ withTitle:String?, withMessage:String, actionArray:[UIAlertAction], usingController:UIViewController) {
        DispatchQueue.main.async { () -> Void in
            let controller = UIAlertController(title: withTitle, message: withMessage, preferredStyle: UIAlertController.Style.alert)
            for action in actionArray {
                controller.addAction(action)
            }
            usingController.present(controller, animated: true, completion: nil)
        }
    }

}
