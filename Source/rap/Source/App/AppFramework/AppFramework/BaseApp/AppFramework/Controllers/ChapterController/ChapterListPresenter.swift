/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import UAPPFramework

enum JSONParsingErrors : Error {
    case jsonSyntaxError
    
    func message() -> String {
        switch self {
        case .jsonSyntaxError:
            return "The Json structure is wrong"
        }
    }
}


class ChapterListPresenter: BasePresenter {
    
    var componentInfo : UIViewController?
    
    override func onEvent(_ componentId: String) -> UIViewController? {
        var loadVC : UIViewController?
        var nextState : BaseState?
        do {
            nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.TestDemoApps), forEventId: componentId)
            loadVC = nextState?.getViewController()
            if loadVC != nil {
                let screenToLoadModel = ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                Launcher.navigateToViewController(presenterBaseViewController, toViewController: loadVC, loadDetails: screenToLoadModel)
            }
            
        }catch {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
                let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
                Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: componentInfo)
        }
        return loadVC
    }
    
    func jsonParser(_ successBlock : () -> (), failureBlock : (JSONParsingErrors) -> () )-> [ChapterDetails]{
        var chapterDetailsArray = [ChapterDetails]()
        do{
            let jsonObject =  (Utilites.readDataFromFile(Constants.OPTION_HEADER_KEY_FROM_PLIST)) as? [[String:AnyObject]]
            for menu in jsonObject! {
                var chapterDecriptionArray = [CoCoDemoDetails]()
                
                let  menuList = menu[Constants.CHAPTERNAME_KEY] as? String
                if let menuDescription = menu[Constants.CHAPTER_COCO_DEMO_APPS_KEY] as? [[String:String]] {
                    
                    for (_, item) in menuDescription.enumerated() {
                        let cocoDemoAppName = item[Constants.COCO_DEMO_APP_NAME_KEY]
                        let cocoDemoEventID = item[Constants.COCO_DEMO_EVENT_ID_KEY]
                        let cocoDetails = CoCoDemoDetails(cocoDemoName: cocoDemoAppName, cocoDemoEventId: cocoDemoEventID)
                        chapterDecriptionArray.append(cocoDetails)
                    }
                }
                
                let chapterDetails = ChapterDetails(chapterName: menuList,
                                                    chapterCoCoDemoApps: chapterDecriptionArray,
                                                    chapterEventId: menu[Constants.COCO_DEMO_EVENT_ID_KEY] as? String)
                chapterDetailsArray.append(chapterDetails)
                
            }
            if (chapterDetailsArray.isEmpty){
                throw JSONParsingErrors.jsonSyntaxError
            }
            else{
                successBlock()
            }
            
        }
        catch {
            let error = error as? JSONParsingErrors
            failureBlock(error!)
            
        }
        return chapterDetailsArray
    }
    
    func navigateToChapterDetail(_ chapterDetailsViewController: ChapterDetailsViewController) {
        presenterBaseViewController?.navigationController?.pushViewController(chapterDetailsViewController, animated: true)
    }
}
