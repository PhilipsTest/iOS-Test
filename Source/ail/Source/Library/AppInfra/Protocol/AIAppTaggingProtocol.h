//
//  AIAppTaggingProtocol.h
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import "AITaggingError.h"

@protocol ConsentHandlerProtocol;

#define kAilTaggingNotification @"ail.tagging.notification"
#define kAilTaggingPageName     @"ailPageName"
#define kAilTaggingActionName   @"ailActionName"

/**
  An enum type.
  The possible privacy statuses.
  @since 1.0.0
 */
typedef NS_ENUM(NSUInteger,AIATPrivacyStatus)
{
    /**
     hits are sent immediately
     */
    AIATPrivacyStatusOptIn = 1,
    /**
      hits are discarded. Only App Lifecycle data is tracked
     */
    AIATPrivacyStatusOptOut = 2,
    /**
     If your report suite is timestamp-enabled, hits are saved until the privacy status changes to opt-in (then hits are sent) or opt-out (then hits are discarded). If your report suite is not timestamp-enabled, hits are discarded until the privacy status changes to opt in.
     */
    AIATPrivacyStatusUnknown = 3
};

/**
 Enum to select SocialMedia
 @since 1.1.0
 */
typedef NS_ENUM (NSUInteger, AIATSocialMedia)
{
    /**
      enum option for facebook
     */
    AIATSocialMediaFacebook,
    /**
     enum option for twitter
     */
    AIATSocialMediaTwitter,
    /**
     enum option for mail
     */
    AIATSocialMediaMail,
    /**
     enum option for air drop
     */
    AIATSocialMediaAirDrop
};

/**
Enum holding tagging error categories
@since @since 2004.0.0
*/
typedef NS_ENUM (NSUInteger, AITaggingErrorCategory)
{
    /**
     enum option for Technical error
    */
    AITaggingTechnicalError,
    /**
     enum option for user error
    */
    AITaggingUserError,
    /**
     enum option for Information error
    */
    AITaggingInformationalError,
};

/**
 A protocol declaring methods to tag application events like action and navigation
 @since 1.0.0
 */
@protocol AIAppTaggingProtocol <NSObject>

/**
 *  This method creates and returns a tagging wrapper object which can be used for tracking actions and navigation.
 *
 *  @param componentId      Identifier of the requesting component
 *  @param componentVersion Version of the requesting component
 *
 *  @return Returns an object that conforms to 'AITaggingProtocol' protocol.
 *  @since 1.0.0
 */
- (nonnull id<AIAppTaggingProtocol>)createInstanceForComponent:(nonnull NSString *)componentId
                                      componentVersion:(nonnull NSString *)componentVersion;

/**
 sets the privacy status option either  AIATPrivacyStatusOptIn or AIATPrivacyStatusOptOut or AIATPrivacyStatusUnknown based on the user consent,
 @param privacyStatus privacy status based on users consent
 @since 1.0.0
 */
- (void)setPrivacyConsent:(AIATPrivacyStatus)privacyStatus;


/**
 get the privacy status option based on the user consent
 @return privacy status option based on the user consent
 @since 1.0.0
 */
- (AIATPrivacyStatus)getPrivacyConsent;

/**
 Track pages with page name and a pair of key value to be tracked
 @param pageName name of the page
 @param key key for the object to be tracked
 @param value value to be tracked
 @since 1.0.0
 */
- (void)trackPageWithInfo:(nonnull NSString*)pageName paramKey:(nullable NSString*)key andParamValue:(nullable id)value;

/**
 Track pages with page name and multiple key values to be tracked
 @param pageName name of the page
 @param paramDict dictionary of key-values to be tracked
 @since 1.0.0
 */
- (void)trackPageWithInfo:(nonnull NSString*)pageName params:(nullable NSDictionary*)paramDict;

/**
 Track button action with action name and a pair of key value to be tracked
 @param actionName name of the action
 @param key key for the object to be tracked
 @param value value to be tracked
 @since 1.0.0
 */
- (void)trackActionWithInfo:(nonnull NSString*)actionName paramKey:(nullable NSString*)key andParamValue:(nullable id)value;

/**
 Track button action with action name and a pair of key value to be tracked
 @param actionName name of the action
 @param paramDict dictionary of key-values to be tracked
 @since 1.0.0
 */
- (void)trackActionWithInfo:(nonnull NSString*)actionName params:(nullable NSDictionary*)paramDict;

