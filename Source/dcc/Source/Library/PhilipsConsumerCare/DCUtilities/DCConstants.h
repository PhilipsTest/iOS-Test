//
//  DCConstants.h
//  DigitalCare
//
//  Created by sameer sulaiman on 10/12/14.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCUtilities.h"

// Constatnts

static NSString *const kContactUs = @"Contact us";
static NSString *const kViewProductDetails = @"View product details";
static NSString *const kRegisterMyProduct = @"sign_into_my_philips";
static NSString *const kTitle = @"title";
static NSString *const kImage = @"image";
static NSString *const kLocalizeKey = @"LocalizedKey";
static NSString *const kIconName = @"IconName";
static NSString *const kFAQAnswerIdentifier = @"FAQWithAnswer";
static NSString *const kFAQCellIdentifier = @"FAQCell";
static NSString *const kQuestionCellIdentifier = @"QuestionCell";
static NSString *const kDCSupport = @"DCSupport";
static NSString *const kDCSupportView = @"DCSupportView";


static NSString *const kSocialSiteFacebook = @"SoacialSite_Facebook";
static NSString *const kSocialSiteTwitter = @"SoacialSite_Twitter";

static NSString *const kPostTOFacebook = @"PostTOFacebook";
static NSString *const kPostTOTwitter = @"PostTOTwitter";
static NSString *const kProductDetails = @"Norelco Shaver 9700 Series 9000 wet & dry electric shaver";

static NSString *const kDCLocationConsentKey = @"DCC_LocationConsent";

// Url's

static NSString *const kCDLSContactsURL = @"https://www.philips.com/prx/cdls/B2C/en_GB/CARE/PERSONAL_CARE_GR.querytype.(fallback)";
static NSString *const kChatTempURL = @"https://www.philips.co.uk/content/B2C/en_GB/support-home/support-contact-form.html";
static NSString *const kMailFormURL = @"https://www.philips.co.uk/content/B2C/en_GB/support-home/support-contact-form.html";
static NSString *const kProductReviewURL = @"https://www.philips.co.in/c-p/AT890_16/aquatouch-wet-and-dry-electric-shaver-with-aquatec-wet-dry-and-pop-up-trimmer/reviewandawards";
static NSString *const kBaseURL = @"https://www.philips.com/content/";


/*static NSString *const kChatURL = @"https://www.support.philips.com/support/contact/contact_page.jsp?userLanguage=en\u0026userCountry=gb";*/

static NSString *const kLocateNearYouURL = @"https://www.philips.co.in/c/retail-store-locator/page";

static NSString *kFacebookURL = @"https://www.facebook.com/";
static NSString *const emailSubject = @"My Airfryer";
static NSString *const emailBody = @"  I have just discovered the new Philips Airfryer.";



// Images

static NSString *const kFacebookIconImage = @"facebookIcon.png";
static NSString *const kTwitterIconImage = @"twitterIcon.png";
static NSString *const kChatImage = @"chatToUs";
static NSString *const kShareExpImage = @"shareUrExp";

static NSString *const kVideoLeftArrow = @"videoleftarrow";
static NSString *const kVideoRightArrow = @"videorightarrow";
static NSString *const kVideoButton = @"videobutton";

static NSString *const kFacebookBtnImage = @"DC_FB";
static NSString *const kTwitterBtnImage = @"DC_Twitter";
static NSString *const kNOSUPPORT = @"NoSupportKey";

