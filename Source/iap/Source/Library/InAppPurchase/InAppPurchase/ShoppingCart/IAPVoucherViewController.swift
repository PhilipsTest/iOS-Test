///* Copyright (c) Koninklijke Philips N.V., 2018
// * All rights are reserved. Reproduction or dissemination
// * in whole or in part is prohibited without the prior written
// * consent of the copyright holder.
// */

import UIKit
import PhilipsUIKitDLS

class IAPVoucherViewController: IAPBaseViewController {
    
    @IBOutlet weak var voucherHeadingLbl: UIDLabel?
    @IBOutlet weak var voucherTextField: UIDTextField?
    @IBOutlet weak var voucherApplyBtn: UIDButton?
    @IBOutlet weak var voucherListTable: UITableView?
    
    fileprivate var voucherList = [IAPVoucher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewSetUp()
    }
    
    fileprivate func initializeViewSetUp() {
        // localization changes are pending
        navigationItem.title = IAPLocalizedString("iap_apply_gift")
        voucherHeadingLbl?.text(IAPLocalizedString("iap_enter_gift_code") ?? "", lineSpacing: 5)
        voucherApplyBtn?.isEnabled = false
        showVoucherList(isHidden: true)
        listAppliedVouchers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kVoucherPageName)
    }
    
    @IBAction func applyButtonClicked(sender: AnyObject) {
        voucherTextField?.resignFirstResponder()
        if let voucherText = voucherTextField?.text, voucherText.count > 0 {
            startActivityProgressIndicator()
            applyVoucher(voucherCode: voucherText)
        }
    }
}

extension IAPVoucherViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let textTotalVal = (text as NSString).replacingCharacters(in: range, with: string)
        if textTotalVal.length > 0 {
            self.voucherApplyBtn?.isEnabled = true
        } else {
            self.voucherApplyBtn?.isEnabled = false
        }
        return true
    }
}

extension IAPVoucherViewController: IAPRemoveVoucherDelegate {
    func applyVoucher(voucherCode: String) {
        startActivityProgressIndicator()
        let cartHelper = IAPCartSyncHelper()
        cartHelper.applyVoucher(voucherID: voucherCode, success: {[weak self] (inSuccess:Bool) in
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
            let uidOkAction = UIDAction(title: IAPLocalizedString("iap_ok"),
                                        style: .primary, handler: { _ in
                                            weakSelf.listAppliedVouchers()
            })
            weakSelf.displayDLSAlert(IAPLocalizedString("iap_voucher_applied_success"),
                                     withMessage: "",
                                     firstButton: uidOkAction, secondButton: nil, usingController: self, viewTag: 002)
        }) { [weak self](inError:NSError) in
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
            let okAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary)
            weakSelf.displayDLSAlert(IAPLocalizedString("iap_voucher_applied_unsuccess"),
                                     withMessage: inError.localizedDescription,
                                     firstButton: okAction, secondButton: nil,
                                     usingController: self, viewTag: 2)
        }
        self.voucherTextField?.text = ""
        self.voucherApplyBtn?.isEnabled = false
    }
    
    func listAppliedVouchers() {
        startActivityProgressIndicator()
        let cartHelper = IAPCartSyncHelper()
        cartHelper.getAppliedVoucherList({[weak self] (voucherListData:IAPVoucherList) -> () in
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
            weakSelf.loadAppliedVoucherList(voucherListInfo: voucherListData)
        }) {[weak self] _ -> () in
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
        }
    }
    
    func loadAppliedVoucherList(voucherListInfo: IAPVoucherList){
        self.voucherList = voucherListInfo.voucherList
        if self.voucherList.count > 0 {
            showVoucherList(isHidden: false)
            self.voucherListTable?.reloadData()
            self.voucherListTable?.backgroundColor = (UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground)!
        } else {
            showVoucherList(isHidden: true)
        }
    }
    
    //MARK: IAPRemoveVoucherDelegate
    func removeSelectedVoucher(cell:IAPVoucherListCell){
        if let indexPath = self.voucherListTable?.indexPath(for: cell) {
            let voucherModel = self.voucherList[indexPath.row]
            if let voucherID = voucherModel.voucherCode{
                removeVoucher(voucherCode: voucherID)
            }
        }
    }
    
    func removeVoucher(voucherCode: String) {
        startActivityProgressIndicator()
        let cartHelper = IAPCartSyncHelper()
        cartHelper.removeVoucher(voucherID: voucherCode, success: { (inSuccess:Bool) in
            self.listAppliedVouchers()
        }) { (inError:NSError) in
            self.stopActivityProgressIndicator()
            self.displayDLSAlert(IAPLocalizedString("iap_voucher_applied_unsuccess"),
                                 withMessage: inError.localizedDescription,
                                 firstButton: UIDAction(title: IAPLocalizedString("iap_ok"),
                                                        style: UIDActionStyle.primary),
                                 secondButton: nil, usingController: self, viewTag: 2)
        }
    }

    func showVoucherList(isHidden: Bool) {
        voucherListTable?.isHidden = isHidden
    }
}

extension IAPVoucherViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDelegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = IAPUtility.getBundle().loadNibNamed(IAPNibName.IAPPurchaseHistoryOverviewSectionHeader,
                                                             owner: self, options: nil)![0]
        if let headerView = headerView as? IAPPurchaseHistoryOverviewSectionHeader {
            headerView.dateLabel.text = IAPLocalizedString("iap_accepted_codes")
            headerView.sectionHeaderView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  indexPath.row != voucherList.count else { return UITableViewCell(frame: .zero) }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.voucherList, for: indexPath) as? IAPVoucherListCell else{
                return UITableViewCell(frame: .zero)
        }
        cell.delegate = self
        cell.removeVoucher.contentEdgeInsets = .zero
        cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        let voucherObj = voucherList[indexPath.row]
        cell.discountTitleLabel.text = IAPLocalizedString("iap_voucher_code")
        if let code = voucherObj.voucherCode {
            cell.percentageLabel.text = code
        }
        if let amount = voucherObj.discountAmount {
            cell.amountLabel.text = "- " + "\(amount)"
        }
        return cell
    }
}
