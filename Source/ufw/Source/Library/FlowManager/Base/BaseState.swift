/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

/**
 * StateCommunicationListener is a protocol which bridges a Communication from and to a State
 */

@objc public protocol StateCommunicationListener : NSObjectProtocol {
    
    /**
     * Implement this method to create a bridge from and to a State
     
     * - Parameter state : State which wants to Communicate with/from any outside resource
     * - Returns : An Object which can hold any value or can be nil
     * - Since 1.1.0
     */
    
    func communicateFromState(_ state : BaseState?) -> AnyObject?
}

/** 
 * BaseState is the base State class from which all State classes will be derived
 */
@objc open class BaseState : NSObject {
    
    //MARK: Variable declarations
    
    /**
     * State Id of the State Object
     * - Since 1.1.0
     */
    @objc public var stateId : String!
    private(set) public var stateCompletionHandler : StateCommunicationListener?
    
    
    //MARK: Default methods
    
    /**
     * State Initialiser
     
     * - Parameter stateId : State Id of the new State object
     * - Since 1.1.0
     */
  @objc public init(stateId : String?) {
        self.stateId = stateId
        super.init()
    }
    
   @objc public override init() {
        super.init()
    }
    
    /**
     * Method getViewController is to be implemented by all state classes which gives the next ViewController
     
     * - Returns: Viewcontroller that is to be navigated
     * - Since 1.1.0
     */
    @objc open func getViewController() -> UIViewController? {
        assert(false,"getViewController method should be overriden in BaseState child class")
        return nil
    }
    
    /**
     * This method sets the delegate for StateCommunicationListener protocol
     
     * - Parameter handler : The object which conformed to StateCommunicationListener protocol
     * - Since 1.1.0
     */
    
    @objc public func setStateCompletionDelegate (_ handler : StateCommunicationListener?) {
        stateCompletionHandler = handler
    }
    
    /**
     * Method updateDataModel is implemented to pass data to any Common components like InAppPurchase, UserRegistration, ConsumerCare, ProductRegistration...
     - Since 1.1.0
     */
    @objc open func updateDataModel() {}
}