// Config Parameters List
static NSString *const kCallNumber = @"Call";
static NSString *const kError= @"Error";
static NSString *const kSupportConfiguration = @"supportScreenConfiguration";
static NSString *const kButtonBGColor = @"button_bg";
static NSString *const kButtonTitleColor = @"button_text_color";
static NSString *const kRegisterButtonBGColor = @"buttonRegister_bg";
static NSString *const kTextColor = @"textColor";
static NSString *const kNavigationBarColor = @"navBar_color";
static NSString *const kNavBarBackButtonColor = @"navBarBackButton_color";
static NSString *const kNavBarHomeImage = @"navBarHamburgerIcon_image";
static NSString *const kURLChat = @"url_chat";
static NSString *const kURLRateApp = @"url_rateApp";
static NSString *const kURLLocation = @"url_location";
static NSString *const kFacebookPage = @"facebook_page";
static NSString *const kTwitterPage = @"twitter_page";
static NSString *const kSupportEmailId =@"philipscare@philips.com";
static NSString *const kEmailSubject = @"emailSubject";
static NSString *const kEmailBody = @"emailBody";
static NSString *const kCDLSProduct = @"cDLS_Product";
static NSString *const kFacebook = @"facebook";
static NSString *const kTwitter = @"twitter";
static NSString *const kLinkedIn = @"linkedIn";
static NSString *const kGoogle = @"google";

// Support Screen Constants

#define kRowSpacing 10.0
#define kLastRowSpacing 40.0
#define kSupportHeaderHeight 85.0
#define kSupportRowHeight 48.0
#define kSupportViewCornerRadius 2.0f
#define kTweetCharCount 140

// Font Constants

#define  kFontTwelve 12.0
#define  kFontTwentyOne 21.0
#define  kFontFourteen 14.0

#define kNoNetworkStatus -1009

// State Handlers

typedef enum ParserType
{
  kContactsParser =0,
  kPrxParser =1,
  kCategoryParser =2,
} DCParserType;

typedef enum{
    DCDEFAULT,
    DCEMAIL,
    DCFACEBOOK,
    DCTWITTER,
    DCLIVECHAT,
    DCPRODUCTINFO,
    DCPRODUCTMANUAL,
    DCPRODUCTREVIEW,
    DCFAQDETAILS
}DCWebViewType;

//shared instance

#define SharedInstance [[DCPluginManager sharedInstance] configData]
#define ServiceDiscoveryDict [DCPluginManager sharedInstance].serviceiscoveryURLsDictionary

//Timeout value on a HTTP request and number of retries after failure.
#define kRequestTimeoutInterval 45.0
#define kNumOfRetries  0
#define kFacebookAvailable 

// HTTP Methods

static NSString *const kHttpMethodGet =  @"GET";
static NSString *const kHttpMethodPost = @"POST";
static NSString *const kHttpMethodPut  = @"PUT";
static NSString *const kHttpMethodDelete = @"DELETE";

//iOS Version Check Start
#define iOSVersion [[UIDevice currentDevice].systemVersion floatValue]

// Log

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...) do {} while (0);
#endif

//iOS Version Check End

//Macro for getting the localized string for the given key

#define StoryboardBundle [NSBundle bundleForClass:DCUtilities.class]

#define LOCALIZE(key) [key isEqualToString:NSLocalizedStringFromTableInBundle(key,nil,StoryboardBundle,@"Localized string not available")]? NSLocalizedString(key, @"Localized string not available"): NSLocalizedStringFromTableInBundle(key,nil,StoryboardBundle,@"Localized string not available")

// Localization file mapping keys

