//
//  AIAppTagging.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import "AIAppTagging.h"
#import "AIClientComponent.h"
#import "AIAppTaggingWrapper.h"
#import <AdobeMobileSDK/ADBMobile.h>
#import "AppInfra.h"
#import "AIATUtility.h"
#import "AIUtility.h"
#import <AppInfra/AppInfra-Swift.h>
#import "AIInternalLogger.h"
#import "AIAppTaggingPrivacyStatus.h"
#define kSensitiveData @"tagging.sensitiveData"
#define kAppInfraGroup @"appinfra"
#define kPrivacyConsentSensitiveData @"com.philips.cdpp2.appinfra.PrivacyConsentSensitiveData"
#define kAITagEvent @"AITagging"

// Enum to select Media State
typedef NS_ENUM (NSUInteger, AIATVideoState) {
    AIATVideoStatePlaying,
    AIATVideoStateStopped
};

static NSString *const kPreviousPageName = @"previousPageName";
static NSString *const enableDebugLogsKey = @"enableAdobeLogs";

@interface AIAppTagging()

@property (nonatomic, strong) AIClientComponent *component;
@property (nonatomic, strong) ClickStreamConsentHandler *clickStreamHandler;

@end


@implementation AIAppTagging

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
#if DEBUG
        NSError * error;
        NSNumber * enableLogs = [self.aiAppInfra.appConfig getPropertyForKey:enableDebugLogsKey
                                                                       group:@"appinfra"
                                                                       error:&error];
        if (enableLogs.boolValue == YES) {
            ADBMobile.debugLogging = YES;
        }
        else {
            ADBMobile.debugLogging = NO;
        }
#endif
        [ADBMobile collectLifecycleData];
        AIATPrivacyStatus privacyStatus = [self getPrivacyConsent];
        if (privacyStatus == AIATPrivacyStatusOptOut) {
            [self setPrivacyConsent:privacyStatus];
        } else {
            [AIAppTaggingPrivacyStatus setPrivacyStatus:[self getADBConsentStatusFor:privacyStatus]];
        }
    }
    return self;
}

- (BOOL)shouldTrackEvent {
    ADBMobilePrivacyStatus privacyStatus = [AIAppTaggingPrivacyStatus getPrivacyStatus];
    return privacyStatus != ADBMobilePrivacyStatusOptOut;
}

- (id<AIAppTaggingProtocol>)createInstanceForComponent:(NSString *)componentId
                                      componentVersion:(NSString *)componentVersion {
    AIClientComponent *component = [[AIClientComponent alloc] initWithIdentifier:componentId
                                                                         version:componentVersion];
    AIAppTaggingWrapper *wrapper = [[AIAppTaggingWrapper alloc] initWithComponent:component];
    wrapper.aiAppInfra = self.aiAppInfra;
    return wrapper;
}


- (void)registerClickStreamConsentHandler {
    [self.aiAppInfra.consentManager registerHandlerWithHandler:[self getClickStreamConsentHandler]
                                               forConsentTypes:@[[self getClickStreamConsentIdentifier]]
                                                         error:nil];
}


/* get the privacy status option based on the user consent
 @params: any one of the following enum AIATPrivacyStatusOptIn or AIATPrivacyStatusOptOut or AIATPrivacyStatusUnknown
 */
- (AIATPrivacyStatus)getPrivacyConsent {
    ADBMobilePrivacyStatus privacyStatus = [AIAppTaggingPrivacyStatus getPrivacyStatus];
    switch (privacyStatus) {
        case ADBMobilePrivacyStatusOptIn:
            return AIATPrivacyStatusOptIn;
        case ADBMobilePrivacyStatusOptOut:
            return AIATPrivacyStatusOptOut;
        case ADBMobilePrivacyStatusUnknown:
            return AIATPrivacyStatusUnknown;
    }
}

