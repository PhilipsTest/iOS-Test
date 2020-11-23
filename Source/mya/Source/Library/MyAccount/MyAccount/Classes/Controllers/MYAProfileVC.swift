//
//  MYAProfileVC.swift
//  MyAccount
//
//  Created by Hashim MH on 09/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//
import UIKit
import PhilipsUIKitDLS
import PlatformInterfaces

class MYAProfileVC: UIViewController , UITableViewDataSource,UITableViewDelegate {
    
    weak var tableHeightConstraint: NSLayoutConstraint!
    private let headerHeight:CGFloat = 40.0
    private let cellHeight:CGFloat = 48.0
    var profileItems = [String]()
    var userInformation : Dictionary<String, AnyObject>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionIndexBackgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.gridViewPrimaryHeaderBackground
        let headerFooterReuseIdentifier = String(describing: UIDTableViewHeaderView.self)
        tableView.register(UIDTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: headerFooterReuseIdentifier)
        loadProfileTableData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MYAData.shared.tagging.trackPage(withInfo: MYATagging.profilePageName, params:nil)
        loadProfileTableData()
    }

    func loadProfileTableData(){
        if let profileMenuList = MYAData.shared.profileMenuList{
                profileItems = profileMenuList
        }

        if !profileItems.contains(MYA.myDetailsKey){
            profileItems.append(MYA.myDetailsKey)
        }
       self.profileItems = profileItems.removeDuplicateItemsFromList()
    }
    
    // MARK: - TableView Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return profileItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MYAProfileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! MYAProfileCell
        cell.titleLabel.text = MYALocalizable(key: profileItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterReuseIdentifier = String(describing: UIDTableViewHeaderView.self)
        let reusableHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterReuseIdentifier)
        guard let header =  reusableHeader as? UIDTableViewHeaderView
            else {
                return nil
        }
        do {
            userInformation = try MYAData.shared.userProvider?.userDetails([UserDetailConstants.GIVEN_NAME,UserDetailConstants.FAMILY_NAME])
        } catch {
            MYAData.shared.logger.log(.error, eventId:"MYAProfileVC" , message: error.localizedDescription)
        }
        if let userName = userInformation?[UserDetailConstants.GIVEN_NAME] as? String {
            if let lastName = userInformation?[UserDetailConstants.FAMILY_NAME] as? String {
                header.title = "\(userName) \(lastName)"
                return header
            }
            header.title = userName
            MYAData.shared.logger.log(.debug, eventId: "MYAProfile", message: "No Family Name")
            return header
        }
        return header
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionKey =   profileItems[indexPath.row]
        
        if !handleAppProfile(actionKey) {
            if let handled = MYAData.shared.delegate?.profileMenuItemSelected(onItem: actionKey), handled {
                MYAData.shared.logger.log(.debug, eventId: "MYAProfile", message: "Action implemented")
            } else {
                MYAData.shared.logger.log(.debug, eventId: "MYAProfile", message: "No action implemented")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func handleAppProfile (_ action : String) -> Bool {
      return false 
    }
}