static NSString *const KDescription = @"img_description";
static NSString *const KSendUsMessage = @"send_us_message";
static NSString *const KHowCanWeHelp = @"how_can_we_help";
static NSString *const KContactUs = @"ContactUs";
static NSString *const KViewProductInformation = @"ViewProductInformation";
static NSString *const KReadFAQs = @"ReadFAQs";
static NSString *const KTellUsWhatYouThink = @"TellUs";
static NSString *const KShareExperience = @"ShareYourExperiences";
static NSString *const KRegisterYourProduct = @"RegisterYourProduct";
static NSString *const KChangeSelectedProduct = @"Change_Selected_Product";
static NSString *const KSupport = @"actionbar_title_support";
static NSString *const KFrequentlyAskedQuestions = @"faq";
static NSString *const kQuestionAndAnswerTitle = @"FAQAnswerTitle";
static NSString *const KGetDirections = @"get_directions";
static NSString *const KLogInWithYourSocialMediaAccount = @"login_to_social_media";
static NSString *const KOnTwitter = @"twitter";
static NSString *const KOnFacebook = @"facebook";
static NSString *const KOnLinkedIn = @"linkedin";
static NSString *const KOnGooglePlus = @"googleplus";
static NSString *const KOrLogInWithMyPhilipsAccount = @"login_with_philips_account";
static NSString *const KEmailAddress = @"email";
static NSString *const KPassword = @"password";
static NSString *const KSignintoMyPhilips = @"sign_into_my_philips";
static NSString *const KIforgotmypassword = @"forgot_my_password";
static NSString *const KCreateAccount =  @"create_account";
static NSString *const KDateOfPurchase = @"date_of_purchase";
static NSString *const KDay = @"day";
static NSString *const KMonth = @"month";
static NSString *const KYear = @"year";
static NSString *const KReceipt = @"receipt";
static NSString *const KTakeAPhoto = @"take_a_photo";
static NSString *const KRegister = @"register";
static NSString *const KSerialNumber = @"serial_number";
static NSString *const KThankYou = @"thank_you";
static NSString *const KYourProductWasRegistered = @"product_registered";
static NSString *const KEnjoyYourExtendedWarrantyPeriod = @"enjoy_extended_warranty";
static NSString *const KBackToSupport = @"back_to_support";
static NSString *const KLoading = @"loading";
static NSString *const KPleaseWait = @"please_wait";
static NSString *const KContactUsWithColumn = @"contact_us";
static NSString *const KOpeningHours = @"opening_hours";
static NSString *const KSendEmail = @"send_email";
static NSString *const KCall = @"call_number";
static NSString *const KChatWithPhilips = @"chat_with_philips";
static NSString *const KLiveChat = @"live_chat";
static NSString *const KChatDesc = @"chat_desc";
static NSString *const KYourMessageHasBeenSendToPhilips = @"message_sent_to_philips";
static NSString *const KChatnow = @"chat_now";
static NSString *const KNoThanks = @"no_thanks";
static NSString *const KOpenInteractiveManual = @"product_open_manual";
static NSString *const KDownloadProductManual = @"productDownloadManual";
static NSString *const KProductInformationPhilips = @"productInformationOnWebsite";
static NSString *const KSignInToMyPhilips = @"rate_philips_buttontext";
static NSString *const KLogInToTwitter = @"twitter_login_header";
static NSString *const KLogin = @"login";
static NSString *const KUsername =  @"twitter_login_hint_username";
static NSString *const KTwitterLoginPassword = @"twitter_login_hint_password";
static NSString *const KTwitterLogo = @"twiiter_login_logo_description";
static NSString *const KFrom = @"from";
static NSString *const KCancel = @"cancel";
static NSString *const KPost = @"post";
static NSString *const KSend = @"send";
static NSString *const KLogInToFacebook = @"facebook_login_header";
static NSString *const KcanYouHelpMeWithMy = @"SocialSharingPostTemplateText";
static NSString *const KTakePhoto = @"take_photo";
static NSString *const KChooseFromLibrary = @"choose_from_library";
static NSString *const KReply = @"reply";
static NSString *const KForward = @"forward";
static NSString *const KPrint = @"print";
static NSString *const KNONetwork = @"NoNetworkKey";
static NSString *const kERRORTITLE = @"ErrorKey";
static NSString *const kNOMAILBOX = @"NoMailBox";
static NSString *const KNoTwitterAccounts = @"NoTwitterKeY";
static NSString *const kSENDEMAILKEY = @"SendUsAnEmailKey";
static NSString *const KNoTwitterAccountDesc = @"NoTwitterConfigure";
static NSString *const KSettings = @"SettingsKey";
static NSString *const KOk = @"OK";
static NSString *const KNoFacebookAccounts = @"No Facebook Accounts";
static NSString *const KNoFacebookAccountsDesc = @"Please login with valid facebook credentials.";
static NSString *const KMailNotConfigured = @"MailboxConfigureKey";
static NSString *const KMailSaved = @"MailSavedKey";
static NSString *const KMailCancelled = @"MailCancelledKey";
static NSString *const KMailSuccessful = @"MailSentKey";
static NSString *const KMailFailed = @"MailFailKey";
static NSString *const KContactPhilips = @"ContactPhilipsKey";
static NSString *const KNOPermision = @"Permission not granted";
static NSString *const KPostedSuccessfully = @"PostKey";
static NSString *const kREQUIREDFIELDVALIDATIONKEY = @"EmptyField_ErrorMsg";
static NSString *const kEMAILVALIDATIONKEY = @"kemailFieldErrorText";
static NSString *const kNoServiceAvailable = @"Service Not Available";
static NSString *const KRemovePhoto = @"remove_photo";
static NSString *const KCharactersLeft = @"characters_left";

