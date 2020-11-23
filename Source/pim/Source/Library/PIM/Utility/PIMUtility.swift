/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppInfra
import PhilipsUIKitDLS

struct PIMDefaults {
    
    static let userSubUUIDKey = "com.pim.activeuuid"
    
    static func saveSubUUID(_ value: String) {
        UserDefaults.standard.set(value, forKey: userSubUUIDKey)
    }
    
    static func getSubUUID()-> String? {
        return UserDefaults.standard.value(forKey: userSubUUIDKey) as? String
    }
    
    static func clearSubUUID() {
        UserDefaults.standard.removeObject(forKey: userSubUUIDKey)
    }
}

struct PIMUtilities {
    
    static func getUDIBundle() -> Bundle {
        return Bundle(for: PIMInterface.self)
    }
    
    static func getUDIViewController(storyboard: UDIStoryboard) -> UIViewController? {
        return storyboard.viewcontroller(storyboardID: storyboard.rawValue)
    }
    
    static func showErrorAlertController(error: Error?, presentationView: UIViewController) {
        if let inError = error {
            let alertController = UIDAlertController(title:"" , message: inError.localizedDescription)
            let okAction = UIDAction(title: "PIM_Action_OK".localiseString(args: []), style: .primary) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            presentationView.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func getStaticConfig(_ configKey: String, appinfraConfig: AIAppConfigurationProtocol?) -> String {
        guard let appInfra = appinfraConfig else {
            return ""
        }
        do {
            let configValue = try appInfra.getPropertyForKey(configKey, group: PIMConstants.Network.GROUP_NAME)
            return configValue as! String
        }catch{
            PIMUtilities.logMessage(.debug, eventId: "PIMUtilities", message: "Appconfig key value is not properly set:\(error.localizedDescription)")
        }
        return ""
    }
    
    static func logMessage(_ level:AILogLevel, eventId:String, message:String) {
        guard let logger = PIMSettingsManager.sharedInstance.loggingInterface() else {
            return
        }
        logger.log(level, eventId: eventId, message: message)
    }
    
    static func tagEvent(_ message: String) {
        guard let tagging = PIMSettingsManager.sharedInstance.taggingInterface() else {
            return
        }
        tagging.trackAction(withInfo: message, paramKey: nil, andParamValue: nil)
    }
    
    static func tagUDIError(_ errorCategory: AITaggingErrorCategory, inError: NSError, errorType: String?, serverName: String?) {
        guard let tagging = PIMSettingsManager.sharedInstance.taggingInterface() else {
            return
        }
        let udiError: AITaggingError = AITaggingError(errorType: errorType, serverName: serverName, errorCode: String(inError.code), errorMessage: inError.localizedDescription)
        tagging.trackErrorAction?(errorCategory, taggingError: udiError)
    }

}

enum UDIStoryboard: String {
    case udiLoginScene     = "PIMLoginScene"
    case udiProfileScene   = "PIMProfileScene"
    case udiGuestUserScene = "PIMGuestUserScene"
    
    var storyboardInstance: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: PIMUtilities.getUDIBundle())
    }

    func viewcontroller(storyboardID: String) -> UIViewController? {
        return storyboardInstance.instantiateViewController(withIdentifier: storyboardID)
    }
}
