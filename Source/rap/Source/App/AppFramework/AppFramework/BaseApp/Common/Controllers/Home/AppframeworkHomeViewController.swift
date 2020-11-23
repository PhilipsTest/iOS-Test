/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

/** HomeViewController is a ViewController to show the home page and having hamburger menu embedded into it */
class AppframeworkHomeViewController: UIViewController {
    
    //MARK: Variable Declarations
    var presenter : HomePresenter?
    var violationManager : ValidateSecurityViolationsManager?
    var cartButton : UIBarButtonItem?
    var securityViolationText: String?
    
    @IBOutlet weak var homeViewTitle: UIDLabel!
    //MARK: Default methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = HomePresenter(_viewController: self)
        self.navigationItem.title = Utilites.aFLocalizedString("RA_HomeScreen_Title")
        self.homeViewTitle.text = Utilites.aFLocalizedString("RA_HomeScreen_Title")
        
        //AppInfra logging
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "HomeViewController:viewDidLoad", message: "Launching Home View Controller")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //AppInfra Tagging
        TaggingUtilities.trackPageWithInfo(page: Constants.TAGGING_HOME_PAGE, params: nil)
    }
}



