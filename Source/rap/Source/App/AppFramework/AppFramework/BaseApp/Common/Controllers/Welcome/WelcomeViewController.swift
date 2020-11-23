/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

/**
 WelcomeViewController is the class which Embeds Page View Controller for navigating Welcome screens.
 It Can have multiple child view controllers.
 */
class WelcomeViewController: PagedViewViewController {
    
    override var plistOptionsKey: String? { return Constants.WELCOME_SCREEN_KEY }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.navigationPrimaryBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TaggingUtilities.trackPageWithInfo(page: Constants.TAGGING_WELCOME_PAGE, params:nil)
    }
    
    override func createChildViewController(_ viewOptions: [String : AnyObject]) -> UIViewController {
        let storyBoard = UIStoryboard(name: Constants.WELCOME_STORYBOARD_NAME, bundle: nil)
        let hasVideo = viewOptions[Constants.WELCOME_VIDEO_ID_KEY] != nil &&
                       !(viewOptions[Constants.WELCOME_VIDEO_ID_KEY]! as! String).isEmpty
        
        let storyBoardId = hasVideo ? Constants.WELCOME_VIDEO_CHILD_STORYBOARD_ID : Constants.WELCOME_CHILD_STORYBOARD_ID
        let childViewController = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! WelcomeChildViewController
        childViewController.screenDict = viewOptions
        
        return childViewController
    }
    
}
