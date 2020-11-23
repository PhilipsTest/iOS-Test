/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit


/**
 * Use this enum to set the Launch type of a certain View Controller, eg:- Push/Modal etc
 */

public enum ViewControllerLoadType : String {
    case Push
    case Modal
    case EmbedSubview
    case EmbedChild
    case RemoveChild
    case Root
    case Segue
}

/**
 * Use this structure to set the properties needed to Launch a View Controller
 */

struct ScreenToLoadModel {
    
    /** 
     * Holds the ViewControllerLoadType
     */
    var viewControllerLoadType : ViewControllerLoadType
    
    /**
     *Set this to tell whether the ViewController loads with animation or not
     */
    var animates : Bool
    
    /** 
     *Set this only if you are presenting the ViewController modally. This specifies the UIModalTransitionStyle
     */
    var modalTransitionStyle : UIModalTransitionStyle?
    
    /** 
     *Set this only if you are presenting the ViewController modally. This specifies the UIModalPresentationStyle
     */
    var modalPresentationStyle : UIModalPresentationStyle?
    
    /** 
     *Set this if View Controller should be loaded using Segue. This specifies the segueId to load
     */
    var segueId : String?
}