static NSString *const kSelectedProductKey= @"isProductSelected";
static NSString *const kSelectedProductCTN= @"selectedProductCTN";
static NSString *const kSelectedProductForCountryCTN= @"selectedProductCTNForCountry";

static NSString *const KShowAll = @"show_all";
static NSString *const KShowLess = @"show_less";

static NSString *const kFailLocation = @"Turn_On_Location_Service";
static NSString *const KCallNotSupported = @"Call_not_Supported";
static NSString *const kNOSERVICEURLAVAILABLE = @"No_Service_Url";
static NSString *const KNoProductInfoAvailable = @"No_Product_Information";

static NSString *const kTwitterAccessTitle = @"Allow_Acess_Twitter";

static NSString *const kDCLocationConsentText = @"dcc_location_consent_definition_text";
static NSString *const kDCLocationConsentDescriptionText = @"dcc_location_consent_definition_help_text";
static NSString *const kDCLocationConsentTitleText = @"dcc_location_consent_title";

//bazaarvoice keys
static NSString *const KReviewGuideLine = @"kGUIDELINEREADKEY";
static NSString *const KReviewPublish = @"kGUIDELINEFOLLOWKEY";
static NSString *const KReviewDos = @"kGUIDELINESFOCUSKEY";
static NSString *const KReviewDontsFirst = @"kGUIDELINEWRITINGKEY";
static NSString *const KReviewDontsSecond = @"kGUIDELINEPRICEKEY";
static NSString *const KReviewDontsThird = @"kGUIDELINENOTINCLUDEKEY";
static NSString *const KReviewOkGotIt = @"kGUIDELINEGOTKEY";
static NSString *const KProductReview = @"kWRITEREVIEWKEY";

static NSString *const kWRITEREVIEWKEY =@"kWRITEREVIEWKEY";
static NSString *const kRATETHISKEY =@"kRATEPRODUCTKEY";
static NSString *const kYOURREVIEWKEY =@"kYOURREVIEWKEYHEADING";
static NSString *const kPICKNICKNAMEKEY =@"kPICKNAMEKEY";
static NSString *const kYOUREMAIL =@"kYOUREMAILKEY";
static NSString *const kTERMSCONDITIONSKEY =@"kTERMSCONDITIONKEY";
static NSString *const kTERMSANDCONTIONSLINKKEY =@"kTERMSCONDITIONLINKKEY";
static NSString *const kWRITEHEREKEY =@"kWRITEREVIEWHEREKEY";
static NSString *const kPREVIEWTITLEKEY =@"kYOURREVIEWKEY";
static NSString *const kEVERYTHINGCORRECTKEY =@"kEVERYTHINGKEY";
static NSString *const kRATINGKEY =@"kRATINGKEY";
static NSString *const kREVIEWSUMMARYKEY =@"kREVIEWSUMMARYKEY";
static NSString *const kREVIEWTEXTKEY =@"kREVIEWKEY";
static NSString *const kNICKNAMEKEY =@"kNICKNAMEKEY";
static NSString *const kEMAILREVIEWKEY =@"kEMAILREVIEWKEY";
static NSString *const kREVIEWTHANKSKEY =@"kREVIEWTHANKSKEY";
static NSString *const kREVIEWRECEIVEDKEY =@"kRECEIVEDREVIEWKEY";
static NSString *const kREVIEWACKNOWLEDGEKEY =@"kTHANKSREVIEWKEY";
static NSString *const kBACKSUPPORTKEY =@"kBACKSUPPORTKEY";
static NSString *const kREALNAMEPLACEHOLDERKEY =@"kREALNAMEKEY";
static NSString *const kEMAILPLACEHOLDERKEY =@"kACCESSKEY";
static NSString *const kBUTTONPREVIEWKEY =@"kPREVIEWKEY";
static NSString *const kYOURREVIEWPLACEHOLDERKEY =@"kREVIEWSUMMARYPLACEHOLDERKEY";
static NSString *const kSUBMITREVIEWKEY =@"kSUBMITREVIEWKEY";

