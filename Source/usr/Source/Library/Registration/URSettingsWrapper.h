//
//  URSettingsWrapper.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "URDependencies.h"
#import "URLaunchInput.h"

#define DIRegistrationAppTagging                [[URSettingsWrapper sharedInstance] appTagging]
#define DIRegistrationAppConfig                 [[[[URSettingsWrapper sharedInstance] dependencies] appInfra] appConfig]
#define DIRegistrationAppIdentity               [[[[URSettingsWrapper sharedInstance] dependencies] appInfra] appIdentity]
#define DIRegistrationAppTime                   [[[[URSettingsWrapper sharedInstance] dependencies] appInfra] time]
#define DIRegistrationABTest                    [[[[URSettingsWrapper sharedInstance] dependencies] appInfra] abtest]
#define DIRegistrationStorageProvider           [[[[URSettingsWrapper sharedInstance] dependencies] appInfra] storageProvider]


typedef void(^URCompletionHandler)(NSError *error);

typedef NS_ENUM(NSUInteger, RegistrationLoginFlowType) {
    RegistrationLoginFlowTypeEmail,
    RegistrationLoginFlowTypeMobile
};

@interface URSettingsWrapper : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedInstance;
- (void)setCompletionHandler:(URCompletionHandler)completionHandler;
- (void)executeCompletionHandlerWithError:(NSError*)error;
- (void)tagMarketingConsentStatus:(BOOL)userOptInStatus ;

@property (nonatomic, strong) URDependencies *dependencies;
@property (nonatomic, strong) URLaunchInput *launchInput;
@property (nonatomic, strong) id<AIAppTaggingProtocol> appTagging;
@property (nonatomic, strong) id<AIRESTClientProtocol> restClient;
@property (nonatomic, strong) id<AILoggingProtocol> appLogging;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSDictionary *serviceURLs;
@property (nonatomic, assign) URReceiveMarketingFlow experience;
@property (nonatomic, assign) RegistrationLoginFlowType loginFlowType;
@property (nonatomic, assign, readonly) BOOL isTermsAndConditionsRequired;
@end
