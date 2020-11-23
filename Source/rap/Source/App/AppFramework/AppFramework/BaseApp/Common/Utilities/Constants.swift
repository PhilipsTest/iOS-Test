/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import  UIKit

struct Constants {
    static let CONFIGURATION_FILE_NAME = "Configure"
    static let PLIST_TYPE = "plist"
    static let JSON_TYPE = "json"
    
    static let APPFRAMEWORK_TEXT = "AppFramework"
    static let ADBMOBILE_PATH = "ADBMobileConfig"
    static let WELCOME_SCREEN_KEY = "Welcome"
    static let WELCOME_BACKGROUND_IMAGE_KEY = "BackgroundImage"
    static let WELCOME_LANDSCAPE_IMAGE_KEY = "LandscapeImage"
    static let WELCOME_THUMBNAIL_IMAGE_KEY = "WelcomeThumnail"
    static let TITLE_KEY = "Title"
    static let WELCOME_ALIGN_KEY = "Align"
    static let WELCOME_TEXT_KEY = "Text"
    static let WELCOME_DESCRIPTION_KEY = "Description"
    static let WELCOME_VIDEO_ID_KEY = "VideoID"
    static let WELCOME_VIDEO_THUMBNAIL_KEY = "VideoThumbnail"
    static let STORYBOARD_NAME_KEY = "StoryBoardName"
    static let VIEWCONTROLLER_ID_KEY = "ViewControllerId"
    static let MENU_ID_KEY = "MenuId"
    static let Screen_Title = "ScreenTitle"
    static let FLOW_CONFIG_FILE_NAME = "AppFlow"
    static let ONEVENT_LOGIN = "Log In"
    static let ONEVENT_LOGOUT = "Log Out"
    static let ONEVENT_ORDER_HISTORY = "Order History"
    
    static let HAMBURGER_MENU_SCREEN_KEY = "HamburgerMenu"
    static let IMAGE_KEY = "Image"
    
    //Storyboard ids
    static let WELCOME_NAVIGATION_STORYBOARD_ID = "welcomeNavigation"
    static let WELCOME_CHILD_STORYBOARD_ID = "welcomeChildViewController"
    static let WELCOME_VIDEO_CHILD_STORYBOARD_ID = "welcomeVideoChildViewController"
    static let WELCOME_PAGE_VIEW_CONTROLLER_STORYBOARD_ID = "welcomePageViewController"
    static let MAIN_STORYBOARD_NAME = "Main"
    static let WELCOME_STORYBOARD_NAME = "Welcome"
    static let HOME_STORYBOARD_NAME = "Home"
    static let SHOPPING_STORYBOARD_NAME = "Shopping"
    static let ABOUT_STORYBOARD_NAME = "About"
    static let HOME_VIEWCONTROLLER_STORYBOARD_ID = "homeViewController"
    static let HOME_NAVIGATION_STORYBOARD_ID = "homeVCNavigationController"
    static let HAMBURGER_MENU_STORYBOARD_ID = "HamburgerMenu"
    static let HAMBURGER_MENU_VIEWCONTROLLER_STORYBOARD_ID = "hamburgerMenuViewController"
    static let HAMBURGER_MENU_CONTROLLER_STORYBOARD_ID = "HamburgerMenuVC"
    static let HELP_STORYBOARD_NAME = "Help"
    static let HELP_VIEWCONTROLLER_STORYBOARD_ID = "helpViewControllerID"
    static let TERMS_AND_PRIVACY_STORYBOARD_NAME = "TermsAndConditions"
    static let TERMS_AND_PRIVACY_STORYBOARD_ID = "TermsAndConditions"
    
    static let COMPONENTVERSION_STORYBOARD_NAME = "ComponentVersions"
    static let COMPONENT_VIEWCONTROLLER_STORYBOARD_ID = "componentVersionsViewControllerID"
    
    static let SETTINGS_STORYBOARD_NAME = "Settings"
    static let SETTINGS_VIEWCONTROLLER_STORYBOARD_ID = "settingsViewControllerID"
    static let USER_REGISTRATION_ENVIRONMENT_STORYBOARD_NAME = "UserRegEnv"
    static let USER_REGISTRATION_ENVIRONMENT_VIEWCONTROLLER_STORYBOARD_ID = "userRegEnvSetting"
    static let ABOUT_VIEWCONTROLLER_STORYBOARD_ID = "AboutViewControllerId"
    
