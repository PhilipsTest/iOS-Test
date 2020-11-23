//
//  DIRegistrationFlowConfiguration.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DIRegistrationFlowConfiguration.h"
#import "RegistrationUtility.h"
#import "DIConstants.h"
#import "DIRegistrationConstants.h"
#import "URSettingsWrapper.h"

@interface DIRegistrationFlowConfiguration()

@property (nonatomic, strong, readwrite) NSArray *signInProviders;
@property (nonatomic, assign, readwrite) int minimumAgeLimit;
@property (nonatomic, strong, readwrite) NSString *loginPageURL;
@property (nonatomic, strong, readwrite) NSString *resetPasswordURL;

@end

@implementation DIRegistrationFlowConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _priorityFunction = URPriorityFunctionRegistration;
        _isTermsAndConditionsAcceptanceRequired = [[RegistrationUtility configValueForKey:Flow_TermsAndConditionsAcceptanceRequired countryCode:nil error:nil] boolValue];
        NSError *error;
        self.userPersonalConsentStatus = ConsentStatesInactive;
        _hideCountrySelection = [[RegistrationUtility configValueForKey:HideCountrySelction countryCode:nil error:&error] boolValue];
        [self loadCountrySpecificConfigurationsForCountryCode:[URSettingsWrapper sharedInstance].countryCode serviceURLs:[URSettingsWrapper sharedInstance].serviceURLs];
        _animateExit = true;
        self.hideNavigationBar = false;
    }
    return self;
}

-(BOOL)isPersonalConsentToBeShown {
    return [[RegistrationUtility configValueForKey:PersonalConsentRequired countryCode:nil error:nil] boolValue];
}

- (void)loadCountrySpecificConfigurationsForCountryCode:(NSString *)countryCode serviceURLs:(NSDictionary *)serviceURLs {
    self.signInProviders = [RegistrationUtility configValueForKey:SigninProviders countryCode:countryCode error:nil];
    [self filterSignInProviders];
    self.minimumAgeLimit = [[RegistrationUtility configValueForKey:Flow_MinimumAgeLimit countryCode:countryCode error:nil] intValue];
    self.loginPageURL = serviceURLs[kMyPhilipsLandingPageURLKey];
    self.resetPasswordURL = serviceURLs[kResetPasswordURLKey];
}


- (void)filterSignInProviders {
    
    NSMutableArray *supportedProviders = [NSMutableArray arrayWithObjects:kProviderNameFacebook, kProviderNameGoogle,nil];

    if([self checkIfWeChatIsInstalled]) {
        supportedProviders = [NSMutableArray arrayWithArray:@[kProviderNameFacebook, kProviderNameGoogle, kProviderNameWeChat]];
    }
    
    if (@available(iOS 13, *)) {
        [supportedProviders addObject:kProviderNameApple];
    }
    
    if (self.signInProviders) {
        self.signInProviders = [self.signInProviders filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [supportedProviders containsObject:evaluatedObject];
        }]];
    }
}

- (BOOL)checkIfWeChatIsInstalled {
    return ([self.signInProviders containsObject:kProviderNameWeChat] && [RegistrationUtility isWeChatAppInstalled]);
}

@end
