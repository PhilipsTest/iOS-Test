 /* Copyright (c) Koninklijke Philips N.V., 2016
  * All rights are reserved. Reproduction or dissemination
  * in whole or in part is prohibited without the prior written
  * consent of the copyright holder.
  */
 import AppInfra
 import PhilipsUIKitDLS
 import PhilipsIconFontDLS
 import SafariServices
 
 class IAPPurchaseHistoryNewDetailViewController: IAPBaseViewController {
    @IBOutlet weak var orderDetailTableView: UITableView!
    var orderDetail: IAPPurchaseHistoryModel!
    fileprivate let purchaseHistoryDataSource = IAPPurchaseHistoryDataSource()
    fileprivate var preivousOrdersDataArray = [IAPPurchaseHistoryModel]()
    var filteredOrderCollection = [IAPPurcahseHistorySortedCollection]()
    var consumerCareInfo: IAPPRXConsumerModel!
    var consumerCareInterface: IAPPRXConsumerInterface!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
        trackAction(parameterData: ["purchaseID": self.orderDetail.getOrderID()], action: IAPAnalyticsConstants.sendData)
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kOrderDetailPageName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = IAPLocalizedString("iap_order_details")
        self.registerNibForTableView()
        self.orderDetailTableView.estimatedRowHeight = 150
        self.orderDetailTableView.rowHeight = UITableView.automaticDimension
    }
    
    func updateCellNumbersToRemoveTrackCell() {
        IAPConstants.IAPPurchaseHistoryCellNumber.kShippingAddCellNumber = 3
        IAPConstants.IAPPurchaseHistoryCellNumber.kBillingAddCellNumber = 4
        IAPConstants.IAPPurchaseHistoryCellNumber.kPaidByCellNumber = 5
        IAPConstants.IAPPurchaseHistoryCellNumber.kTotalAccessoryCellNumber = 6
    }
    
    // MARK: -
    // MARK: Private Methods
    fileprivate func registerNibForTableView() {
        self.orderDetailTableView.register(UINib(nibName: IAPNibName.IAPPurchaseHistoryOrderCellTableViewCell,
                                                 bundle: IAPUtility.getBundle()),
                                           forCellReuseIdentifier: IAPCellIdentifier.orderNumberCell)
        self.orderDetailTableView.register(UINib(nibName: IAPNibName.IAPPurchaseHistoryProductCell,
                                                 bundle: IAPUtility.getBundle()),
                                           forCellReuseIdentifier: IAPCellIdentifier.orderProductCell)
        
        self.orderDetailTableView.register(UINib(nibName: IAPNibName.IAPSummaryAddressCell,
                                                 bundle: IAPUtility.getBundle()),
                                           forCellReuseIdentifier: IAPCellIdentifier.addressCell)
        //New DLS changes for the Details Screen..
        self.orderDetailTableView.register(UINib(nibName: IAPNibName.IAPPurchaseHistoryDetailCustomerCareCell,
                                                 bundle: IAPUtility.getBundle()),
                                           forCellReuseIdentifier: IAPCellIdentifier.historyCustomerCareCell)
        
        self.orderDetailTableView.register(UINib(nibName: IAPNibName.IAPSummaryPaidCell,
                                                 bundle: IAPUtility.getBundle()),
                                           forCellReuseIdentifier: IAPCellIdentifier.summaryPaidCell)
        
        self.orderDetailTableView.register(UINib(nibName: IAPNibName.IAPPurchaseHistoryOrderDetailsPriceSummaryCell,
                                                 bundle: IAPUtility.getBundle()),
                                           forCellReuseIdentifier: IAPCellIdentifier.purchaseHistoryPriceCell)
        
        self.orderDetailTableView.register(UINib(nibName: IAPNibName.IPAPurchaseHistoryOrderSummaryCustomCell,
                                                 bundle: IAPUtility.getBundle()),
                                           forCellReuseIdentifier: IAPCellIdentifier.summaryCustomCell)
    }
    
    fileprivate func displayConsumerCareView() {
        guard self.consumerCareInfo.getPhoneNumber() != "" else {
            let uidOkAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary, handler: { (uidAction) in
                self.uidAlertController?.dismiss(animated: true, completion: nil)
            })
            
            super.displayDLSAlert(IAPLocalizedString("iap_server_error"),
                                  withMessage: IAPLocalizedString("iap_something_went_wrong"),
                                  firstButton: uidOkAction,
                                  secondButton: nil, usingController: self,
                                  viewTag: IAPConstants.IAPAlertViewTags.kApologyAlertViewTag)
            return
        }
        
        let cancelOrderVC = IAPCancelOrderViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        cancelOrderVC.orderNumber = self.orderDetail.getOrderID()
        cancelOrderVC.consumerModel = self.consumerCareInfo
        cancelOrderVC.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(cancelOrderVC, animated: true)
    }
 }
 
 extension IAPPurchaseHistoryNewDetailViewController: IAPPriceSummaryCellProtocol {
    func userSelectedcancelButton(_ inSender:IAPPurchaseHistoryOrderDetailsPriceSummaryCell) {
        displayConsumerCareView()
    }
 }
 
 // MARK: -
 // MARK: UITableView Datasource
 
 extension IAPPurchaseHistoryNewDetailViewController: UITableViewDataSource {
    
    fileprivate func getCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kPurchaseHistoryConsumerSection {
            if indexPath.row == IAPConstants.IAPPurchaseHistoryOrderDetailsRow.kPurchaseHistoryOrderStatusRow,
                let localCell = self.orderDetailTableView.dequeueReusableCell(
                    withIdentifier: IAPCellIdentifier.orderNumberCell) as? IAPPurchaseHistoryOrderCellTableViewCell {
                
                localCell.orderStateLabel?.text = IAPLocalizedString("iap_order_state",self.orderDetail.getOrderDisplayStatus())
                localCell.orderNumberTextLabel.text = (IAPLocalizedString("iap_order_number") ?? "") +
                    String(format: "\(self.orderDetail.getOrderID())")
                localCell.statusImage.textColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryFocusBackground
                localCell.statusImage.font = UIFont.iconFont(size: 22.0)
                localCell.statusImage.text = PhilipsDLSIcon.unicode(iconType: .infoCircle)
                return localCell
            } else if indexPath.row == IAPConstants.IAPPurchaseHistoryOrderDetailsRow.kPurchaseHistoryOrderSummaryRow,
                let localCell = self.orderDetailTableView.dequeueReusableCell(
                    withIdentifier: IAPCellIdentifier.historyCustomerCareCell) as? IAPPurchaseHistoryDetailCustomerCareCell {
                localCell.updateConsumerCareDetail(consumerCareInfo: consumerCareInfo)
                if self.orderDetail.getOrderDisplayStatus() == "completed" {
                    localCell.consumerCareContactDetailsLabel?.text = IAPLocalizedString("iap_order_completed_text_default")
                } else {
                    let consumerCareContactDetailText = IAPLocalizedString("iap_contact_philips_consumer_care", consumerCareInfo.getPhoneNumber())!
                    localCell.consumerCareContactDetailsLabel?.text(consumerCareContactDetailText, lineSpacing: 5)
                }
                localCell.callUsButton?.isHidden = false
                return localCell
            } else {
                return UITableViewCell(frame: .zero)
            }
        } else if indexPath.section == IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kProductsSection {
            if indexPath.row <= self.orderDetail.products.count, let localCell = self.orderDetailTableView.dequeueReusableCell(
                withIdentifier: IAPCellIdentifier.orderProductCell) as? IAPPurchaseHistoryProductCell {
                let productModel: IAPProductModel = self.orderDetail.products[indexPath.row]
                localCell.productNameLabel.text = productModel.getProductTitle()
                localCell.orderTrackDelegate = self
                localCell.productQuantityLabel?.text = IAPLocalizedString("iap_quantity", String(productModel.getQuantity()))
                if productModel.getProductThumbnailImageURL() != "" {
                    localCell.productImageView.setImageWith(URL(string: (productModel.getProductThumbnailImageURL()))!)
                }
                localCell.orderTrackingURL = productModel.getTrackingURL()
                localCell.trackOrderButton.isEnabled = (productModel.getTrackingURL() != nil) ? true : false
                guard productModel.getTotalPrice() == "" else {
                    localCell.productPriceLabel!.text = productModel.getTotalPrice()
                    return localCell
                }
                return localCell
            } else {
                return UITableViewCell(frame: .zero)
            }
        } else if indexPath.section == IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kYourDetailsSection {
            if indexPath.row == IAPConstants.IAPPurchaseHistoryOrderAddressRow.kPurchaseHistoryOrderShippingRow,
                let localCell = self.orderDetailTableView.dequeueReusableCell(
                    withIdentifier: IAPCellIdentifier.addressCell) as? IAPSummaryAddressCell {
                localCell.headerLabel?.text = IAPLocalizedString("iap_shipping_address")
                localCell.addressLabel?.attributedText = self.orderDetail.getDeliveryAddress()?.getDisplayTextForAddress(false)
                localCell.addressSeparatorView.isHidden = true
                return localCell
            } else if indexPath.row == IAPConstants.IAPPurchaseHistoryOrderAddressRow.kPurchaseHistoryOrderBillingRow,
                let localCell = self.orderDetailTableView.dequeueReusableCell(
                    withIdentifier: IAPCellIdentifier.addressCell) as? IAPSummaryAddressCell {
                localCell.topConstarint.constant = 0
                localCell.headerLabel?.text = IAPLocalizedString("iap_billing_address")
                localCell.addressLabel?.attributedText = self.orderDetail.getBillingAddress()?.getDisplayTextForAddress(false)
                return localCell
            } else if indexPath.row == IAPConstants.IAPPurchaseHistoryOrderAddressRow.kPurchaseHistoryOrderPaymentRow,
                let localCell = self.orderDetailTableView.dequeueReusableCell(
                    withIdentifier: IAPCellIdentifier.summaryPaidCell) as? IAPSummaryPaidCell {
                if let billingAddress = self.orderDetail.getBillingAddress() {
                    let paymentName = billingAddress.firstName + " " + billingAddress.lastName
                    localCell.paymentLabel?.text = IAPLocalizedString("iap_payment_method")
                    localCell.paidByLabel?.text = self.orderDetail.getCardType() + "\n\n" +
                        paymentName + "\n\n" +  self.orderDetail.getCardNumber()
                }
                return localCell
            } else {
                return UITableViewCell(frame: .zero)
            }
        } else if indexPath.section == IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kSummarySection {
            if let localCell = self.orderDetailTableView.dequeueReusableCell(
                withIdentifier: IAPCellIdentifier.summaryCustomCell) as? IPAPurchaseHistoryOrderSummaryCustomCell {
                let productModel: IAPProductModel = self.orderDetail.products[indexPath.row]
                if indexPath.row == IAPConstants.IAPPurchaseHistoryOrderSummaryPriceRow.kPurchaseHistorySummaryFirstRow {
                    localCell.topConstraint.constant = 16
                } else {
                    localCell.topConstraint.constant = 4
                }
                localCell.totalItemsAndItemNameLabel?.text = String(format: "\(productModel.getQuantity())") +
                    "x " + productModel.getProductTitle()
                localCell.totalPriceLabel?.text = productModel.getTotalPrice()
                return localCell
            } else {
                return UITableViewCell(frame: .zero)
            }
        } else if let localCell = self.orderDetailTableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.purchaseHistoryPriceCell) as? IAPPurchaseHistoryOrderDetailsPriceSummaryCell {
            localCell.priceSummaryCellDelegate = self
            localCell.deliveryParcelTextLabel?.text = IAPLocalizedString("iap_delevery_via", orderDetail.getDeliveryCostName())
            localCell.deliveryParcelValueLabel?.text = orderDetail.getDeliveryCost()
            localCell.totalTextLabel?.text = IAPLocalizedString("iap_total")
            localCell.totalValueLabel?.text = orderDetail.getOrderPriceValue()
            localCell.vatTextLabel?.text = IAPLocalizedString("iap_including_tax")
            localCell.vatValueLabel?.text = orderDetail.getTotalTax()
            localCell.cancelMyOrderButton?.setTitle(IAPLocalizedString("iap_cancel_order"),
                                                    for: .normal)
            localCell.cancelMyOrderButton?.isHidden = false
            return localCell
        }
        
        return self.orderDetailTableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.trackOrderCell)
            as? IAPTrackOrderCell ?? UITableViewCell(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.updateCellNumbersToRemoveTrackCell()
        switch section {
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kPurchaseHistoryConsumerSection:
            return 2
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kProductsSection:
            return self.orderDetail.products.count
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kYourDetailsSection:
            return 3
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kSummarySection:
            return self.orderDetail.products.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellForIndexPath(indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kTotalSection + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kTotalSection) {
            return 0
        }
        return IAPConstants.IAPPaymentSelectionDecoratorConstants.kHeaderHeightConstant
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = IAPUtility.getBundle().loadNibNamed(IAPNibName.IAPPurchaseHistoryOverviewSectionHeader,
                                                             owner: self, options: nil)![0] as? IAPPurchaseHistoryOverviewSectionHeader
        headerView?.sectionHeaderView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        switch section {
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kPurchaseHistoryConsumerSection:
            headerView?.dateLabel.text = self.orderDetail.orderDisplayDate
            return headerView
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kProductsSection:
            if self.orderDetail.getItemsCount() > 1 {
                headerView?.dateLabel.text = String(format: "\(self.orderDetail.getItemsCount())") + " " + IAPLocalizedString("iap_product_catalog")!
            } else {
                headerView?.dateLabel.text = IAPLocalizedString("iap_number_of_product", String(self.orderDetail.getItemsCount()))
            }
            return headerView
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kYourDetailsSection:
            headerView?.dateLabel.text = IAPLocalizedString("iap_your_details")
            return headerView
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kSummarySection:
            headerView?.dateLabel.text = IAPLocalizedString("iap_order_summary")
            return headerView
        case IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kTotalSection:
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            myView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
            return myView
        default:
            return headerView
        }
    }
 }
 
 // MARK: -
 // MARK: UITableView Delegate
 extension IAPPurchaseHistoryNewDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 2 && indexPath.row == 2 && self.orderDetail.getCardNumber() == "" else {
            return UITableView.automaticDimension
        }
        return 0
    }
 }
 extension IAPPurchaseHistoryNewDetailViewController: IAPOrderTrackingProtocol {
    func didSelectTrackOrder(trackingURL: String) {
        guard let url = URL(string: trackingURL) else {
            return
        }
        let vc = SFSafariViewController(url:url)
        present(vc, animated: true)
    }
 }