    static let TABBED_STORYBOARD_NAME = "TabbedMenu"
    static let TABBED_VIEWCONTROLLER_STORYBOARD_ID = "tabbedViewControllerID"
    static let SPLASH_VIEWCONTROLLER_STORYBOARD_ID = "splashViewControllerID"
    
    
    static let WELCOME_SCREEN_SHOWN_FLAG_STATE = "AppFramework.isWelcomeScreenShown"
    
    static let REMOVE_WELCOME_SCREEN_NOTIFICATION = "AppFramework.RemoveWelcomeScreen"
    
    static let FIRST_STATE_KEY = "AppFramework.AppFirstState"
    
    static let CREATE_STATE_NOTIFICATION_NAME = "AppFramework:CreateState"
    static let STATE_ID_KEY = "stateId"
    static let BASE_VIEW_CONTROLLER_KEY = "BaseViewController"
    static let VIEW_LOAD_DETAILS_KEY = "ViewControllerLoadDetails"
    static let THEME_PREVIEW_STORYBOARD_SEGUE = "ThemePreviewStoryboardSegue"
    
    //Settings keys
    static let SETTINGS_TABLE_CELL = "SettingsTableViewCell"
    static let SETTINGS_CUSTOM_TABLE_CELL = "SettingsCustomCell"
    static let SETTINGS_CUSTOM_BUTTON_CELL = "ButtonCell"
    static let SETTINGS_SECTION_STATE = "State"
    static let SETTINGS_ROW_STATE = "State"
    static let SETTINGS_SECTION_HEADER = "SectionHeader"
    static let SETTINGS_SECTION_DETAILS = "Details"
    static let SETTINGS_KEY_ACCESSORYTYPE = "AccessoryType"
    static let SETTINGS_ROW_TITLE = "Title"
    static let SETTINGS_KEY_LOGGEDIN = "LoggedIn"
    static let SETTINGS_KEY_LOGIN = Utilites.aFLocalizedString("RA_Settings_Login")
    static let SETTINGS_KEY_CANCEL = Utilites.aFLocalizedString("RA_Cancel")
    static let SETTINGS_PLIST_NAME = "Settings"
    static let SETTINGS_SWITCH_NAME = "Switch"
    static let SETTINGS_BUTTON_TYPE = "Button"
    static let SETTINGS_DISCLOSURE_TYPE = "Discolsure"
    static let SETTINGS_CUSTOMCELL_TEXT = Utilites.aFLocalizedString("RA_Settings_Promo_Question_Text")
    static let LOGIN_MESSAGE = Utilites.aFLocalizedString("RA_You_are_not_LoggedIn")
    static let APPFRAMEWORK_TITLE = Utilites.aFLocalizedString("BA_AppFramework")
    static let UPDATE_USER_DATA_ERROR = Utilites.aFLocalizedString("RA_Update_Userdata_Error")
    static let INVALID_PARAMETERS_MESSAGE =  Utilites.aFLocalizedString("RA_Invalid_Param_Msg")
    static let FLOW_MANAGER_ERROR = Utilites.aFLocalizedString("RA_something_wrong")
    static let COMMON_COMPONENT_TEXT = Utilites.aFLocalizedString("common_components")
    
    static let ABOUTVIEW_BODYTEXT_MESSAGE = Utilites.aFLocalizedString("RA_DLS_about_description")
    static let CONSUMERCARE_PRODUCT_INFO_FILE = "ProductInfo"
    static let CONSUMERCARE_PRODUCT_INFO_FILE_CHINA = "ProductInfoChina"
    static let CONSUMERCARE_MAIN_MENU_SELECTION_PR = "Register Your Product"
    
    static let PRODUCTREGISTRATION_BENIFIT_TEXT = Utilites.aFLocalizedString("RA_PR_Benefit_Text")
    static let PRODUCTREGISTRATION_EXTENDED_WARRENTY_TEXT = Utilites.aFLocalizedString("RA_PR_Extentende_Warranty")
    static let PRODUCTREGISTRATION_EMAIL_TEXT = Utilites.aFLocalizedString("RA_PR_Email_Text")
    static let PRODUCTREGISTRATION_CTN = "HX6064/33"
    
