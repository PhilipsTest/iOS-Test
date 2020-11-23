//
//  DIUser.h
//  DIUser
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DIRegistrationConstants.h"
#import "URRegistrationProtocols.h"
#import "URMarketingConsentHandler.h"

@import PlatformInterfaces;
/**
 *  A wrapper class that provides all the User Identity and Authentication Management services for your application.
 *
 *  @since 1.0.0
 */
@interface DIUser : NSObject

#pragma mark - User Properties and Statuses
#pragma mark -


@property (nonatomic, strong, nullable) NSString *locale;

/**
 *  Email id of logged in User.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSString *email;

/**
 *  Mobile number of logged in user. Mobile number is only supported for China.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSString *mobileNumber;

/**
 *  Identifier of the user. Returns either Mobile number or email whichever is present. Mobile number is returned if both are present.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSString *userIdentifier;

/**
 *  Given/First name of logged in user.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSString *givenName;

/**
 *  Surname/FamilyName of logged in user.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSString *familyName;

/**
 *  isOlderThanAgeLimit indicates if logged in user has accepted to be older than minimum age limit required by application.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) BOOL isOlderThanAgeLimit;

/**
 *  receiveMarketingEmails indicates if logged in user has opted to receive marketing emails.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) BOOL receiveMarketingEmails;

/**
 *  marketingConsentTimestamp indicates the timestamp when the user has opted to receive marketing emails.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSDate *marketingConsentTimestamp;
/**
 *  isEmailVerified indicates if current user's email is verified. User (non-China) is not completely logged in if their email is not verified.
 *
 *  @since 1.0.0
 */


@property (nonatomic, assign, readonly) BOOL isEmailVerified;

/**
 *  isMobileNumberVerified indicates if current user's mobile number is verified via OTP. Only applicable for China users. User is not completely logged in if mobile number is not verified.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) BOOL isMobileNumberVerified;

/**
 *  isVerified indicates if user's account is verified either via email or mobile number. Mobile number verification is applicable only to China users.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) BOOL isVerified;

/**
 *  consumerInterests returns consumer interests stored in backend by applications.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSArray *consumerInterests;

/**
 *  consents returns all the user consents stored in Janrain Backend. Currently applicable only for COPPA Consents.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSArray *consents;

/**
 *  country returns selected country of user which was stored under primaryAddress of user during account creation.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSString *country;

/**
 *  prefreredLanguge returns language selected during account creation.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSString *language;

/**
 *  isLoggedIn indicates user's login state. This is one and only source of truth to know if user is actually logged in. Because user fields and state are share among components and application, it is encouraged to check user's login state before reading/updating any user fields.
 *
 *  @since 1.0.0
 *  @deprecated 1804.0
 */

@property (readonly, nonatomic, assign)BOOL isLoggedIn __attribute__((deprecated("isLoggedIn has been deprecated in 1804 please use userLoggedInState instead")));

/**
 *  userLoggedInState indicates user's state while logging in. Based on the states, it is decided what actions need to be taken and whether user is logged in or not.
 *
 *  @since 1804.0
 */
@property (nonatomic, assign, readonly) UserLoggedInState userLoggedInState;

/**
 *  gender of currently logged in user. `UserGenderNone` is returned if user is not logged in or no information on gender can be found.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) UserGender gender;

/**
 *  birthday of currently logged in user.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly, nullable) NSDate *birthday;

/**
 *  User personal consent consent handler.
 *
 *  @since 2001.1.0
 */
@property (nonatomic, strong, readonly) URPersonalConsentHandler * _Nonnull personalConsentHandler;


+ (nonnull instancetype) getInstance;

#pragma mark - Listeners Handling Methods
#pragma mark -
/**
 *  Adds a listener to get callbacks for user authentication and janrain flow download call backs. Adding a listener more than once will not have any effect.
 *
 *  @param listener Object of the class that wants to get the callbacks and implements specified protocols.
 *
 *  @since 1.0.0
 */
- (void)addUserRegistrationListener:(nonnull id<UserRegistrationDelegate, JanrainFlowDownloadDelegate>)listener;

/**
 *  Adds a listener to get callbacks for user details update and refetch. Adding a listener more than once will not have any effect.
 *
 *  @param listener Object of the class that wants to get the callbacks and implements specified protocols.
 *
 *  @since 1.0.0
 */
- (void)addUserDetailsListener:(nonnull id<UserDetailsDelegate>)listener;

/**
 *  Adds a listener to get callbacks for user session refresh activity. Adding a listener more than once will not have any effect.
 *
 *  @param listener Object of the class that wants to get the callbacks and implements specified protocols.
 *
 *  @since 1.0.0
 */
