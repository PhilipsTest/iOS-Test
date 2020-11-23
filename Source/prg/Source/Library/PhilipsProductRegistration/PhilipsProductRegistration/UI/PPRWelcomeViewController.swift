//
//  WelcomeViewController.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit
import PhilipsUIKitDLS

class PPRWelcomeViewController: PPRBaseViewController {
    @IBOutlet var headerLabel: UIDLabel!
    @IBOutlet var benifitLabel: UIDLabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet weak var productRegisterButton: UIDButton!
    @IBOutlet weak var registerLaterButton: UIDButton!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        self.benifitLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        self.benifitLabel.productRegistrationLocalizedText = "PRG_ReceiveUpdates_Lbltxt"
        if let configText = self.configuration!.contentConfiguration.benefitText {
            self.benifitLabel.text(self.benifitLabel.text?.appending("\n").appending(configText) ?? "", lineSpacing: 4.0)
        }
        if let hideBtn = self.configuration!.contentConfiguration.mandatoryProductRegistration{
            self.registerLaterButton.isHidden = hideBtn
            if (hideBtn){
                if let registerBtnText = self.configuration!.contentConfiguration.mandatoryRegisterButtonText {
                    self.productRegisterButton.setTitle(registerBtnText, for: .normal)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.trackPageName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(PPRWelcomeViewController.orientationChanged(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationChanged (_ notification: NSNotification) {
        if self.scrollView.contentSize.height < self.scrollView.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom - self.scrollView.frame.size.height)
        self.scrollView.setContentOffset(bottomOffset, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == PPRStoryBoardIDs.registerScreen) {
            let detailVC = segue.destination as! PPRRegisterProductsViewController
            detailVC.products  = self.products
            detailVC.configuration = self.configuration
            detailVC.delegate = self.delegate
        }
    }
    
    override func loadView() {
        super.loadView()
        
        // get the correct image out of your userinterface configuration
        let image = self.configuration!.userInterfaceConfiguration.productPromotionImage
        
        productImageView.image = image
        if image == nil   { productImageView.removeFromSuperview() }
        // initialize the value of imageView with a CGRectZero, resize it later
        self.imageView = UIImageView(frame: .zero)
        
        // set the appropriate contentMode and add the image to your imageView property
        self.imageView.contentMode = .scaleAspectFill
        
        // add the imageView to your view hierarchy
        self.view.insertSubview(imageView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //set the frame of your imageView here to automatically adopt screen size changes (e.g. by rotation or splitscreen)
        self.imageView.frame = self.view.bounds
        
    }
    
    @IBAction func noAction(_ sender: AnyObject) {
        self.popOutOfProductRegistrationViewControllers()
        let regProducts = PPRUtils.converProductsToRegisteredProducts(products: self.products!, uuid: nil)
        self.delegate?.productRegistrationBack(userProduct: nil, products: regProducts)
        self.executeCompletionHandlerWithError(error: nil)
    }
}