    static let INAPP_SHOPPING_CART_ICON_TEXT = "CartIcon"
    static let INAPP_SHOPPING_CART_ICON_BADGE_STRING = "0"
    static let INAPP_SHOPPING_TROLLY_IMAGE_NAME = "shopping_trolley"
    static let OK_TEXT = Utilites.aFLocalizedString("RA_OK")
    
    static let USERREGISTRATION_VALUE_FOR_REGISTRATION = "You will need an account to [related content]"
    static let APPINFRA_APPIDENTITY_STATE = "appidentity.appState"
    static let APPINFRA_TEXT = "appinfra"
    static let USER_REGISTRATION_TEXT = "UserRegistration"
    static let RECEIVE_MARKETING_EMAIL   = "receiveMarketingEmail"
    static let GIVEN_NAME                = "givenName" 
    static let USERREGISTRATION_ENVIRONENT_SETTING_CELL_ID = "envCells"
    static let DATASERVICES_CELL_ID = "MomentCell"
    static let USERDEFAULTS_CURRENTCONFIG_KEY = "AppFramework:currentConfiguration"
    static let USERREGISTRATION_ENVIRONMENT_ALERT_TITLE = Utilites.aFLocalizedString("RA_UR_Env_Alert")
    static let USERREGISTRATION_ENVIRONMENT_ALERT_MESSAGE = Utilites.aFLocalizedString("RA_change_config_desc")
    
    static let UIKIT_FONT_CENTRALSANS = "CentraleSansBook"
    
    static let EDIT_TEXT = "edit"
    
    static let ALERT_TITLE_WARNING =  Utilites.aFLocalizedString("RA_Warning")
    
    static let LOGGING_SETTINGS_STATE_COMPLETION_TAG = "Settings State Complete"
    static let LOGGING_STATE_COMPLETION_DEFAULT_MESSAGE = "Default state in Settings State Completion Handler"
    
    static let APP_SCREEN_SETUP_MESSAGE = "App Screens are being setup. Please Wait."
    
    
    //AppInfra Logging
    
    static let LOGGING_ABOUT_TAG = "About App"
    static let LOGGING_ABOUT_MESSAGE = "Launching In About App"
    static let LOGGING_ABOUT_DELEGATE_TERMS_AND_CONDITIONS = "AboutViewDidSelectTermsAndConditions"
    static let LOGGING_ABOUT_DELEGATE_PRIVACY = "AboutViewDidSelectPrivacyPolicy"
    static let LOGGING_CONSUMERCARE_TAG = "Consumer Care"
    static let LOGGING_CONSUMERCARE_MESSAGE = "Launched Consumer Care successfully"
    static let LOGGING_CONSUMERCARE_ERRORMESSAGE = "Launching Consumer Care failed with error : "
    static let LOGGING_INAPP_TAG = "InAppPurchase"
    static let LOGGING_INAPP_MESSAGE = "Launched InAppPurchase successfully"
    static let LOGGING_INAPP_ERROR_MESSAGE = "Launching InAppPurchase failed with error : "
    static let LOGGING_FLOW_MANAGER_TAG = "Flow Manager Logging"
    
    //IAP CART
    static let LOGGING_INAPP_FETCHCART_ERROR_MESSAGE = "Could not fetch Cart Count for "
    static let LOGGING_INAPP_SHOPPING_CART_MESSAGE = "Launched InAppPurchase cart successfully"
    static let LOGGING_INAPP_SHOPPING_CART_ERROR_MESSAGE = "Launching InAppPurchase cart failed with error : "
    
    
    static let LOGGING_HAMBURGERMENU_TAG = "Hamburger Menu"
    static let LOGGING_HAMBURGERMENU_MESSAGE = "In Hamburger Menu Presenter default state"
    static let LOGGING_HAMBURGERMENU_SELECTION = "Hamburger Menu selected"
    static let LOGGING_HAMBURGERMENU_LAUNCH = "Hamburger Menu is launched"
    
