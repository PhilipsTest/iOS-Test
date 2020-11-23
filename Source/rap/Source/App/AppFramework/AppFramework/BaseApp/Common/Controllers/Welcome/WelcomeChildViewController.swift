/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

/** WelcomeChildViewController */
class WelcomeChildViewController: UIViewController {
    
    //MARK: Variable Declarations
    
    @IBOutlet weak var lblTitle: UIDLabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblDescription: UIDLabel!
    var screenDict : [String:AnyObject]?
    var isPortrait : Bool?
    @IBOutlet weak var imgWelcomeIcon: UIImageView?
    
    //MARK: Default methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        imgBackground.contentMode = .scaleAspectFit
        configureUI()
    }
}

//MARK: Helper methods

extension WelcomeChildViewController {
    
    /** Method to provide one point configurations for welcome screen, Configure
     1. Background image for introduction screen
     2. Text for title label
     3. Description text
     */
   @objc func configureUI() {
        var newTheme = UIDThemeManager.sharedInstance.defaultTheme
        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            let newThemeConfig = UIDThemeConfiguration(colorRange: theme.colorRange, tonalRange: .bright)
            newTheme = UIDTheme(themeConfiguration: newThemeConfig)
        }
    
        isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
        
        if let screenDictNew = screenDict {
            if isPortrait == true {
                if let backgroundImageString = (screenDictNew[Constants.WELCOME_BACKGROUND_IMAGE_KEY] as? String) {
                        imgBackground.image = UIImage(named:backgroundImageString)
                    }
            } else {
                if let landscapeImageString = (screenDictNew[Constants.WELCOME_LANDSCAPE_IMAGE_KEY] as? String) {
                    imgBackground.image = UIImage(named:landscapeImageString)
                }
            }
            
            if let image = imgWelcomeIcon {
                if let thumbnailImageString = (screenDictNew[Constants.WELCOME_THUMBNAIL_IMAGE_KEY] as? String) {
                    image.image = UIImage(named:thumbnailImageString)
                }
            }
            
            if let titleAttributesNew = screenDictNew[Constants.TITLE_KEY] as? [String:AnyObject] {
                let titleAttributes = titleAttributesNew
                if let labelTitleNew = titleAttributes[Constants.WELCOME_TEXT_KEY] as? String {
                    lblTitle.text = (Utilites.aFLocalizedString(labelTitleNew))
                    lblTitle.theme = newTheme
                }
            }
            if let descAttributesNew = screenDictNew[Constants.WELCOME_DESCRIPTION_KEY] as? [String:AnyObject] {
                let descriptionAttributes = descAttributesNew
                if let labelDescriptionNew = descriptionAttributes[Constants.WELCOME_TEXT_KEY] as? String {
                    lblDescription.text = (Utilites.aFLocalizedString(labelDescriptionNew))
                    lblDescription.theme = newTheme
                }
            }
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if let screenDictNew = screenDict {
            if (toInterfaceOrientation.isLandscape) {
                isPortrait = false
                if let landscapeImageString = (screenDictNew[Constants.WELCOME_LANDSCAPE_IMAGE_KEY] as? String) {
                    imgBackground.image = UIImage(named:landscapeImageString)
                }
            }
            else {
                isPortrait = true
                if let landscapeImageString = (screenDictNew[Constants.WELCOME_BACKGROUND_IMAGE_KEY] as? String) {
                    imgBackground.image = UIImage(named:landscapeImageString)
                }
            }
        }
    }
}