- (ADBMobilePrivacyStatus)getADBConsentStatusFor:(AIATPrivacyStatus)privacyStatus {
    switch (privacyStatus) {
        case AIATPrivacyStatusOptIn:
            return ADBMobilePrivacyStatusOptIn;
        case AIATPrivacyStatusOptOut:
            return ADBMobilePrivacyStatusOptOut;
        case AIATPrivacyStatusUnknown:
            return ADBMobilePrivacyStatusUnknown;
    }
}

/* set the privacy status option either  PrivacyStatusOptIn or PrivacyStatusOptOut or PrivacyStatusUnknown based on the user consent,
 */
- (void)setPrivacyConsent:(AIATPrivacyStatus)privacyStatus {
    // enable or disable the adobe analytics based on the user consent
    [AIAppTaggingPrivacyStatus setPrivacyStatus:[self getADBConsentStatusFor:privacyStatus]];
    switch (privacyStatus) {
        case AIATPrivacyStatusOptIn:
            [ADBMobile setPrivacyStatus:ADBMobilePrivacyStatusOptIn];
            [ADBMobile trackAction:@"analyticsOptIn" data:nil];
            break;
        case AIATPrivacyStatusOptOut:
            [ADBMobile trackAction:@"analyticsOptOut" data:nil];
            [ADBMobile setPrivacyStatus:ADBMobilePrivacyStatusOptIn];
            break;
        case AIATPrivacyStatusUnknown:
            [ADBMobile trackAction:@"analyticsUnkown" data:nil];
            [ADBMobile setPrivacyStatus:ADBMobilePrivacyStatusUnknown];
            break;
    }
}


// method to generate the analytics object
- (NSDictionary *)getAnalyticsDefaultParams {
    // get the language choosen
    NSString *strLanguageCode = [[[NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]] objectForKey: NSLocaleLanguageCode]lowercaseString];
    // get the UTC server time stamp
    NSString *currentUTCTimestamp = [self getUTCTimeStamp];
    // get the local system time stamp
    NSString *currentLocalTimestamp = [self getLocalTimeStamp];
    // prepare the context data
    
    // get the app state
    AIAppIdentityInterface *objAppIdentity = [[AIAppIdentityInterface alloc]initWithAppInfra:self.aiAppInfra];
    
    NSString *strAppState = [objAppIdentity getAppStateString];
    NSMutableDictionary *contextData = [@{@"appsId" : ADBMobile.trackingIdentifier?ADBMobile.trackingIdentifier:@"",
                                          @"UTCTimestamp" : currentUTCTimestamp,
                                          @"localTimeStamp" : currentLocalTimestamp,
                                          @"bundleId" : strAppState,
                                          @"language" : strLanguageCode ? strLanguageCode : @"en"
                                          } mutableCopy];
    
    // filter the default Params by trimming off the sensitive data which is defined in app config provided preivacyConsent is set to true
    if([self getPrivacyConsentForSensitiveData]) {
        NSArray *arrSensitiveDataKeys = [self.aiAppInfra.appConfig getDefaultPropertyForKey:kSensitiveData
                                                                                      group:kAppInfraGroup
                                                                                      error:nil];
        [contextData removeObjectsForKeys:arrSensitiveDataKeys];
    }
    return contextData;
}


// method to get the UTC timestamp
- (NSString *)getUTCTimeStamp {
    // get the server UTC time
    return [self getTimeStringFromDate:[self.aiAppInfra.time getUTCTime] inUTC:YES];
}


// method to get local time stamp
- (NSString *)getLocalTimeStamp {
    // get the local system time
    return [self getTimeStringFromDate:[NSDate date] inUTC:NO];
}