    static let LOGGING_PRODUCTREGISTRATION = "Product Registration"
    static let LOGGING_PRODUCTREGISTRATION_ERROR_MESSAGE = "Launching Product Registration failed with error : "
    static let LOGGING_PRODUCTREGISTRATION_MESSAGE = "Launched Product Registration successfully"
    static let LOGGING_PRODUCTREGISTRATION_BACK_PRESSED = "Back pressed"
    static let LOGGING_PRODUCTREGISTRATION_CONTINUE_PRESSED = "Continue pressed"
    
    static let LOGGING_SETTINGS_TAG = "Settings"
    static let LOGGING_SETTINGS_LOGOUT = "LogOut Clicked"
    static let LOGGING_SETTINGS_DEFAULT_MESSAGE = "In Settings Presenter default state"
    static let LOGGING_VIEW_DID_LOAD = "ViewDidLoad"
    
    static let LOGGING_WELCOME_TAG = "Welcome"
    static let LOGGING_USERLOGIN_ERROR = "User logging failed with error: "
    static let LOGGING_USERLOGIN_MESSAGE = "User Logged in Successfully"
    static let LOGGING_WELCOME_DEFAULT_MESSAGE = "In Welcome Presenter default state"
    
    static let LOGGING_WELCOME_BACKCLICKED = "Back Clicked"
    static let LOGGING_WELCOME_NEXTCLICKED = "Next Clicked"
    
    // Component Versions Tagging
    static let LOGGING_COMPONENT_VERSIONS_TAG = "Component Versions"
    static let LOGGING_COMPONENT_VERSIONS_MESSAGE = "Launching In Component Versions"
    
    static let EVENT_SETTINGS_REGISTRATION_CONTINUE = "registrationSettings_continue"
    static let EVENT_WELCOME_REGISTRATION_CONTINUE = "registrationWelcome_continue"
    
    static let ORDER_HISTORY = "Order History"
    
    //Notification Objects
    
    static let LOGOUT_SUCCESS_NOTIFICATION = "LogoutDidSucceed"
    
    //Appdelegate shared object
    static let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate
    
    // Data Service Screen
    static let DATASERVICE_ALERT_TITLE =  Utilites.aFLocalizedString("RA_DataServices_Moments_UserConsents_Alert_Title")
    static let DATASERVICES_STORYBOARD_NAME = "DataServices"
    static let DATASERVICES_VIEWCONTROLLER_STORYBOARD_ID = "DataServicesViewControllerId"
    static let DATASERVICES_ADD_VC_STORYBOARD_ID = "AddNewData"
    static let DATASERVICES_USER_CONSENT_STORYBOARD_ID = "UserConsentId"
    static let DATASERVICES_SETTINGS_VC_STORYBOARD_ID = "DataSyncSettings"
    static let DEFAULT_VIEWCONTROLLER_STORYBOARD_ID = "DefaultViewControllerID"
    static let DEFAULT_NOTE_VIEWCONTROLLER_STORYBOARD_ID = "NoteTypeViewController"
    
    //DataService Constant
    static let DATASERVICES_CHARACHTERISTICS_INVALID_JSON = "The JSON you entered is invalid"
    
    // Tagging
    static let TAGGING_ABOUT_PAGE = "About"
    static let TAGGING_COMPONENTVERSION_PAGE = "Component"
    static let TAGGING_HAMBURGERMENU_PAGE = "HamburgerMenu"
    static let TAGGING_HOME_PAGE = "Home"
    static let TAGGING_SPLASH_PAGE = "Splash"
    static let TAGGING_WELCOME_PAGE = "Welcome"
    static let TAGGING_SETTINGS_PAGE = "Settings"
    
    static let TAGGING_REMARKETINGOPTIN = "remarketingOptIn"
    static let TAGGING_REMARKETINGOPTOUT = "remarketingOptOut"
    static let TAGGING_SENDDATA = "sendData"
    static let TAGGING_APPSTATUS = "appStatus"
    static let TAGGING_FOREGROUND = "Foreground"
    static let TAGGING_BACKGROUND = "Background"
    static let TAGGING_PRIVACY_POLICY_ACTION = "rap:triggerchurn"
    
    // Consumer Care Live Chat Url
    static let LIVE_CHAT_URL_CN = "https://ph-china.livecom.cn/webapp/index.html?app_openid=ph_6idvd4fj&token=PhilipsTest"
    
