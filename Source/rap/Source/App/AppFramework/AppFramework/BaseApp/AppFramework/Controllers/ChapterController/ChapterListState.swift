/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework

class ChapterListState: BaseState {
    override init() {
        super.init(stateId: AppStates.TestDemoApps)
    }
    
    override func getViewController() -> UIViewController? {
        let referenceAppTest : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.CHAPTERLIST_STORYBOARD_NAME, bundle: nil)
        referenceAppTest = storyBoard.instantiateViewController(withIdentifier: Constants.CHAPTERLIST_VIEWCONTROLLER_STORYBOARD_ID)
        return referenceAppTest
    }
}
