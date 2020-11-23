/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 Base class for condition checks
 */
@objcMembers open class BaseCondition: NSObject {
    
    /**
     * Variable to hold the condition Id of the Condition
     * - Since 1.1.0
     */
    public var conditionId: String!
    
    /**
     * Initialization method to initialise a Condition
     * - Parameter conditionId: The condition Id of the new condition
     * - Since 1.1.0
     */
    
   public init(conditionId: String) {
        self.conditionId = conditionId
        super.init()
    }
    
   public override init() {
        super.init()
    }
    
    /**
    * isSatisfied is a method to be implemented in classes that inherits BaseCondition class to check the condition the app is at
    * - Returns: Bool variable, true/false based on the condition is satisfied or not
    * - Since 1.1.0
     */
   open func isSatisfied() -> Bool {
        assert(false,"isSatisfied method should be overriden in BaseCondition child class")
        return false
    }
}

/** 
 * Defines the logic for ==
 * - Returns: Bool value if the BaseCondition Ids are equal or not
 * - Since 1.1.0
 */
public func ==(lhs: BaseCondition, rhs: BaseCondition) -> Bool {
    return lhs.conditionId == rhs.conditionId
}