    // PushNotification Constants:
    
    
    static let APP_AGENT = "RAP-IOS"
    static let PROTOCOL_SERVICE = "Push.Apns"
    static let REGISTER_PUSH_NOTIFICATION_MESSAGE = "regsiterDeviceTokenForPushNotification"
    
    // COCO Versions
    static let COCOVERSIONS_PLIST_NAME = "COCO Versions"
    static let COCOVERSIONS_KEY_LOGGEDIN = "LoggedIn"
    static let COCOVERSIONS_KEY_ACCESSORYTYPE = "AccessoryType"
    static let COCOVERSIONS_SECTION_DETAILS = "Details"
    static let COCOVERSIONS_TABLE_CELL = "ComponentVersionsTableViewCell"
    static let COCOVERSIONS_ROW_TITLE = "Title"

    // Generic Texts
    static let VIEW_WILL_DISAPPER_TEXT = "viewWillDisappear"
    static let VIEW_DID_LOAD_TEXT = "viewDidLoad"
    static let APPINFRA_LOG_VALUE = "Result"
    
    //Security Violation PopView
    
    static let PASSCODE_VIOLATION_TEXT_MESSAGE = "We’ve detected that you have not activated a Touch ID or Passcode, Thereby making it easier for others to access your data. Go to Settings > Touch ID & Passcode to activate."
    static let JAILBREAK_VIOLATION_TEXT_MESSAGE = "We’ve detected that you have rooted the device or jailbroken, Thereby making it easier for others to access your data and no security on your application data."
    static let PASSCODE_AND_JAILBREAK_VIOLATION_TEXT_MESSAGE = "We’ve detected that you have jailbroken and not activated Touch ID/Passcode, Thereby making it easier for others to access your data. Go to Settings > Touch ID & Passcode to activate."
    static let USER_LOGGEDIN_FIRST_TIME = "IsUserLoggedIn"
    static let VALIDATE_SECURITY_VIOLATION_STATUS = "ValidateVoliationStatus"
    static let DONT_SHOW_MESSAGE_FOR_PASSCODE = "DontShowMessageForPasscode"
    static let DONT_SHOW_MESSAGE_FOR_JAILBREAK = "DontShowMessageForJailbreak"
    static let DONT_SHOW_MESSAGE_FOR_PASSCODE_AND_JAILBREAK = "DontShowMessageForPasscodeAndJailbreak"
    static let NO_VIOLATION_TEXT = "No Security Violations"
    static let TRUE_TEXT = "true"
    static let FALSE_TEXT = "false"
    static let TEXT_SIZE_12 = 12
    static let TEXT_SIZE_13 = 13
    static let POPUP_VIEWCONTROLLER_STORYBOARD_ID = "PopUpView"
    static let CHAPTERLIST_VIEWCONTROLLER_STORYBOARD_ID = "ReferenceAppTestID"
    static let CHAPTERLIST_STORYBOARD_NAME = "TestDemoApps"
    static let CHAPTER_DETAILS_STORYBOARD_ID = "ReferenceAppTestDetailsID"
    static let CHAPTER_TABLE_CELL_IDENTIFIER = "Cell"
    static let OPTION_HEADER_KEY_FROM_PLIST = "Chapters"
    static let CHAPTERNAME_KEY = "ChapterName"
    static let CHAPTER_COCO_DEMO_APPS_KEY = "ChapterCocoDemoApps"
    static let COCO_DEMO_APP_NAME_KEY = "CoCoDemoAppName"
    static let COCO_DEMO_EVENT_ID_KEY = "CoCoDemoEventID"
    static let SECTION_HEADER_CHAPTER_LIST = "List Of Chapters"
    
    //TermsCondition and PrivacyPolicy
    static let TYPE_OF_CONDITION_IDENTIFIER = "ConditionClicked"
    static let PRIVACY_POLICY_LAUNCH = "launchPrivacyPolicy"
    static let TERMS_AND_CONDITION_LAUNCH = "launchTermsAndConditions"
    static let PERSONAL_CONSENT_LAUNCH = "launchPersonalConsentDescription"
    static let PRIVACY_POLICY_TEXT = Utilites.aFLocalizedString("RA_DLS_about_privacy")
    static let TERMS_AND_CONDITION_TEXT = "Terms And Conditions"
    static let PERSONAL_CONSENT_TEXT = "Personal Consent"
    static let TERMS_AND_PRIVACY_TEXT = "termsAndPrivacy"
    static let APP_ID_PRIVACY = "app.privacynotice"
    static let APP_ID_TERMS_AND_CONDITION = "app.termsandconditions"
    static let APP_ID_PERSONAL_CONSENT = "app.personalConsent"
    static let DEFAULT_TEXT = "Default case"
    
