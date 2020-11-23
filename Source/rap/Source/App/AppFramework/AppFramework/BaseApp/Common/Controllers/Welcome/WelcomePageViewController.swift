/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import PhilipsIconFontDLS

/** WelcomePageViewController */
class WelcomePageViewController: UIViewController {

    //MARK: Variable Declarations

    @IBOutlet weak var separator: UIView!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var pageController: UIDPageControl!
    @IBOutlet  weak var btnDone: UIDButton!
    @IBOutlet  weak var btnSkipWelcome: UIDButton!
    @IBOutlet  weak var btnForwardPage: UIDButton!
    @IBOutlet  weak var btnBackPage: UIDButton!
    @IBOutlet weak var btnEnvironmentSettings: UIButton!

    var presenter : BasePresenter?

    var welcomeViewController: WelcomeViewController? {
        // Setter to set WelcomePageViewController as delegate of WelcomeViewController
        didSet {
            welcomeViewController?.pageDelegate = self
        }
    }
    //MARK: Default methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = StateBasedNavigationPresenter(_viewController: self, forState: AppStates.Welcome)
        configureUI()
        configureButtonsForIndex(0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        //TODO: Figure out why the separator keeps disappearing from the screen when attempting to use regular constraints,
        // repositioning through code for now
        let separatorFrame = CGRect(x: 0, y: pageController.frame.origin.y - 12, width: containerView.bounds.width, height: 1)
        separator.frame = separatorFrame
        view.bringSubviewToFront(separator)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSkipWelcome.layer.borderWidth = 0.0
        btnDone.layer.borderWidth = 0.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let welcomeViewController = segue.destination as? WelcomeViewController {
            self.welcomeViewController = welcomeViewController
        }
    }

}

//MARK: Helper methods

extension WelcomePageViewController: UIDPageControlDelegate {
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    
    func pageDidChange(_ pageControl: UIDPageControl) {
        welcomeViewController?.scrollToViewController(index: pageController.currentPage)
    }

    /**
     Fired when the user taps on the back button to move to previous page.
     */
    @IBAction func backClicked(_ sender: AnyObject) {
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_WELCOME_TAG , message: Constants.LOGGING_WELCOME_BACKCLICKED )
        // Changing current page to previous page when back button is clicked.
        var currentPage = pageController.currentPage
        if currentPage != 0{
            currentPage -= 1
            pageController.currentPage = currentPage
            welcomeViewController?.scrollToViewController(index: pageController.currentPage)
        }
    }

    /**
     Fired when the user taps on the forward button to move to next page.
     */
    @IBAction func forwardClicked(_ sender: AnyObject) {
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_WELCOME_TAG , message: Constants.LOGGING_WELCOME_NEXTCLICKED)
        // Changing current page to next page when next button is clicked.
        var currentPage = pageController.currentPage
        if currentPage != pageController.numberOfPages - 1{
            currentPage += 1
            pageController.currentPage = currentPage
            welcomeViewController?.scrollToViewController(index: pageController.currentPage)
        }
    }
    /**
     Fired when the user taps on the Start button to say the Introduction/Welcome flow in completed.
     */
    @IBAction func welcomeFlowCompleted(_ sender: AnyObject) {
        let buttonId = sender.restorationIdentifier
        navigateToNextScreen(buttonId!)

        //On Start clicked the flag is set true to disable introduction when user comes next time into the app

        UserDefaults.standard.set(true, forKey: Constants.WELCOME_SCREEN_SHOWN_FLAG_STATE)
       
        UserDefaults.standard.synchronize()
    }
    /**
     Fired when the user taps on the Skip button to Skip the Introduction/Welcome flow.
     */
    @IBAction func skipWelcome(_ sender: AnyObject) {
        let buttonId = sender.restorationIdentifier
        navigateToNextScreen(buttonId!)
    }

    /**
     Fired when the user taps on the Skip button or Start button, Which will be navigated to user registration screen.
     */



    func navigateToNextScreen(_ senderId : String?) {
       _ = presenter?.onEvent(senderId!)
    }

    /**
     Based on number of introduction screens set visibility for back button, next button, Skip button, Start Button.
     if first page : Hide Start button and show Back, Next and Skip button
     if last page : Show Start, Back and Hide Next and Skip button
     */
    func configureButtonsForIndex(_ index : Int) {
        if pageController.numberOfPages == 1 {
            btnForwardPage.isHidden = true
            btnBackPage.isHidden = true
            btnSkipWelcome.isHidden = true
            btnDone.isHidden = false
        } else {
            // if first page : Hide Start button and show Back, Next and Skip button
            if index == 0 {
                btnBackPage.isHidden = true
                btnDone.isHidden = true
                btnForwardPage.isHidden = false
                btnSkipWelcome.isHidden = false
            } else if index == pageController.numberOfPages - 1 {
                btnBackPage.isHidden = true // TODO: no longer required in DLS spec, should be cleaned up diligently
                btnForwardPage.isHidden = true
                btnDone.isHidden = false
                view.bringSubviewToFront(btnDone)
                btnSkipWelcome.isHidden = true
            } else {
                // if last page : Show Start, Back and Hide Next and Skip button
                btnBackPage.isHidden = true // TODO: no longer required in DLS spec, should be cleaned up diligently
                btnForwardPage.isHidden = false
                btnDone.isHidden = true
                btnSkipWelcome.isHidden = false
            }
        }
    }

    /**
     Configure UI for page control such as page control dots color, back and next button image.
     */
    fileprivate func configureUI() {
        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            let newThemeConfig = UIDThemeConfiguration(colorRange: theme.colorRange, tonalRange: .bright)
            let newTheme = UIDTheme(themeConfiguration: newThemeConfig)
            pageController.theme = newTheme
        }
        
        pageController.delegate = self
        btnForwardPage.titleFont = UIFont.iconFont(size: 18)
        btnForwardPage.setTitle(PhilipsDLSIcon.unicode(iconType: .navigationRight), for: .normal)
        
        btnBackPage.titleFont = UIFont.iconFont(size: 18)
        btnBackPage.setTitle(PhilipsDLSIcon.unicode(iconType: .navigationLeft), for: .normal)

        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.navigateToEnvironmentSelection(_:)))
        btnEnvironmentSettings.addGestureRecognizer(longpress)
    }

    @objc func navigateToEnvironmentSelection(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            _ = presenter?.onEvent(Constants.UR_ENVIRONMENT_SETTINGS_EVENTID)
        }
    }
}

//MARK: PagedViewViewControllerDelegate methods

extension WelcomePageViewController: PagedViewViewControllerDelegate {
    /**
     Delgate method to set number of pages in page control
     */
    func pagedViewViewController(_ welcomeViewController: PagedViewViewController,
                                 didUpdatePageCount count: Int) {
        pageController.numberOfPages = count
    }

    /**
     Delgate method to set selected page in page control
     */
    func pagedViewViewController(_ welcomeViewController: PagedViewViewController,
                                 didUpdatePageIndex index: Int) {
        pageController.currentPage = index
        configureButtonsForIndex(index)
    }

}
