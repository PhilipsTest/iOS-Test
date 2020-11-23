/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import UAPPFramework
let SECTION_HEADER_HEIGHT = 72.0

/**
 ComponentVersionsViewController shows coco versions details such as versions for the COCO thats being supported by Reference App
 */
class ComponentVersionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variable Declarations
    @IBOutlet var tableView: UITableView!

    var displayedItems = [String]()
    var expandedIndexPath: IndexPath?
    var componentsMetadata = [ComponentMetadata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_COMPONENT_VERSIONS_TAG, message: Constants.LOGGING_COMPONENT_VERSIONS_MESSAGE)
        configureUI()
        
        componentsMetadata = collectComponentsMetadata()
        displayedItems = componentsMetadata.map({ data in data.formattedNameAndVersion() })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TaggingUtilities.trackPageWithInfo(page: Constants.TAGGING_COMPONENTVERSION_PAGE, params:nil)
    }

    func collectComponentsMetadata() -> [ComponentMetadata] {
        return [
            ("AppInfra", AppInfraSharedInstance.sharedInstance.getVersion(), "RA_COCO_AppInfra_desc"),
            ("InAppPurchase", getInAppPurchaseStateVersion(), "RA_COCO_IAP_desc"),
            ("ConsumerCare", getConsumerCareVersion(), "RA_COCO_CC_desc"),
            ("ProductRegistration", getProductRegistrationState(), "RA_COCO_PR_desc"),
            ("UserRegistration", getUserRegistrationState(), "RA_COCO_UR_desc")
        ].map { (name: String, version: String?, description: String) -> ComponentMetadata in
            return ComponentMetadata(name: name, version: version, description: Utilites.aFLocalizedString(description) ?? description)
        }
    }

    fileprivate func getInAppPurchaseStateVersion() -> String? {
        let state = getState(AppStates.InAppPurchase) as? InAppPurchaseState
        return state?.getVersion()
    }

    fileprivate func getConsumerCareVersion() -> String? {
        let state = getState(AppStates.ConsumerCare) as? ConsumerCareState
        return state?.getVersion()
    }

    fileprivate func getProductRegistrationState() -> String? {
        let state = getState(AppStates.ProductRegistration) as? ProductRegistrationState
        return state?.getVersion()
    }

    fileprivate func getUserRegistrationState() -> String? {
        let state = getState(AppStates.UserRegistration) as? UserRegistrationState
        return state?.getVersion()
    }

    fileprivate func getState(_ stringId: String) -> BaseState? {
        return Constants.APPDELEGATE?.getFlowManager().getState(stringId)
    }

    //MARK: UITableview Delegate Methods

    /** TableViewDelegate to set title for Header In each Section */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.COCOVERSIONS_PLIST_NAME
    }
    
    /** TableViewDelegate set number of sections in a tableview */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /** TableViewDelegate set number of rows per each section */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    /** TableViewDelegate to load cells into table view*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.COCOVERSIONS_TABLE_CELL) as? ComponentVersionsCustomTableViewCell
        cell!.componentVersionsTitleLabel?.text = displayedItems[indexPath.row]

        return cell!
    }
    
    /** TableViewDelegate */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(SECTION_HEADER_HEIGHT)
    }

    /** TableViewDelegate */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Loading custom header view for each section
        
        let cocoSectionHeaderView = SectionHeaderView()
        cocoSectionHeaderView.headerLabel.text = self.tableView.dataSource?.tableView!(self.tableView, titleForHeaderInSection: section)
        cocoSectionHeaderView.headerLabel.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        
        // Color for top Line in the header view
        cocoSectionHeaderView.topLineView.backgroundColor = UIColor.lightGray
        cocoSectionHeaderView.topLineView.alpha = 0.5
        
        // Color for bottom Line in header view
        cocoSectionHeaderView.bottomLineView.backgroundColor = UIColor.lightGray
        cocoSectionHeaderView.bottomLineView.alpha = 0.5
        
        return cocoSectionHeaderView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()

        if (expandedIndexPath != nil) {
            collapseItemAt(indexPath: expandedIndexPath!)
        }

        if (expandedItemIsSelected(indexPath)) {
            expandedIndexPath = nil
        } else {
            let offset = (expandedIndexPath != nil && indexPath.row > expandedIndexPath!.row) ? 0 : 1
            expandedIndexPath = IndexPath(row: indexPath.row + offset, section: indexPath.section)
        }

        if (expandedIndexPath != nil) {
            let description = componentsMetadata[min(componentsMetadata.count - 1, expandedIndexPath!.row - 1)].description
            expandItemAt(indexPath: expandedIndexPath!, text: description )
        }

        tableView.endUpdates()
    }

    fileprivate func expandedItemIsSelected(_ selectedIndexPath: IndexPath) -> Bool {
        return expandedIndexPath?.row == selectedIndexPath.row || expandedIndexPath?.row == selectedIndexPath.row + 1
    }

    fileprivate func collapseItemAt(indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        displayedItems.remove(at: indexPath.row)
    }

    fileprivate func expandItemAt(indexPath: IndexPath, text: String) {
        displayedItems.insert(text, at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
}

//MARK: Helper Methods
/** UI related methods for Component Version screen */
extension ComponentVersionsViewController {
    
    /** Configure UI for Component Version screen */
    func configureUI(){
        title = "App Info"

        // Set seperator line to zeroth origin for Component Version
        tableView.separatorInset = UIEdgeInsets.zero
        
        // Remove the extra rows in the Component Version tableview in the bottom
        tableView.tableFooterView = UIView()

        tableView.estimatedRowHeight = 57
        tableView.rowHeight = UITableView.automaticDimension
    }

}