//CONFIGURATIONS COMMON KEY
static NSString *const kCONFIGFILENAME = @"DigitalCareConfiguration";
static NSString *const kCONFIGTYPE = @"plist";
static NSString *const kTHEMECONFIG = @"UITheme";
static NSString *const kSUPPORTCONFIG = @"MainMenu";
static NSString *const kPRODUCTCONFIG = @"ProductMenu";
static NSString *const kSOCIALSERVICEPROVIDERS = @"SocialServiceProviders";
static NSString *const kSOCIALCONFIG = @"ContactUsMenu";
static NSString *const kFEEDBACKCONFIG = @"FeedbackMenu";
static NSString *const kENVIRONMENTVARIABLES = @"Environment";
static NSString *const kSERVICEDISCOVERYURLS = @"ServiceDiscovery";

//UITHEME CONFIGURATIONS KEY
static NSString *const kSCREENBACKGROUNDCOLOR = @"ScreenBackgroundColor";
static NSString *const KNAVIGATIONBARTITLEREQUIRED= @"NavigationBarTitleRequired";
static NSString *const kBACKGROUNDIMAGE = @"BackGroundImage";
static NSString *const kIpadLandscapePadding = @"IpadLandscapePadding";


//FEEDBACK CONFIGURATION KEY
static NSString *const kAPPSTOREID = @"AppstoreId";
static NSString *const kPRODUCTIONENVIRONMENT = @"ProductionEnvironment";

//CONTACT US CONFIGURATION KEY
static NSString *const kLIVECHATURL = @"LiveChatUrl";
static NSString *const kLIVECHATREQUIRED = @"LiveChatRequired";
static NSString *const kTWITTERPAGE = @"TwitterPage";
static NSString *const kFACEBOOKPRODUCTPAGE = @"FacebookProductPage";
static NSString *const kFACEBOOKPRODUCTPAGEID = @"FacebookProductPageID";

//Base URL
static NSString *const kAppReviewBaseURL = @"https://itunes.apple.com/app/";

//Common keyword
static NSString *const kCOUNTRYCHINA = @"CN";
static NSString *const kNODATAKEY = @"NoDataKey";
static NSString *const kOKKEY = @"OKKey";
static NSString *const kCOMMONERRORFORRESPONSE = @"kCOMMONERRORFORRESPONSE";

//user default key for previous page

static NSString *const kPREVIOUSPAGEKEY = @"previousPage";

//LIBRARY VERSION KEY
static NSString *const kDCINFOFILE = @"DCInfo";

//default URL
static NSString *const defaultBaseUrl = @"www.philips.com";


static NSString *const INKEY = @"reviewandawards";
static NSString *const USKEY = @"reviewandawards";
static NSString *const FRKEY = @"rÈcompenses";
static NSString *const DEKEY = @"testberichte";
static NSString *const KRKEY = @"reviewandawards";
static NSString *const NLKEY = @"reviewenawards";
static NSString *const BRKEY = @"premios-e-reviews";
static NSString *const RUKEY = @"reviewandawards";
static NSString *const TWKEY = @"reviewandawards";
static NSString *const ITKEY = @"reviewandawards";
static NSString *const CNKEY = @"reviewandawards";
static NSString *const PLKEY = @"recenzje-i-nagrody";
static NSString *const ESKEY = @"valoracionesyresenas";
static NSString *const HKKEY = @"reviewandawards";
static NSString *const DKKEY = @"priser-og-anmeldelser";
static NSString *const FIKEY = @"palkinnot-ja-arvostelut";
static NSString *const NOKEY=  @"priser-og-anmelselser";
static NSString *const SEKEY = @"recensioner-och-utmarkelser";
static NSString *const GBKEY = @"reviewandawards";
static NSString *const KEY = @"reviewandawards";

