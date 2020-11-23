/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra

/**AppInfraSharedInstance provides a singleton for all AppInfra activity. Its created for the purpose of providing single dependency on AppInfra Library*/
public class AppInfraSharedInstance: NSObject {
    
    //MARK: Variable Declaration
    ///Singleton variable
    public static let sharedInstance = AppInfraSharedInstance()
    ///Object for AILoggingProtocol
    var loggingForAppFramework : AILoggingProtocol?
    ///Object for AIAppTaggingProtocol
    var taggingForAppFramework : AIAppTaggingProtocol?
    var appInfraHandler : AIAppInfra?
    
    /** Init method for singleton AppInfraSharedInstance class */
    fileprivate override init() {
        super.init()
        let abTestManager = AIABTestManager()
        let appinfraBuilder = AIAppInfraBuilder()
        appinfraBuilder.abtest = abTestManager
        appInfraHandler = AIAppInfra(builder: appinfraBuilder)
        abTestManager.setupAppInfra(appInfra: appInfraHandler!)
        // Tagging 
        taggingForAppFramework = appInfraHandler?.tagging
        // Logging
        loggingForAppFramework = appInfraHandler?.logging
    }
    func getVersion() -> String {
        return (appInfraHandler?.getVersion())!
    }
    
    func initializeLanguagePack() {
        self.appInfraHandler?.languagePack.refresh({ (status, error) in
            if  let error = error {
                self.loggingForAppFramework?.log(.error, eventId: "AFLanguagePack", message: error.localizedDescription)
                return ;
            }
            else{
                self.appInfraHandler?.languagePack.activate({ (activateStatus, error) in
                    switch activateStatus {
                    case .updateActivated:
                        self.loggingForAppFramework?.log(.info, eventId: "AFLanguagePack", message:"languagepack updateActivated")
                        break
                    case .noUpdateStored:
                        self.loggingForAppFramework?.log(.info, eventId: "AFLanguagePack", message:"languagepack noUpdateStored")
                        break
                    case .failed:
                        if  let error = error {
                            self.loggingForAppFramework?.log(.error, eventId: "AFLanguagePack", message:"languagepack activate failed : \(error.localizedDescription)")
                        }
                        break
                    }
                })
            }
        })
    }
}