- (void)addSessionRefreshListener:(nonnull id<SessionRefreshDelegate>)listener;

/**
 *  Removes object from list of listeners once it does not need to be informed about user authentication activities. Removes an object that was not added will not have any effect.
 *
 *  @param listener Object that was listening for user authentication activities.
 *
 *  @since 1.0.0
 */
- (void)removeUserRegistrationListener:(nullable id<UserRegistrationDelegate, JanrainFlowDownloadDelegate>)listener;

/**
 *  Removes object from list of listeners once it does not need to be informed about user details update and refetch. Removing an object that was not added will not have any effect.
 *
 *  @param listener Object that was listening for user update and refetch activities.
 *
 *  @since 1.0.0
 */
- (void)removeUserDetailsListener:(nullable id<UserDetailsDelegate>)listener;

/**
 *  Removes object from list of listeners once it does not need to be informed about user's session refresh activities. Removing an object that was not added will not have any effect.
 *
 *  @param listener "Object that was listening for user update and refetch activities.
 *
 *  @since 1.0.0
 */
- (void)removeSessionRefreshListener:(nullable id<SessionRefreshDelegate>)listener;

#pragma mark - User Actions
#pragma mark -

/**
 *  This method is called to logout currently logged in user. User will be logged out of both Janrain and HSDP (if config provided) backends. This is an **asynchronous** call. Please implement appropriate `UserRegistrationDelegate` callbacks to be informed about success or failure of this action.
 *
 *  @since 1.0.0
 */
- (void)logout;

/**
 *  This method is called to refresh session/tokens of currently logged in user. Both Janrain and HSDP sessions will be refreshed. This is an **asynchronous** call. Please implement appropriate `SessionRefreshDelegate` callbacks to be informed about success or failure of this action.
 *
 *  @since 1.0.0
 */
- (void)refreshLoginSession;

/**
 *  Updates marketing opt-in of currently logged in user. This is an **asynchronous** call. Please implement appropriate `UserDetailsDelegate` callbacks to be informed about success or failure of this action.
 *
 *  @param reciveMarketingMails Indicates if user has opt-in or out of receiving marketing emails.
 *
 *  @since 1.0.0
 */
- (void)updateReciveMarketingEmail:(BOOL)reciveMarketingMails;

/**
 *  Updates gender and birthday of currently logged in user. This is an **asynchronous** call. Please implement appropriate `UserDetailsDelegate` callbacks to be informed about success or failure of this action.
 *
 *  @param gender   Gender value to be updated to.
 *  @param birthday Birthday to be added or updated to.
 *
 *  @since 1.0.0
 */
- (void)updateGender:(UserGender)gender withBirthday:(nonnull NSDate *)birthday;

/**
 *  Replaces exisitng consumer interests list with new list. If you want to add or remove a consumer interest to this list, please create new list from existing list by adding or removing one or more consumer interests and replace old list with new one. **Janrain SDK only supports replacing list as a way for update and hence the restiriction mentioned above.** This is an **asynchronous** call. Please implement appropriate `UserDetailsDelegate` callbacks to be informed about success or failure of this action.
 *
 *  @param newElements New list of consumer interests.
 *
 *  @discussion Most applications should not require to use consumer interests. Per our records, **Figaro** is only application using this. Do let us know, if your application is also using it.
 *  @since 1.0.0
 */
- (void)replaceConsumerInterest:(nonnull NSArray *)newElements;

/**
 *  Gets list of consumer interests by the _topicCommunicationKey_ for currently logged in user.
 *
 *  @param key topicCommunicationKey for which consumer interests are to be returned.
 *
 *  @discussion Most applications should not require to use consumer interests. Per our records, **Figaro** is only application using this. Do let us know, if your application is also using it.
 *
 *  @return consumerInterests of user for provided topicCommunicationKey.
 *  @since 1.0.0
 */
- (nullable NSArray *)getConsumerInterestForUser:(nonnull NSString *)key;

/**
 *  Refetches logged in user's latest profile from server. This is an **asynchronous** call. Please implement appropriate `UserDetailsDelegate` callbacks to be informed about success or failure of this action.
 *
 *  @discussion This is an expensive request given that user profile could be very big that includes large size profile image etc. Therefore, it is highly encouraged to call this only when it is must to display latest prfile details to user.
 *  @since 1.0.0
 */
- (void)refetchUserProfile;

/**
 *  This method is called to check if `PhilipsRegistration` has downloaded all the URLs, configurations and flows needed to serve API calls. This call will automatically retry if last try to download the flow has failed. So, do not call it too many times if it returns failure.
 *
 *  @param completion A block to be executed when it is determined that flow download has either failed or succeeded. Existance of error object indicates the success or failure.
 *
 *  @discussion Most applications need not use this API unless they are builiding their own UI. All `PhilipsRegistration` APIs already incorporate this call.
 *  @since 1.0.0
 */