/**
 Track Video started with a videoName
 @param videoName name of the video file
 @since 1.0.0
 */
- (void)trackVideoStart:(nonnull NSString*)videoName;

/**
 Track Video End  with a videoName
 @param videoName name of the video file
 @since 1.0.0
 */
- (void)trackVideoEnd:(NSString*_Nonnull)videoName;

/**
 Track social sharing with social media like facebook, twitter, mail etc…
 @param socialMedia Type of socail media through user sharing message
 @param sharedItem item to be shared string
 @since 1.0.0
 */
- (void)trackSocialSharing:(AIATSocialMedia)socialMedia withItem:(nonnull NSString*)sharedItem;

/**
 *  sets PreviousPage name
 *
 *  @param pageName name of the previous page which has to be set
 * @since 1.0.0
 */
- (void)setPreviousPage:(NSString *_Nonnull)pageName;

/**
 tracks the start of a timed event
 @param action a required NSString value that denotes the action name to track.
 @param data optional dictionary pointer containing context data to track with this timed action.
 @note This method does not send a tracking hit. If an action with the same name already exists it will be deleted and a new one will replace it.
 @since 1.0.0
 */
- (void) trackTimedActionStart:(nullable NSString *)action data:(nullable NSDictionary *)data;

/**
 Tracks the end of a timed event
 @param action a required NSString pointer that denotes the action name to finish tracking.
 @param block optional block to perform logic and update parameters when this timed event ends, this block can cancel the sending of the hit by returning NO.
 @note This method will send a tracking hit if the parameter logic is nil or returns YES.
 @since 1.0.0
 */
- (void) trackTimedActionEnd:(nullable NSString *)action
                       logic:(nullable BOOL (^)(NSTimeInterval inAppDuration, NSTimeInterval totalDuration, NSMutableDictionary* __nullable data))block;

/**
 Track external link open
 @param url external url link
 @since 1.0.0
 */
-(void)trackLinkExternal:(nullable NSString*)url;


/**
 Track filedownload
 @param filename downloading file name
 @since 1.0.0
 */
-(void)trackFileDownload:(nullable NSString*)filename;

/**
 setPrivacyConsentForSensitiveData
 @param consent privacy consent is a boolean param
 @since 1.0.0
 */
-(void)setPrivacyConsentForSensitiveData:(BOOL)consent;

/**
 getPrivacyConsentForSensitiveData
 @return  privacy consent
 @since 1.0.0
 */
-(BOOL)getPrivacyConsentForSensitiveData;

/**
 Retrieves the analytics tracking identifier
 @return an NSString value containing the tracking identifier
 @note This method can cause a blocking network call and should not be used from a UI thread.
 @since 1.0.0
 */
-(nonnull NSString*)getTrackingIdentifier;

/**
 Retrieves the handler which handles Click Stream Consent
 ClickStreamConsentHandler is used for storing/fetching Tagging Consents in Adobe
 @return This method returns the Click Stream Consent Handler.
 @since 2018.1.0
 */
-(id<ConsentHandlerProtocol> _Nonnull)getClickStreamConsentHandler;

/**
 This gives the Click Stream key without which ClickStreamConsentHandler will not function.
 @note Only Consent Definitions containing this key will be considered for Click Stream Handling.
 If no such key is found then the app will crash.
 @return a NSString value which should be used as Identifier for Click Stream Consent
 @since 2018.1.0
 */
-(nonnull NSString*)getClickStreamConsentIdentifier;

/**
 Retrieves the analytics visitor ID appended to URL
 @param url URL link to which visitor id would be appended
 @return a NSURL value with visitor id appended to it
 @note This method can cause a blocking network call and should not be used from a UI thread.
 @since 1904.0.0
 */
@optional
-(nonnull NSURL *)getVisitorIDAppendToURL: (nonnull NSURL *)url;

/**
Track error action with info
@param errorCategory the tagging error category
@param taggingError the tagging error instance
@since 2004.0.0
*/
- (void)trackErrorAction:(AITaggingErrorCategory)errorCategory taggingError: (nonnull AITaggingError *) taggingError;

/**
Track error action with info
@param errorCategory  the tagging error category
@param taggingError  the tagging error instance
@param paramDict   dictionary of key-values to be tracked
@since 2004.0.0
*/
- (void)trackErrorAction:(AITaggingErrorCategory)errorCategory params:(nullable NSDictionary*)paramDict taggingError: (nonnull AITaggingError *) taggingError;

@end
