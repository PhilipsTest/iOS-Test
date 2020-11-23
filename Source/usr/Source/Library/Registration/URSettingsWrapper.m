//
//  URSettingsWrapper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "URSettingsWrapper.h"
#import "DIRegistrationVersion.h"
#import "URResponseSerializer.h"
#import "DIUser.h"
#import "DILogger.h"
#import "RegistrationUtility.h"
#import "DIRegistrationConstants.h"
#import "RegistrationAnalyticsConstants.h"

@interface URSettingsWrapper()

@property (nonatomic, strong) URCompletionHandler completionHandler;

@end


@implementation URSettingsWrapper

+ (instancetype)sharedInstance {
    static URSettingsWrapper *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [URSettingsWrapper new];
    });
    return sharedObject;
}


- (NSDictionary *)experienceDictionary {
    return @{@"OriginalOptInText":[NSNumber numberWithInt:1],
             @"OptInInSeparateScreen":[NSNumber numberWithInt:2]};
}


- (void)setDependencies:(URDependencies *)dependencies {
    _dependencies = dependencies;
    self.appLogging = [self.dependencies.appInfra.logging createInstanceForComponent:@"usr" componentVersion:[DIRegistrationVersion version]];
    self.appTagging = [self.dependencies.appInfra.tagging createInstanceForComponent:@"usr" componentVersion:[DIRegistrationVersion version]];
    _isTermsAndConditionsRequired = [[RegistrationUtility configValueForKey:Flow_TermsAndConditionsAcceptanceRequired countryCode:nil error:nil] boolValue];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.URLCache = nil;
    self.restClient = [[URSettingsWrapper sharedInstance].dependencies.appInfra.RESTClient createInstanceWithSessionConfiguration:sessionConfiguration];
    self.restClient.responseSerializer = [[URResponseSerializer alloc] init];
}


- (void)setLaunchInput:(URLaunchInput *)launchInput {
    _launchInput = launchInput;
    [_launchInput.registrationFlowConfiguration loadCountrySpecificConfigurationsForCountryCode:[URSettingsWrapper sharedInstance].countryCode serviceURLs:[URSettingsWrapper sharedInstance].serviceURLs];
}


- (void)setCompletionHandler:(URCompletionHandler)completionHandler {
    _completionHandler = completionHandler;
}


- (void)executeCompletionHandlerWithError:(NSError *)error {
    if (self.completionHandler) {
        self.completionHandler(error);
    }
    DIRInfoLog(@"User login state:%d", [[DIUser getInstance] userLoggedInState]);
    DIRDebugLog(@"UR stack trace:%@",[NSThread callStackSymbols]);
    //Registration Completed. Clean up unrequired objects.
    self.launchInput = nil;
    self.completionHandler = nil;
}

- (void)tagMarketingConsentStatus:(BOOL) userOptInStatus {
    NSString *reMarketingConsentAction = userOptInStatus ? kRegRemarketingOptIn : kRegRemarketingOptOut;
    [DIRegistrationAppTagging trackActionWithInfo:reMarketingConsentAction paramKey:nil andParamValue:nil];
}


- (URReceiveMarketingFlow)experience {
    if (self.launchInput.registrationFlowConfiguration.receiveMarketingFlow != URReceiveMarketingFlowFromServer) {
        return self.launchInput.registrationFlowConfiguration.receiveMarketingFlow;
    } else {
        NSString *exp = [DIRegistrationABTest getTestValue:@"ReceiveMarketingOptIn" defaultContent:@"OriginalOptInText" updateType:2];
        // Experience existance check and setting default value
        NSDictionary *experienceDic = [self experienceDictionary];
        if (![[experienceDic allKeys] containsObject:exp]) {
            exp = @"OriginalOptInText";
        }
        return [experienceDic[exp] intValue];
    }
}
@end