- (void)checkIfJanrainFlowDownloadedWithCompletion:(void(^_Nonnull)(NSError * _Nullable flowDownloadError))completion;

/**
 *  This method is called to change currently selected country for the user. This call would redownload all the URLs, configurations and flows specific to selected country.
 *
 *  @param country              The newly selected country to be updated.
 *  @param completionHandler    A block that will be executed when country update has completed with either success or failure.
 *
 *  @discussion "Most applications need not use this API unless they are builiding their own UI. All `PhilipsRegistration` UI already incorporate this functionality.
 *  @since 1.0.0
 */
- (void)updateCountry:(nonnull NSString *)country withCompletion:(void(^ _Nullable)( NSError * _Nullable error))completionHandler;

/**
 *  This method is called to get current country code from ServiceDiscovery. ServiceDiscovery with try to determine the country if not already done. This call would download all the URLs, configurations and flows specific to selected country if not already done.
 *
 *  @param completion A block that will be executed when country reading has completed with either success or failure.
 *
 *  @discussion Most applications need not use this API unless they are builiding their own UI. All `PhilipsRegistration` UI already incorporate this functionality.
 *  @since 1.0.0
 */
- (void)countryCodeWithCompletion:(void(^ _Nonnull)(NSString * _Nullable countryCode, NSError * _Nullable error))completion;

/**
 *  Updates user's mobile number. Only available to China users. This is an **asynchronous** call. Please implement appropriate `UserRegistrationDelegate` callbacks to be informed about success or failure of this action.
 *
 *  @param mobileNumber The new mobile number to be updated in user's profile.
 *
 *  @discussion Most applications need not use this API unless they are builiding their own UI. All `PhilipsRegistration` UI already incorporate this functionality.
 *  @since 1.0.0
 */
- (void)updateMobileNumber:(nonnull NSString *)mobileNumber;

/**
 *  Adds recovery email to user's mobile number account. Only available to China users. This is an **asynchronous** call. Please implement appropriate `UserDetailsDelegate` callbacks to be informed about success or failure of this action."
 *
 *  @param recoveryEmail The email address to be added as recovery email to user's account.
 *
 *  @discussion Most applications need not use this API unless they are builiding their own UI. All `PhilipsRegistration` UI already incorporate this functionality.
 *  @since 1.0.0
 */
- (void)addRecoveryEmailToMobileNumberAccount:(nonnull NSString *)recoveryEmail;

/**
 *  Updates user's COPPA consent to indicate if user has accepted or declined the (first) COPPA consent.
 *
 *  @param accepted     Bool value to indicate consent was accepted or declined.
 *  @param completion   This block will be called when user consent has been updated or failed to update to server. Existance of error object indicates the success or failure.
 *
 *  @since 1.0.0
 */
- (void)updateUserConsent:(BOOL)accepted withCompletion:(void(^_Nullable)(NSError * _Nullable error))completion;

/**
 *  Updates user's COPPA consent approval to indicate if user has accepted or declined the (second) COPPA consent approval.
 *
 *  @param accepted     Bool value to indicate approval was accepted or declined.
 *  @param completion   This block will be called when user approval has been updated or failed to update to server. Existance of error object indicates the success or failure.
 *
 *  @since 1.0.0
 */
- (void)updateUserConsentApproval:(BOOL)accepted withCompletion:(void(^_Nullable)(NSError * _Nullable error))completion;

#pragma mark - Utility Method
#pragma mark -

/**
 *  Handles openURL call from other applications. Used for handling native social login like WeChat or Google+ that are executed via SafaraiServices or native social apps. Call this method from AppDelegate of your application from method of similar signature.
 *
 *  @param application  Application object received in AppDelegate.
 *  @param url          URL object received in AppDelegate.
 *  @param options      Options received in AppDelegate.
 *
 *  @return Bool value to indicate if `PhilipsRegistration` has been able to handle this request.
 *  @since 1.0.0
 */
+ (BOOL)application:(nonnull UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary *)options;

/**
 
 *  Handles hsdp login if the user is not loggedin to hsdp and have configured for skiphsdplogin to true
 *
 *  @param completion block gives success and error based on the authentication with hsdp
 *
 *  @since 1804.0
 */
- (void)authorizeWithHSDPWithCompletion:(void(^_Nullable)(BOOL success, NSError * _Nullable error))completion;

/**

 *  Indicates previous stored user data is available or not
 *
 *  @return BOOL value to indicate data availability
 *
 *  @since 2003.0
 */
- (BOOL)isPreviousStoredUserDataAvailable;

@end
