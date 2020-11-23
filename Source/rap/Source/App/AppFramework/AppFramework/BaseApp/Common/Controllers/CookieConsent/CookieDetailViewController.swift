//
//  CookieDetailViewController.swift
//  AppFramework
//
//  Created by Philips on 8/22/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS

class CookieDetailViewController: UIViewController {

    @IBOutlet weak var headerTitle: UIDLabel!
    @IBOutlet weak var cookieDetailText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cookieDetailText.text = Constants.Cookie_Secondary_Description_Paragraph
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cookieDetailText.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        configUI()
    }
            
    func configUI(){
        self.navigationItem.title = Constants.Cookie_Consent_Navigation_Title
        self.navigationItem.isAccessibilityElement = true
        self.navigationController?.navigationBar.accessibilityLabel = "csw_justInTimeView_toolbar"
        self.navigationItem.accessibilityLabel = "csw_justInTimeView_toolbar_title"
        
        headerTitle.text = Constants.Cookie_Consent_HyperLink
        headerTitle.textColor = UIColor.black
        headerTitle.font = UIFont(uidFont:.bold, size: UIDFontSizeLarge)
    }
}