// Method to format the nsdate in the required format
-(NSString *)getTimeStringFromDate :(NSDate *)date inUTC:(BOOL)isUTC {
    // get the local system time
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS Z";
    if (isUTC) {
        [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    } else {
        dateformatter.timeZone = [NSTimeZone localTimeZone];
    }
    [dateformatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    return [dateformatter stringFromDate:date];
}


/* Track pages with page name and a pair of key value to be tracked
 @param: pageName: name of the page
 @param: key: key for the object to be tracked
 @param: Value: value to be tracked
 */
- (void)trackPageWithInfo:(NSString*)pageName paramKey:(NSString*)key andParamValue:(id)value
{
    [self validatePagename:pageName previousPagename:[AIATUtility sharedInstance].previousPage];
    if (pageName) {
        NSMutableDictionary *contextDict = [[NSMutableDictionary alloc]init];
        if(value && key){
            [contextDict setObject:value forKey:key];
        }
        NSString *previousPageName = [AIATUtility sharedInstance].previousPage;
        if(previousPageName)
        {
            [contextDict setObject:previousPageName forKey:kPreviousPageName];
        }
        // set the default parameters to the context dictionary
        [contextDict addEntriesFromDictionary:[self getAnalyticsDefaultParams]];
        [self postPageData:pageName withDict:contextDict];
        [AIATUtility sharedInstance].previousPage = pageName;
        
        [AIInternalLogger log:AILogLevelDebug
                      eventId:kAITagEvent
                      message:[[NSString alloc] initWithFormat:@"Track Page with Key Value: %@", pageName]];
    }
}
/* Track pages with page name and multiple key values to be tracked
 @param: pageName: name of the page
 @param: paramDict: dictionary of key-values to be tracked
 */
- (void)trackPageWithInfo:(NSString*)pageName params:(NSDictionary*)paramDict
{
    [self validatePagename:pageName previousPagename:[AIATUtility sharedInstance].previousPage];
    if (pageName) {
        NSMutableDictionary *contextDict = [[NSMutableDictionary alloc]init];
        for (NSString *key in [paramDict allKeys]) {
            [contextDict setObject:[paramDict valueForKey:key] forKey:key];
        }
        NSString *previousPageName = [AIATUtility sharedInstance].previousPage;
        if(previousPageName) {
            [contextDict setObject:previousPageName forKey:kPreviousPageName];
            
        }
        // set the default parameters to the context dictionary
        [contextDict addEntriesFromDictionary:[self getAnalyticsDefaultParams]];
        [self postPageData:pageName withDict:contextDict];
        [AIATUtility sharedInstance].previousPage = pageName;
        
        [AIInternalLogger log:AILogLevelDebug
                      eventId:kAITagEvent
                      message:[[NSString alloc] initWithFormat:@"Track Page with paramDict: %@", pageName]];
    }
}


/* Track button action with action name and a pair of key value to be tracked
 @param: actionName: name of the action
 @param: key: key for the object to be tracked
 @param: Value: value to be tracked
 */
- (void)trackActionWithInfo:(NSString*)actionName paramKey:(NSString*)key andParamValue:(id)value {
    actionName = [actionName stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self validateEventName:actionName];
    NSMutableDictionary *contextDict = [[NSMutableDictionary alloc]init];
    if(value && key){
        [contextDict setObject:value forKey:key];
    }
    // set the default parameters to the context dictionary
    [contextDict addEntriesFromDictionary:[self getAnalyticsDefaultParams]];
    [self postActionWithApplicationState:actionName withDict:contextDict];
    [AIInternalLogger log:AILogLevelDebug
                  eventId:kAITagEvent
                  message:[[NSString alloc] initWithFormat:@"Track Action with Key Value: %@", actionName]];
}


/* Track button action with action name and a pair of key value to be tracked
 @param: actionName: name of the action
 @param: paramDict: dictionary of key-values to be tracked
 */
- (void)trackActionWithInfo:(NSString*)actionName params:(NSDictionary*)paramDict {
    actionName = [actionName stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self validateEventName:actionName];
    NSMutableDictionary *contextDict = [[NSMutableDictionary alloc]init];
    for (NSString *key in [paramDict allKeys]) {
        [contextDict setObject:[paramDict valueForKey:key] forKey:key];
    }
    // set the default parameters to the context dictionary
    [contextDict addEntriesFromDictionary:[self getAnalyticsDefaultParams]];
    [self postActionWithApplicationState:actionName withDict:contextDict];
    [AIInternalLogger log:AILogLevelDebug
                  eventId:kAITagEvent
                  message:[[NSString alloc] initWithFormat:@"Track Action with paramDict: %@", actionName]];
}


/* Track button action with action name and a pair of key value to be tracked
 @param: actionName: name of the action
 @param: paramDict: dictionary of key-values to be tracked
 */
- (void)postActionWithApplicationState:(NSString*)actionName withDict:(NSDictionary*)contextDict {
    if (![self shouldTrackEvent]) {
        return;
    }
    void (^tagToAdobeBlock)(void) = ^(void) {
        UIApplicationState appState= [[UIApplication sharedApplication] applicationState];
        if( appState== UIApplicationStateBackground)
        {
            [ADBMobile trackActionFromBackground:actionName data:contextDict];
        }
        else
        {
            [ADBMobile trackAction:actionName data:contextDict];
        }
    };
    
    if ([NSThread isMainThread])
        tagToAdobeBlock();
    else
       dispatch_async(dispatch_get_main_queue(), ^(void){
           tagToAdobeBlock();
       });
    
    NSMutableDictionary *mutableContextData = [NSMutableDictionary dictionaryWithDictionary:contextDict];
    // post data to the listener
    [mutableContextData setObject:actionName forKey:kAilTaggingActionName];
    [self postTaggingData:mutableContextData];
}


-(void)postPageData:(NSString *)pageName withDict:(NSDictionary *)contextDict {
    if (![self shouldTrackEvent]) {
        return;
    }
    [ADBMobile trackState:pageName data:contextDict];
    NSMutableDictionary *mutableContextData = [NSMutableDictionary dictionaryWithDictionary:contextDict];
    // post data to the listener
    [mutableContextData setObject:pageName forKey:kAilTaggingPageName];
    [self postTaggingData:mutableContextData];
}

/**
 *  Description: setPreviousPage
 *
 *  @param pageName name of the previous page which has to be set
 */
- (void)setPreviousPage:(NSString *)pageName {
    if(pageName && pageName.length>0) {
        [AIATUtility sharedInstance].previousPage = pageName;
    }
}

- (NSString *)getErrorTaggingMessage:(nonnull AITaggingError *)taggingError {
    
    NSString *componentId = [self getComponentId];
    NSMutableString *message = [NSMutableString stringWithFormat:@"%@", componentId];
    if (taggingError.errorType.length > 0) {
        [message appendString:[NSString stringWithFormat:@":%@", taggingError.errorType]];
    }
    if (taggingError.serverName.length > 0) {
        [message appendString:[NSString stringWithFormat:@":%@", taggingError.serverName]];
    }
    if (taggingError.errorMessage.length > 0) {
        [message appendString:[NSString stringWithFormat:@":%@", taggingError.errorMessage]];
    }
    if (taggingError.errorCode.length > 0) {
        [message appendString:[NSString stringWithFormat:@":%@", taggingError.errorCode]];
    }
    return message;

}

- (void)trackErrorAction:(AITaggingErrorCategory)errorCategory
                  params:(nullable NSDictionary *)paramDict
            taggingError:(nonnull AITaggingError *)taggingError {
    
    NSMutableDictionary *contextDict = [[NSMutableDictionary alloc]init];
    for (NSString *key in [paramDict allKeys]) {
        [contextDict setObject:[paramDict valueForKey:key] forKey:key];
    }
    NSString *taggingMessage = [self getErrorTaggingMessage:taggingError];
    NSString *taggingKey = [[AIATUtility sharedInstance] getTaggingErrorCategory:errorCategory];
    
    if (taggingKey != nil) {
        [contextDict setObject:taggingMessage forKey:taggingKey];
        [self trackActionWithInfo:@"sendData" params:contextDict];
    }
}

- (void)trackErrorAction:(AITaggingErrorCategory)errorCategory taggingError:(nonnull AITaggingError *)taggingError {
    [self trackErrorAction:errorCategory params:nil taggingError:taggingError];
}

/* Track Video with VideoState and with a videoName
 @param: videoState: Current state of the mediaplayer
 @param: videoName: name of the media
 */
- (void)trackVideoState:(AIATVideoState)videoState withvideoName:(NSString*)videoName {
    [self trackActionWithInfo:[self selectedVideoState:videoState]
                     paramKey:@"videoName"
                andParamValue:videoName];
}


/* Track Video started with a videoName
 @param: videoName: name of the video file
 */
- (void)trackVideoStart:(NSString*)videoName {
    [self trackVideoState:AIATVideoStatePlaying withvideoName:videoName];
}


/* Track Video End  with a videoName
 @param: videoName: name of the video file
 */
- (void)trackVideoEnd:(NSString*)videoName {
    [self trackVideoState:AIATVideoStateStopped withvideoName:videoName];
}


/* Track social sharing with social media like facebook, twitter, mail etc…
 @param: socialMedia: Type of socail media through user sharing message
 @param: sharedItem: item to be shared string
 */
- (void)trackSocialSharing:(AIATSocialMedia)socialMedia withItem:(NSString*)sharedItem {
    NSDictionary *paramDict = [[NSDictionary alloc]initWithObjectsAndKeys:sharedItem,
                               @"socialItem",[self seletedSocialMedia:socialMedia],@"socialType",nil];
    [self trackActionWithInfo:@"socialShare" params:paramDict];
}


/* Track external link open
 @param: url: external url link
 */
-(void)trackLinkExternal:(nullable NSString*)url {
    if (!url)  return;
    
    NSDictionary *paramDict = [[NSDictionary alloc]initWithObjectsAndKeys:url,
                               @"exitLinkName",nil];
    [self trackActionWithInfo:@"sendData" params:paramDict];
}


/* Track filedownload
 @param: filename: downloading file name
 */
-(void)trackFileDownload:(nullable NSString*)filename {
    if (!filename)  return;
    
    NSDictionary *paramDict = [[NSDictionary alloc]initWithObjectsAndKeys:filename,
                               @"fileName",nil];
    [self trackActionWithInfo:@"sendData" params:paramDict];
}


/**
 * returns the action name based on AIVideoState Enum
 */
-(NSString *)selectedVideoState:(AIATVideoState)videoState {
    NSString *state = @"";
    
    switch (videoState) {
        case AIATVideoStatePlaying:
            state = @"videoStart";
            break;
        case AIATVideoStateStopped:
            state = @"videoEnd";
            break;
    }
    return state;
}


/**
 * returns the action name based on AISocialMedia Enum
 */
-(NSString *)seletedSocialMedia:(AIATSocialMedia)socialMedia {
    NSString *media=@"";
    switch (socialMedia)
    {
        case AIATSocialMediaFacebook:
            media = @"facebook";
            break;
        case AIATSocialMediaTwitter:
            media = @"twitter";
            break;
        case AIATSocialMediaMail:
            media = @"mail";
            break;
        case AIATSocialMediaAirDrop:
            media = @"airdrop";
            break;
    }
    return media;
}


/**
 * 	@brief Tracks the start of a timed event
 *  @param action a required NSString value that denotes the action name to track.
 *  @param data optional dictionary pointer containing context data to track with this timed action.
 *  @note This method does not send a tracking hit
 *  @attention If an action with the same name already exists it will be deleted and a new one will replace it.
 */
- (void) trackTimedActionStart:(nullable NSString *)action data:(nullable NSDictionary *)data {
    if (![self shouldTrackEvent]) {
        return;
    }
    NSMutableDictionary *contextDict = [[NSMutableDictionary alloc]init];
    for (NSString *key in [data allKeys]) {
        [contextDict setObject:[data valueForKey:key] forKey:key];
    }
    // set the default parameters to the context dictionary
    [contextDict addEntriesFromDictionary:[self getAnalyticsDefaultParams]];
    [ADBMobile trackTimedActionStart:action data:contextDict];
}


/**
 * 	@brief Tracks the end of a timed event
 *  @param action a required NSString pointer that denotes the action name to finish tracking.
 * 	@param block optional block to perform logic and update parameters when this timed event ends,
 this block can cancel the sending of the hit by returning NO.
 *  @note This method will send a tracking hit if the parameter logic is nil or returns YES.
 */
- (void) trackTimedActionEnd:(nullable NSString *)action
                       logic:(nullable BOOL (^)(NSTimeInterval inAppDuration, NSTimeInterval totalDuration, NSMutableDictionary* __nullable data))block {
    if (![self shouldTrackEvent]) {
        return;
    }
    [ADBMobile trackTimedActionEnd:action logic:block];
}


/**
 *  Description: setPrivacyConsentForSensitiveData
 *
 *  @param consent privacy consent is a boolean param
 */
-(void)setPrivacyConsentForSensitiveData:(BOOL)consent {
    NSNumber *privacyConsent = [[NSNumber alloc]initWithBool:consent];
    [self.aiAppInfra.storageProvider storeValueForKey:kPrivacyConsentSensitiveData
                                                value:privacyConsent error:nil];
}


/**
 *  Description: getPrivacyConsentForSensitiveData
 *
 *  @Return  privacy consent
 */
-(BOOL)getPrivacyConsentForSensitiveData {
    NSNumber *privacyConsent = [self.aiAppInfra.storageProvider fetchValueForKey:kPrivacyConsentSensitiveData error:nil];
    return privacyConsent.boolValue;
}


/**
 *	@brief Retrieves the analytics tracking identifier
 *	@return an NSString value containing the tracking identifier
 *	@note This method can cause a blocking network call and should not be used from a UI thread.
 */


-(NSString*)getTrackingIdentifier {
    return ADBMobile.trackingIdentifier;
}

/**
 *  Retrieves the analytics visitor ID appended to URL
 *  @param url URL link to which visitor id would be appended
 *  @return a NSURL value with visitor id appended to it
 *  @note This method can cause a blocking network call and should not be used from a UI thread.
 *  @since 1904.0.0
*/
- (nonnull NSURL *)getVisitorIDAppendToURL: (nonnull NSURL *)url {
    return [ADBMobile visitorAppendToURL:url];
}


-(id<ConsentHandlerProtocol> _Nonnull)getClickStreamConsentHandler {
    if (_clickStreamHandler == nil) {
        _clickStreamHandler = [[ClickStreamConsentHandler alloc]initWith:self.aiAppInfra];
    }
    return _clickStreamHandler;
}


- (nonnull NSString *)getClickStreamConsentIdentifier {
    return @"AIL_ClickStream";
}


-(void)postTaggingData:(NSDictionary *)data {
    NSNotification *notification = [NSNotification notificationWithName:kAilTaggingNotification
                                                                 object:nil
                                                               userInfo:data];
    [[NSNotificationQueue defaultQueue]enqueueNotification:notification postingStyle:NSPostASAP];
}


-(void)validatePagename:(NSString *)pagename previousPagename:(NSString *)previousPagename {
    NSString * reason;
    NSUInteger size = [AIUtility lengthInBytesForString:pagename];
    if (pagename == nil) {
        reason = @"pagename is nil";
    } else if (size > 100) {
        reason = @"tagging page name exceeds 100 bytes in length";
    } else if ([pagename isEqualToString:previousPagename]) {
        reason = @"tagging pagename and previous pagename are equal";
    }
    if (reason) {
        [AIInternalLogger log:AILogLevelError eventId:kAITagEvent message:reason];
    }
}


-(void)validateEventName:(NSString *)eventName {
    NSUInteger size = [AIUtility lengthInBytesForString:eventName];
    if (size > 255) {
        [AIInternalLogger log:AILogLevelError
                      eventId:kAITagEvent
                      message:@"tagging event names should not exceed  255 bytes in length"];
    }
}

- (NSString *)getComponentId {
    NSDictionary *data = [self getAnalyticsDefaultParams];
    if (data[@"componentId"] == nil) {
        return @"ail";
    } else {
        return data[@"componentId"];
    }
}

@end

