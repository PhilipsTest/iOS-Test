/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol IAPOauthRefreshProtocol : class {
    func cancelAllOperationsInOperationQueue(_ inOperation:Operation)
    func didCompleteOAuthRefresh(_ withOauth: IAPOAuthInfo, forOperation: Operation)
    func didFailOAuthRefresh(_ withError: NSError, forOperation: Operation)
}

class IAPOAuthInvalidTokenHandler: IAPOauthRefreshProtocol {
    static let sharedInstance: IAPOAuthInvalidTokenHandler = IAPOAuthInvalidTokenHandler()
    fileprivate var isAlreadyUnderRefresh = false
    fileprivate var isLoginRefreshInProgress = false
    
    fileprivate lazy var downloadsInProgress = [Operation]()
    lazy var refreshQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Refresh OAuth queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    fileprivate lazy var loginRefreshInProgress = [Operation]()
    lazy var loginRefreshQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Refresh Login queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    func scheduleOAuthRefresh(_ usingManager: IAPOAuthDownloadManager,
                              withCompletion: @escaping (IAPOAuthInfo)->(),
                              withFailureHandler: @escaping (NSError)->()) {
        let operation = IAPRefreshOAuthOperation(downloadManager: usingManager, withDelegate: self)
        operation.completionHandler = withCompletion
        operation.failureHandler = withFailureHandler
        
        self.downloadsInProgress.append(operation)
        guard self.isAlreadyUnderRefresh == false else { return }
        self.refreshQueue.addOperation(operation)
    }
    
    /**
     Method to invoke the completion or failure handler of operations held in the local array and also resetting the flag
     */
    func resetRefeshing(_ withError: NSError?) {
        guard self.isAlreadyUnderRefresh == true else { return }
        self.isAlreadyUnderRefresh = false
        
        if let error = withError {
            self.fireAllFailureClosures(error)
        }
        else {
            self.fireAllSuccessClosures()
        }
    }
    
    // MARK: Delegate methods of operation completion
    func cancelAllOperationsInOperationQueue(_ inOperation: Operation) {
        self.isAlreadyUnderRefresh = true
        for operation in self.refreshQueue.operations {
            if operation != inOperation {
                operation.cancel()
            }
        }
    }
    
    /**
     Method invokes the completion handler of the completed operation only
     */
    func didCompleteOAuthRefresh(_ withOauth: IAPOAuthInfo, forOperation: Operation) {
        if let castedOperation = forOperation as? IAPRefreshOAuthOperation {
            castedOperation.completionHandler(IAPConfiguration.sharedInstance.oauthInfo!)
        }
        
        if let indexOfOperation = self.downloadsInProgress.firstIndex(of: forOperation) {
            self.downloadsInProgress.remove(at: indexOfOperation)
        }
    }
    
    /**
     Method invokes the Failure handler of the completed operation only
     */
    func didFailOAuthRefresh(_ withError: NSError, forOperation: Operation) {
        if let castedOperation = forOperation as? IAPRefreshOAuthOperation {
            castedOperation.failureHandler(withError)
        }
        
        if let indexOfOperation = self.downloadsInProgress.firstIndex(of: forOperation) {
            self.downloadsInProgress.remove(at: indexOfOperation)
        }
    }
    
    
    // MARK: Methods to invoke all the completion and failure handlers of operations that weren't added to operation queue
    fileprivate func fireAllSuccessClosures() {
        for operation in self.downloadsInProgress {
            if let castedOperation = operation as? IAPRefreshOAuthOperation {
                castedOperation.completionHandler(IAPConfiguration.sharedInstance.oauthInfo!)
            }
        }
        self.downloadsInProgress.removeAll()
    }
    
    fileprivate func fireAllFailureClosures(_ withError: NSError){
        for operation in self.downloadsInProgress {
            if let castedOperation = operation as? IAPRefreshOAuthOperation {
                castedOperation.failureHandler(withError)
            }
        }
        self.downloadsInProgress.removeAll()
    }
}


protocol IAPLoginRefreshProtocol : class {
    func cancelAllLoginOperationsInOperationQueue(_ inOperation:Operation)
    func didCompleteLoginRefresh(_ forOperation: Operation)
    func didFailLoginRefresh(_ withError: NSError, forOperation: Operation)
}

extension IAPOAuthInvalidTokenHandler: IAPLoginRefreshProtocol {
    
    func scheduleLoginRefresh(_ withCompletion: @escaping ()->(), withFailureHandler: @escaping (NSError)->()) {
        let operation = IAPLoginRefreshOperation(withDelegate: self,
                                                 withCompletion: withCompletion,
                                                 withFailureHandler: withFailureHandler)
        
        self.loginRefreshInProgress.append(operation)
        guard self.isLoginRefreshInProgress == false else { return }
        self.loginRefreshQueue.addOperation(operation)
    }
    
    // MARK: Delegate methods of Login refresh operation
    func cancelAllLoginOperationsInOperationQueue(_ inOperation: Operation) {
        self.isLoginRefreshInProgress = true
        for operation in self.loginRefreshQueue.operations {
            if operation != inOperation {
                operation.cancel()
            }
        }
    }
    
    /**
     Method invokes the completion handler of the completed operation only
     */
    func didCompleteLoginRefresh(_ forOperation: Operation) {
        if let castedOperation = forOperation as? IAPLoginRefreshOperation {
            castedOperation.completionHandler()
        }
        
        if let indexOfOperation = self.loginRefreshInProgress.firstIndex(of: forOperation) {
            self.loginRefreshInProgress.remove(at: indexOfOperation)
        }
    }
    
    /**
     Method invokes the Failure handler of the completed operation only
     */
    func didFailLoginRefresh(_ withError: NSError, forOperation: Operation) {
        if let castedOperation = forOperation as? IAPLoginRefreshOperation {
            castedOperation.failureHandler(withError)
        }
        
        if let indexOfOperation = self.loginRefreshInProgress.firstIndex(of: forOperation) {
            self.loginRefreshInProgress.remove(at: indexOfOperation)
        }
    }
    
    // MARK: Methods to invoke all the completion and failure handlers of operations that weren't added to operation queue
    fileprivate func fireAllLoginSuccessClosures() {
        for operation in self.loginRefreshInProgress {
            if let castedOperation = operation as? IAPLoginRefreshOperation {
                castedOperation.completionHandler()
            }
        }
        self.loginRefreshInProgress.removeAll()
    }
    
    fileprivate func fireAllLoginFailureClosures(_ withError: NSError){
        for operation in self.loginRefreshInProgress {
            if let castedOperation = operation as? IAPLoginRefreshOperation {
                castedOperation.failureHandler(withError)
            }
        }
        self.loginRefreshInProgress.removeAll()
    }
    
    /**
     Method to invoke the completion or failure handler of operations held in the local array and also resetting the flag
     */
    func resetLoginRefreshing(_ withError: NSError?) {
        guard self.isLoginRefreshInProgress == true else { return }
        self.isLoginRefreshInProgress = false
        
        if let error = withError {
            self.fireAllLoginFailureClosures(error)
        }
        else {
            self.fireAllLoginSuccessClosures()
        }
    }
}
