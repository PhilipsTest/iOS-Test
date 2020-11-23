/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PlatformInterfaces

class IAPRefreshOAuthOperation: Operation {
    var completionHandler: (IAPOAuthInfo)->() = { arg in }
    var failureHandler: (NSError)->() = { arg in }
    
    fileprivate weak var delegate:IAPOauthRefreshProtocol?
    var oauthDownloadManager: IAPOAuthDownloadManager!
    
    init(downloadManager: IAPOAuthDownloadManager, withDelegate: IAPOauthRefreshProtocol) {
        oauthDownloadManager = downloadManager
        delegate = withDelegate
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        self.delegate?.cancelAllOperationsInOperationQueue(self)
        let httpInterface = oauthDownloadManager.getInterfaceForOAuth(true)
        self.oauthDownloadManager.getOAuthTokenWithInterface(httpInterface, successCompletion: { (oauth: IAPOAuthInfo) in
            IAPConfiguration.sharedInstance.oauthInfo = oauth
            self.delegate?.didCompleteOAuthRefresh(oauth, forOperation: self)
        }) { (inError: NSError) in
            self.delegate?.didFailOAuthRefresh(inError, forOperation: self)
        }
    }
}


class IAPLoginRefreshOperation: Operation, UserDataDelegate {
    var completionHandler: ()->() = { }
    var failureHandler: (NSError)->() = { arg in }
    fileprivate weak var delegate:IAPLoginRefreshProtocol?
    fileprivate var completedExecution: Bool = false
    
    init (withDelegate: IAPLoginRefreshProtocol, withCompletion: @escaping ()->(), withFailureHandler: @escaping (NSError)->()) {
        completionHandler = withCompletion
        failureHandler = withFailureHandler
        self.delegate = withDelegate
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        self.delegate?.cancelAllLoginOperationsInOperationQueue(self)
        IAPConfiguration.sharedInstance.getUDInterface()?.addUserDataInterfaceListener(self)
        IAPConfiguration.sharedInstance.getUDInterface()?.refreshSession()
        
        while(!self.completedExecution) {
            //IAPConfiguration.sharedInstance.log(.error, eventId: "IAPSessionRefreshHandler", message: "Waiting for login refresh to complete")
            RunLoop.current.run(mode: RunLoop.Mode.common, before: Date.distantFuture)
        }
    }
    
    func refreshSessionSuccess(){
        IAPConfiguration.sharedInstance.log(.info, eventId: "IAPSessionRefreshHandler",
                                            message: "Login refresh did complete")
        self.completionHandler()
        self.delegate?.didCompleteLoginRefresh(self)
        self.completedExecution = true
    }
    
    private func refreshSessionFailed(_ error: NSError) {
        IAPConfiguration.sharedInstance.log(.error, eventId: "IAPSessionRefreshHandler", message:
            "*** Error in Login refresh with \(error.localizedDescription) with code \(error.code)***")
        self.failureHandler(error)
        self.delegate?.didFailLoginRefresh(error, forOperation: self)
        self.completedExecution = true
    }
    
    func forcedLogout() {
        IAPConfiguration.sharedInstance.log(.error, eventId: "IAPSessionRefreshHandler",
                                            message: "*** Error in Login refresh and user was logged out***")
        
        let error = NSError(domain: "User Logged out", code: 10000,
                            userInfo: [NSLocalizedDescriptionKey:"Please login again to continue"])
        self.failureHandler(error)
        self.delegate?.didFailLoginRefresh(error, forOperation: self)
        self.completedExecution = true
    }
}