    // Micro App :
    
    static let CENTRAL_MANAGER_IDENTIFIER = "REFAPPUNIQUECENTRALIDENTIFER"
    
    // Apptelligent
    static let APPTELIGENTKEY = "8949a6b330ea4dc4851b5b234e5f655c00555300"
    
    // User Registration Environment Settings
    static let UR_ENVIRONMENT_SETTINGS_EVENTID = "UserRegEnvironmentSettings"
    
    static let ISHYBRIS_ENABLED = "IsHybrisEnabled"
    static let BADGE_COUNT = "BadgeCount"

    //Cicular View Constants
    static let CIRCULAR_VIEW_VALUE = 360
    static let GET_RADIUS_FACTOR = CGFloat(2)
    static let CIRCULAR_VIEW_DEGREE = 180
    static let ANIMATION_KEY_VALUE =  "MyAnimation"
    static let VALUE_0 = 0
    static let VALUE_2 = 2
    static let LINE_WIDTH = 4.0
    static let VALUE_100 = 100
    static let THREE_DEGREE_GAP = 0.0523599
    static let SCROLL_FACTOR = CGFloat(140)
    
    // DLS Welcome screen Padding
    static let DLS_WELCOME_SCREEN_SCROLL_HEIGHT = 120
    // DLS Theming
    static let THEME_COLOR_RANGE = "ThemeColorRange"
    static let THEME_TONAL_RANGE = "ThemeTonalRange"
    static let THEME_NAVTONAL_RANGE = "ThemeNavigationTonalRange"
    static let THEME_SETTING_ICON = "ThemeSettingIcon"
    static let THEME_SETTING_CHECK_ICON = "ThemeSettingCheckIcon"
    static let COLOR_RANGE_COLLECTION_VIEW_CELL = "ColorRangeCollectionViewCell"
    
    //Hamburger Menu
    static let HAMBURGER_LEFT_MENU_STORYBOARD_ID = "SideBarLeftViewController"
    static let HAMBURGER_IMAGE_KEY = "Image"
    static let HAMBURGER_ICON_IMAGE = "HamburgerIcon"
    static let HAMBURGER_LOGIN_STATUS = "Hello user, Please login"
    
    //CookieConsent
    static let Cookie_Consent_Allow_Event_ID = "cookie_allow"
    static let Cookie_Consent_Disallow_Event_ID = "cookie_disallow"
    static let Cookie_Header_Title = Utilites.aFLocalizedString("RA_cookie_title")
    static let Cookie_Accept = Utilites.aFLocalizedString("RA_cookie_accept")
    static let Cookie_Reject = Utilites.aFLocalizedString("RA_cookie_reject")
    static let Cookie_Primary_Description_Paragraph = Utilites.aFLocalizedString("RA_cookie_description")
    static let Cookie_Secondary_Description_Paragraph = Utilites.aFLocalizedString("RA_cookie_what_text_description")
    static let COOKIE_VIEWCONTROLLER_ID = "CookieConsentControllerID"
    static let COOKIE_STORYBOARD_ID = "CookieConsent"
    static let Cookie_Consent_HyperLink = SETTINGS_CUSTOMCELL_TEXT
    static let ABTest_Consent_Type = "firebaseConsent"
    static let Cloud_Logging_Consent_Type = "AIL_CloudConsent"
    static let Click_Stream_Consent_Type = "AIL_ClickStream"
    static let Cookie_Consent_Navigation_Title = Utilites.aFLocalizedString("RA_cookie_nav_title")

    // Screen Title
    static let TEST_DEMOAPP_SCREEN_TITLE = "Test Demo Apps"
    static let SLEEP_OVERVIEW_SCREEN_TITLE = "Sleep Overview"


}

