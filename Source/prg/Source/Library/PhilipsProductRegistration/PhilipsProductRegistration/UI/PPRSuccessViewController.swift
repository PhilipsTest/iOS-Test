//
//  PPRSuccessViewController.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsUIKitDLS
import PhilipsPRXClient

class PPRSuccessViewController: PPRBaseViewController {
    
    @IBOutlet var nameLabel: UIDLabel!
    @IBOutlet var modelLabel: UIDLabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var headerLabel: UIDLabel!
    @IBOutlet var warrantyLabel: UIDLabel!
    @IBOutlet var emailLabel: UIDLabel!
    @IBOutlet var continueButton: UIDButton!
    @IBOutlet var successIconImageView: UIImageView!
    @IBOutlet weak var ctnLabel: UIDLabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var registeredLabel: UIDLabel!

    var product: PPRRegisteredProduct?
    var userWithProduct: PPRUserWithProducts?
    var productSummaryResponse: PRXResponseData?
    var metadataInfo: PRXProductMetaDataInfoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackProductModelName()
        
        self.setLabelsFonts()
        
        self.updateProductDetails()

        self.setWarrantyAndEmailText()
        navigationItem.hidesBackButton = true
        self.continueButton.addTarget(self, action: #selector(continueAction(_ :)), for: .touchUpInside)
        
        let blueHeadingIconCheckImage = UIImage(named: "blue_heading_icon_check", in: Bundle.localBundle(), compatibleWith: nil)
        self.successIconImageView.image = blueHeadingIconCheckImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.trackPageName()
    }
    
    
    @IBAction func continueAction(_ sender: AnyObject) {
        self.popOutOfProductRegistrationViewControllers()
        self.delegate?.productRegistrationContinue(userProduct: self.userWithProduct!, products: [self.product!])
        self.executeCompletionHandlerWithError(error: nil)
    }

    private func updateProductDetails() {
        
        let summary = self.productSummaryResponse as? PRXProductSummaryDataResponse
        let data = summary?.data
        self.modelLabel.text = data?.productTitle
        
        if let product = self.product {
            self.ctnLabel.text = product.ctn
        }
        
        guard let urlStr = data?.imageURL else {
            return
        }
        
        guard let url = NSURL(string: (urlStr)) else {
            return
        }
        
        guard let imageData = NSData(contentsOf: url as URL) else {
            return
        }
        
        self.imageView.image = UIImage(data: imageData as Data)
    }
    
    private func setWarrantyAndEmailText() {
        
        if let metadataInfo = self.metadataInfo, metadataInfo.hasExtendedWarranty == true {
            if let warrantyConfigText = self.configuration?.contentConfiguration.extendWarrantyText {
                self.warrantyLabel.text = warrantyConfigText
            }
            else if let endDate = product?.endWarrantyDate {
                var warrantyText = LocalizableString(key: "PRG_Extended_Warranty_Lbltxt")
                if warrantyText.last != " " {
                    warrantyText = warrantyText + " "
                }
                
                let attributedString = NSMutableAttributedString(string:warrantyText)
                let attrs:[NSAttributedString.Key:AnyObject] = [NSAttributedString.Key.font : UIFont(name: "CentraleSansBold", size: 16)!]
                let boldString = NSMutableAttributedString(string:endDate.stringRepresentation()!, attributes:attrs)
                attributedString.append(boldString)
                
                self.warrantyLabel.attributedText = attributedString
            }
            else {
                self.warrantyLabel.removeFromSuperview()
            }
            
            if self.product?.sendEmail == true {
                if let emailConfigText = self.configuration?.contentConfiguration.emailText {
                    self.emailLabel.text = emailConfigText
                }
                else {
                    let emailText = LocalizableString(key: "PRG_Eamil_Sent_Lbltxt")
                    self.emailLabel.text = emailText
                }
            }
            else {
                self.emailLabel.removeFromSuperview()
            }
        } else {
            self.emailLabel.removeFromSuperview()
            self.warrantyLabel.removeFromSuperview()
        }
    }
    
    private func setLabelsFonts() {
        self.modelLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText;
        self.ctnLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText;
        self.warrantyLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText;
        self.emailLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText;
    }
}
