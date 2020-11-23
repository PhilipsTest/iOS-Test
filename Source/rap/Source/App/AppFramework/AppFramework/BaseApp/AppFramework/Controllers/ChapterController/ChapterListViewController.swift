/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS


struct CoCoDemoDetails {
    var cocoDemoName : String?
    var cocoDemoEventId : String?
}

struct ChapterDetails {
    var chapterName : String?
    var chapterCoCoDemoApps : [CoCoDemoDetails]?
    var chapterEventId: String?
}

class ChapterListViewController: UIDTableViewController {
    
    @IBOutlet weak var chapterTableView: UITableView!
    var chapterDetailsArray = [ChapterDetails]()
    var presenter : ChapterListPresenter?

    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = Constants.TEST_DEMOAPP_SCREEN_TITLE
        
        tableView.register(UIDTableViewCell.self, forCellReuseIdentifier: Constants.CHAPTER_TABLE_CELL_IDENTIFIER)
        
        presenter = ChapterListPresenter(_viewController: self)
        
        Utilites.showActivityIndicator(using: self)

        let backgroundQueue = DispatchQueue(label: "Concurrent_Queue", attributes: DispatchQueue.Attributes.concurrent)
        backgroundQueue.async(execute: {

            self.chapterDetailsArray  = (self.presenter?.jsonParser({
                },
                failureBlock: { (error) in
                    Utilites.removeActivityIndicator(onCompletionExecute: nil)
                    let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
                    Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: "JSON is incorrect", buttonAction: [alertAction], usingController: self)
            }))!
            
            DispatchQueue.main.async(execute: { () -> Void in
                Utilites.removeActivityIndicator(onCompletionExecute: nil)
                self.tableView.reloadData()
            })
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return chapterDetailsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CHAPTER_TABLE_CELL_IDENTIFIER) ??
                   UITableViewCell(style: .default, reuseIdentifier: Constants.CHAPTER_TABLE_CELL_IDENTIFIER)
        cell.textLabel?.text = chapterDetailsArray[(indexPath as NSIndexPath).row].chapterName
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let eventId = chapterDetailsArray[indexPath.row].chapterEventId {
            navigateToNextStateForEventId(eventId)
        } else {
            let storyboard : UIStoryboard = UIStoryboard(name: Constants.CHAPTERLIST_STORYBOARD_NAME, bundle: nil)
            let chapterDetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.CHAPTER_DETAILS_STORYBOARD_ID) as! ChapterDetailsViewController
            chapterDetailsViewController.chapterDetailsArray = chapterDetailsArray[(indexPath as NSIndexPath).row].chapterCoCoDemoApps!
            chapterDetailsViewController.titleForView = chapterDetailsArray[(indexPath as NSIndexPath).row].chapterName!
            presenter?.navigateToChapterDetail(chapterDetailsViewController)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return Constants.SECTION_HEADER_CHAPTER_LIST
    }

    func navigateToNextStateForEventId(_ eventId: String) {
        _ = presenter?.onEvent(eventId)
    }
    
}
