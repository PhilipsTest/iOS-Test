//
//  URInterface.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "URInterface.h"
#import "URSettingsWrapper.h"
#import "RegistrationUIConstants.h"
#import "URMarketingConsentHandler.h"
#import "DIUser+DataInterface.h"
#import "DIConstants.h"


@implementation URInterface

- (instancetype)initWithDependencies:(UAPPDependencies * _Nonnull) dependencies andSettings:(UAPPSettings * _Nullable) settings {
    self = [super init];
    if (self) {
        NSAssert(dependencies.appInfra != nil, @"Appinfra dependency should not be nill");
        [URSettingsWrapper sharedInstance].dependencies = (URDependencies *)dependencies;
        [self registerMarketingHandlerWith:dependencies.appInfra.consentManager];
    }
    return self;
}


- (UIViewController * _Nullable)instantiateViewController:(UAPPLaunchInput * _Nonnull)launchInput withErrorHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler {
    [[URSettingsWrapper sharedInstance] setLaunchInput:(URLaunchInput *)launchInput];
    [[URSettingsWrapper sharedInstance] setCompletionHandler:completionHandler];
    UIStoryboard *registrationStoryboard = [UIStoryboard storyboardWithName:@"RegistrationDLSMain" bundle:RESOURCE_BUNDLE];
    return [self viewControllerFromStoryboard:registrationStoryboard forLaunchInput:[URSettingsWrapper sharedInstance].launchInput];
}


- (id<UserDataInterface> _Nonnull)userDataInterface {
    return [DIUser getInstance];
}


#pragma mark - Helper Methods
#pragma mark -

- (UIViewController *)viewControllerFromStoryboard:(UIStoryboard *)storyBoard forLaunchInput:(URLaunchInput *)launchInput {
    NSString *viewControllerIdentifier = kRegistrationStartViewController;
    UserLoggedInState userState = [[DIUser getInstance] userLoggedInState];
    if ((userState == UserLoggedInStateUserLoggedIn) || (userState > UserLoggedInStatePendingVerification && [[RegistrationUtility configValueForKey:HSDPConfiguration_Skip_HSDP countryCode:nil error:nil] boolValue])) {
        if(launchInput.registrationFlowConfiguration.loggedInScreen == URLoggedInScreenMarketingOptIn) {
            viewControllerIdentifier = kRegistrationOptInViewController;
        } else {
            viewControllerIdentifier = kMyDetailsViewController;
        }
    } else if (userState == UserLoggedInStatePendingVerification) {
        viewControllerIdentifier = ([[URSettingsWrapper sharedInstance] loginFlowType]  == RegistrationLoginFlowTypeEmail) ? kURVerifyEmailViewController : kURSMSViewController;
    }
    return [storyBoard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
}


- (void)registerMarketingHandlerWith:(id<AIConsentManagerProtocol>)consentManager {
    NSAssert(consentManager != nil, @"ConsentManager or AppInfra is not initialised");
    
    URMarketingConsentHandler *marketingHandler = [[URMarketingConsentHandler alloc] init];
    [consentManager registerHandlerWithHandler:marketingHandler forConsentTypes:@[kUSRMarketingConsentKey] error:nil];
}

- (void)registerPersonalConsentHandlerWith:(id<AIConsentManagerProtocol>)consentManager {
    NSAssert(consentManager != nil, @"ConsentManager or AppInfra is not initialised");
    
    URPersonalConsentHandler *personalConsentHandler = [DIUser getInstance].personalConsentHandler;
    [consentManager registerHandlerWithHandler:personalConsentHandler forConsentTypes:@[kUSRPersonalConsentKey] error:nil];
}

@end



