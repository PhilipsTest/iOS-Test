//
//  MYASettingsVC.swift
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
import SafariServices
import PlatformInterfaces

class MYASettingsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UserDataDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIDView!
    
    private let headerHeight:CGFloat = 40.0
    var settingsItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettingsTableData()
        let headerFooterReuseIdentifier = String(describing: UIDTableViewHeaderView.self)
        tableView.register(UIDTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: headerFooterReuseIdentifier)
        loadSettingsTableData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MYAData.shared.tagging.trackPage(withInfo: MYATagging.settingsPageName, params:nil)
        loadSettingsTableData()
    }
    
    func loadSettingsTableData(){
        if let settingsMenuList = MYAData.shared.settingsMenuList{
            settingsItems = settingsMenuList
        }
        
        if !settingsItems.contains(MYA.privacyItemKey){
            settingsItems.append(MYA.privacyItemKey)
        }
        self.settingsItems = settingsItems.removeDuplicateItemsFromList()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        displayLogout(withTitle: MYALocalizable(key: "MYA_logout_title"), withMessage:  MYALocalizable(key:"MYA_logout_message"))
    }
    
    func displayLogout(withTitle title:String, withMessage message:String){
        let alertVC = UIDAlertController()
        alertVC.title = title
        alertVC.message = message
        alertVC.addAction(UIDAction(title: "     \(MYALocalizable(key: "MYA_Logout"))     ", style: .primary, handler: { (action) in
            DispatchQueue.main.async {
                MYAData.shared.tagging.trackAction(withInfo:  MYATagging.sendData, params: [  MYATagging.inAppNotificationKey:MYATagging.logoutNotificationTitle,  MYATagging.inAppNotificationResponse:"Log out"])
                MYAData.shared.delegate?.logoutClicked()
            }
        }))
        alertVC.addAction(UIDAction(title: MYALocalizable(key: "MYA_Cancel"), style: .secondary,
                                    handler: { (action) in
                                        MYAData.shared.tagging.trackAction(withInfo:  MYATagging.sendData, params: [  MYATagging.inAppNotificationKey:MYATagging.logoutNotificationTitle, MYATagging.inAppNotificationResponse:"Cancel"])
        }
        ))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - TableView Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MYASettingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! MYASettingsCell
        if(settingsItems[indexPath.row] == MYA.countryItemKey){
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        cell.titleLabel.text = MYALocalizable(key: settingsItems[indexPath.row])
        if let value = valueForSettingsItem(key:settingsItems[indexPath.row]){
            cell.valueLabel.text = value
            cell.valueLabel.isHidden = false
        }
        else{
            cell.valueLabel.isHidden = true
        }
        cell.valueLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.hyperlinkDefaultText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterReuseIdentifier = String(describing: UIDTableViewHeaderView.self)
        let reusableHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterReuseIdentifier)
        guard let header =  reusableHeader as? UIDTableViewHeaderView
            else {
                return nil
        }
        header.title = MYALocalizable(key:"MYA_Account_settings")
        return header
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionKey =   settingsItems[indexPath.row]
        
        if !handleAppSettings(actionKey) {
            if MYAData.shared.delegate?.settingsMenuItemSelected(onItem: actionKey) == true {
                MYAData.shared.logger.log(.debug, eventId: "MYASettings", message: "Action Implemented")
            } else {
                MYAData.shared.logger.log(.debug, eventId: "MYASettings", message: "No Action Implemented")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func valueForSettingsItem(key:String) -> String?{
        var value:String?
        
        if key == MYA.countryItemKey{
            value = MYAData.shared.dependency.appInfra.serviceDiscovery.getHomeCountry()
        }
        return value
    }
    
    func handleAppSettings (_ action : String) -> Bool {
        if action == MYA.countryItemKey {
            // no delegete for country tap
            return true
        } else {
            return false
        }
    }
    
    private func showErrorDialog(errorTitle: String, errorMessage: String, actionText: String) {
        DispatchQueue.main.async {
            let alert = UIDAlertController(title: errorTitle, message: errorMessage)
            let action = UIDAction(title: actionText, style: .primary, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