//BAZAARVOICE
static NSString *const DCTERMSWEBVIEWKEY = @"DCTermsAndConditionsWebView";
static NSString *const TERMSANDCONDITONSURL = @"%@/content/7543b-%@/termsandconditions.htm?origin=15_global_en_%@-app_%@-app";
static NSString *const REVIEWPREVIEWIDENTIFIER = @"ProductReviewPreview";
static NSString *const PRODUCTREVIEWIDENTIFIER = @"ProductReviewForm";
static NSString *const EMAILVALIDATIONEXPRESSION = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
static NSString *const STARRATING = @"StarRating";
static NSString *const REVIEWSUMMARY = @"ReviewSummary";
static NSString *const REVIEW = @"Review";
static NSString *const NICKNAME = @"Nickname";
static NSString *const EMAIL = @"Email";
static NSString *const TERMSANDCONDITION = @"TersmAndConditions";
static NSString *const BRANDREVIEW = @"brand-reviews";
static NSString *const WWW = @"www";
static NSString *const EMPTYSTRING = @"";

//View product details

static NSString *const kImageThumbNail = @"defaultProductImage";

static NSString *const kNoProductErrorMessage = @"NOPRODUCTSERROR";

//Tagging constants

static NSString *const kHomePage = @"digitalcare:home";
static NSString *const kProductDetailsPage = @"digitalcare:productdetails";
static NSString *const kProductWebsite = @"digitalcare:productdetails:website";
static NSString *const kProductManual = @"digitalcare:productdetails:manual";
static NSString *const kFaqPage = @"digitalcare:faq";
static NSString *const kFAQAnswerPage = @"digitalcare:faq:questionandanswer";

static NSString *const kContactUSPage = @"digitalcare:contactus";
static NSString *const kRateThisAppPage = @"digitalcare:ratethisapp";
static NSString *const kProductRegistrationPage = @"digitalcare:productregistration";
static NSString *const kContactTwitterPage = @"digitalcare:contactus:twitter";
static NSString *const kContactFacebookPage = @"digitalcare:contactus:facebook";
static NSString *const kContactLiveChatPage = @"digitalcare:contactus:livechat";
static NSString *const kContactLiveChatNowPage = @"digitalcare:contactus:livechat:chatnow";
static NSString *const kReviewPage = @"digitalcare:ratethisapp:writeReview";
static NSString *const kReviewWrittingPage =@"digitalcare:ratethisapp:guideLines:writeReview";
static NSString *const kReviewPreviewPage =@"digitalcare:ratethisapp:guideLines:writeReview:preview";
static NSString *const kReviewThanksPage =@"digitalcare:ratethisapp:guideLines:writeReview:preview:thankYou";

static NSString *const kContactEmailPage = @"digitalcare:contactus:email";
/* Context data */
static NSString *const kTIMESTAMP = @"timestamp";
static NSString *const kPREVIOUSPAGE =@"previousPagename";
static NSString *const kAPPOS = @"app.os";
static NSString *const kLANGUAGE = @"locale.language";
static NSString *const kCOUNTRY = @"locale.country";
static NSString *const kCURRENCY = @"locale.currency";
static NSString *const kAPPVERSION = @"app.version";
static NSString *const kCOMPONENTVERSION = @"componentVersion";
static NSString *const kBUNDLEVERSION = @"CFBundleVersion";
static NSString *const kCFBUNDLENAME = @"CFBundleName";
static NSString *const kDIGITALCAREVERSION = @"digitalcareVersion";
static NSString *const kAPPNAME = @"app.name";
static NSString *const kAPPID = @"appsId";
static NSString *const kIOS = @"ios";
/* life cycle */
static NSString *const kBACKGROUND = @"Background";
static NSString *const kFOREGROUND = @"Foreground";

