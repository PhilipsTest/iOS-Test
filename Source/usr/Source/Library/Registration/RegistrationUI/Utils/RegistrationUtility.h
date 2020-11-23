//
//  RegistrationUtility.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import <AppInfra/AppInfra.h>
@import PlatformInterfaces;

@interface RegistrationUtility : NSObject

+ (NSString *)serviceNameForTokenName:(NSString *)tokenName;
+ (NSString *)oldServiceNameForTokenName:(NSString *)tokenName;
+ (BOOL)hasUserAcceptedTermsnConditions:(NSString *)userEmail;
+ (void)userAcceptedTermsnConditions:(NSString *)userEmail;

+ (ConsentStatus *)providePersonalConsentStateForUser:(NSString *)userEmail;
+ (void)userProvidedPersonalConsent:(NSString *)userEmail andStatus:(ConsentStates)state;
+ (void)removePersonalConsentForUser;

+ (void)checkForUnsupportedSigninProviders:(NSArray *)signInProviders;
+ (NSString *)getAppStateString:(AIAIAppState)appstate;
+ (NSArray *)getSupportedCountries;
+ (id)configValueForKey:(NSString *)key countryCode:(NSString *)code error:(NSError **)error;
+ (void)log:(AILogLevel)level format:(NSString *)format, ...;
+ (void)log:(AILogLevel)level eventId:(NSString *)eventId format:(NSString *)format, ...;
+ (NSString *)propositionFallbackCountry;
+ (NSArray *)userregistrationSupportedCountries;
+ (NSInteger)passwordStrength:(NSString *)pwdText;
+ (NSString *)convertURLRequestToString:(NSURLRequest *)request;
+ (NSString *)getURFormattedLogError:(NSError *)inputError withDomain:(NSString *)domainName;
+ (NSString *)getURConfigurationLog;
+ (void)setHSDPUserUUID:(NSString *)hsdpUUID;
+ (BOOL)isWeChatAppInstalled;
@end
