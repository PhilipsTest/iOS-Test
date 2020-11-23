//
//  PPRFindSerialNumberViewController.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 08/11/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS

class PPRFindSerialNumberViewController: PPRBaseViewController {

    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var findSerialNumberTitleLabel: UILabel!
    @IBOutlet var findSerialNumberDescriptionLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet weak var progressIndicator: UIDProgressIndicator!

    internal var metadataSerialContentData: PRXProductMetadataSerialContentData?
    internal var selectedProduct: PPRRegisteredProduct?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findSerialNumberTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText;
        self.findSerialNumberDescriptionLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText;
        
        self.loadProductFindSerialNumberImage()
        
        self.setFindSerialNumberDescriptionText()
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.trackPageName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Utility methods
    func setFindSerialNumberDescriptionText() {
        var serialNumberCharDescriptionString: String = ""
        if self.metadataSerialContentData?.snExample != nil {
            let snExampleString = self.metadataSerialContentData?.snExample
            let index = snExampleString?.range(of: ":", options: .backwards)?.upperBound
            let exampleSerialNo = (index == nil) ? snExampleString : snExampleString?[index!...].trimmingCharacters(in: .whitespaces)
            let firstCharacter = exampleSerialNo?.first
            serialNumberCharDescriptionString = String(format: "%@ %d %@ \(firstCharacter!) %@ %@", LocalizableString(key: "PRG_serial_number_consists"), (exampleSerialNo?.length)!, LocalizableString(key: "PRG_number_starting"), LocalizableString(key: "PRG_eg"), exampleSerialNo!)
        }
        var serialNoDescriptionString: String
        if  self.metadataSerialContentData?.serialNumberSampleContentDescription != nil {
            serialNoDescriptionString = (self.metadataSerialContentData?.serialNumberSampleContentDescription)! + "\n" + serialNumberCharDescriptionString
        } else {
            serialNoDescriptionString = serialNumberCharDescriptionString
        }

        self.findSerialNumberDescriptionLabel.text(serialNoDescriptionString, lineSpacing: 4.0)
        self.findSerialNumberDescriptionLabel.sizeToFit()
    }
    
    func loadProductFindSerialNumberImage() {
        
        self.progressIndicator.startAnimating()
        
        PRXProductMetaDataRequest(product: self.selectedProduct!).getRequestUrl(from: PPRInterfaceInput.sharedInstance.appDependency.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
            
            if self.metadataSerialContentData!.asset != nil {
                let urlString: String = String(format: "%@%@", (serviceURL?.components(separatedBy: "/prx")[0])!,self.metadataSerialContentData!.asset!)
                self.imageForImageURLString(imageURLString: urlString) { (image, success) -> Void in
                    if success {
                        DispatchQueue.main.async { () -> Void in

                            guard let image = image
                                else {
                                    self.progressIndicator.stopAnimating()
                                    return
                            }
                            // You now have the image. Use the image to update the view or anything UI related here
                            self.productImageView.image = image
                            self.productImageView.contentMode = .scaleAspectFit
                            self.progressIndicator.stopAnimating()
                        }
                    } else {
                        // Error handling here.
                        self.progressIndicator.stopAnimating()
                    }
                }
            }
            else {
                let productPlaceholderImage = UIImage(named: "product_placeholder", in: Bundle.localBundle(), compatibleWith: nil)
                self.productImageView.image = productPlaceholderImage
            }
        })
    }
    
    func imageForImageURLString(imageURLString: String, completion: (_ image: UIImage?, _ success: Bool) -> Void) {
        guard let url = NSURL(string: imageURLString),
            let data = NSData(contentsOf: url as URL),
            let image = UIImage(data: data as Data)
            else {
                completion(nil, false);
                return
        }
        
        completion(image, true)
    }
}