/*Error track */
static NSString *const kERRORRESPONSE = @"Error response from server";
static NSString *const kNETWORKERROR = @"Error connecting to network";
static NSString *const kERRORLOADING = @"Error in loading";
static NSString *const kEMAILNOTCONFIGURED = @"Cannot send mail from this device";
static NSString *const kNOTWITTER = @"No twitter account configured";
static NSString *const kNOFACEBOOK = @"No facebook account configured";
static NSString *const kPRODUCTIMAGE = @"product image";
static NSString *const kUSERFEEDBACK = @"Feedback from the user";
static NSString *const kFBLOADINGERROR = @"Facebook loading error";
static NSString *const kNOSERVICECENTER = @"No service centers found";
static NSString *const kNOMATCHINGLOCATION = @"No matching service centers";



/*track action */
static NSString *const kSetError = @"setError";
static NSString *const kUserError = @"userError";
static NSString *const kTechnicalError = @"technicalError";
static NSString *const kPHOTO = @"photo";
static NSString *const kExitLinkName = @"exitLinkName";
static NSString *const kExitLink = @"exitLink";
static NSString *const kReceiptPhoto = @"receiptPhoto";
static NSString *const kSetAppStatus = @"setAppStatus";
static NSString *const kAppStatus = @"appStatus";
static NSString *const kSocialType = @"socialType";
static NSString *const kSocialItem = @"socialItem";
static NSString *const kSocialShare = @"socialShare";
static NSString *const kServiceRequest = @"serviceRequest";
static NSString *const kServiceChannel = @"serviceChannel";
static NSString *const kCall = @"call";
static NSString *const kCHATANALYTICS = @"chat";
static NSString *const kEmail = @"email";
static NSString *const kfaq = @"faq";
static NSString *const kFACEBOOK = @"Facebook";
static NSString *const kTWITTER = @"Twitter";
static NSString *const kServiceSatisfaction = @"serviceSatisfaction";
static NSString *const kWriteProductReview = @"writeProductReview";
static NSString *const kRateThisApp = @"rateThisApp";

/*track action Find Philips near you */
static NSString *const kSENDDATA = @"sendData";
static NSString *const kGETLOCATIONDIRECTIONS = @"getLocationDirections";
static NSString *const kCALLLOCATION = @"callLocation";
static NSString *const kSPECIALEVENTS = @"specialEvents";
static NSString *const kSEARCHRESULT = @"searchTerm";
static NSString *const kNUMBEROFSEARCHRESULTS = @"numberOfSearchResults";
static NSString *const kLOCATIONVIEW = @"locationView";

/*bazaarvoice */
static NSString *const kREVIEWRATING = @"starRating";
static NSString *const kREVIEWERNAME = @"reviewerName";
static NSString *const kREVIEWSUM = @"reviewSummary";
static NSString *const kREVIEWEREMAIL = @"reviewerEmail";

/*view product details */
static NSString *const kURL = @"url";

static NSString *const kVIDEOEND =@"videoEnd";
static NSString *const KVIDEONAME =@"videoName";
static NSString *const KVIDEOSTART =@"videoStart";


//Service Discovery constants

static NSString *const kPRXCATEGORY = @"cc.prx.category";
static NSString *const kSDEMAILFORMURL = @"cc.emailformurl";
static NSString *const KATOS = @"cc.atos";
static NSString *const kCDLS = @"cc.cdls";
static NSString *const kPRODREVIEWURL = @"cc.productreviewurl";
static NSString *const kSDFACEBOOKURL = @"cc.facebookurl";
static NSString *const kSDTWITTERURL = @"cc.twitterurl";
static NSString *const kSDLIVECHATURL = @"cc.livechaturl";
//static NSString *const kHomePage = @"digitalcare:home";
