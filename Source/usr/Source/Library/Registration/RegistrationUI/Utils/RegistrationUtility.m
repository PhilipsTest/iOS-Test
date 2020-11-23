//
//  RegistrationUtility.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "RegistrationUtility.h"
#import "URSettingsWrapper.h"
#import "RegistrationUIConstants.h"
#import "DIRegistrationConstants.h"
#import "NSString+Validation.h"

#define cHSDPCaptureKeychainIdentifier @"capture_tokens.hsdp"
#define cTermsAndConditionsAccepted @"TERMS_N_CONDITIONS_ACCEPTED"
#define cPersonalConsentAccepted @"PERSONAL_CONSENT_ACCEPTED"

static NSString *appBundleDisplayNameAndIdentifier() {
    NSDictionary *infoPlist = [[NSBundle bundleForClass:[RegistrationUtility class]] infoDictionary];
    NSString *name = [infoPlist objectForKey:@"CFBundleDisplayName"];
    NSString *identifier = [infoPlist objectForKey:@"CFBundleIdentifier"];

    return [NSString stringWithFormat:@"%@.%@", name, identifier];
}


static NSString *appBundleIdentifier() {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    return  [infoPlist objectForKey:@"CFBundleIdentifier"];
}


@implementation RegistrationUtility

+ (NSString *)serviceNameForTokenName:(NSString *)tokenName {
    return [NSString stringWithFormat:@"%@.%@.%@.", cHSDPCaptureKeychainIdentifier, tokenName, appBundleIdentifier()];
}


+ (NSString *)oldServiceNameForTokenName:(NSString *)tokenName {   //Generate old scheme for keychain for migration
    return [NSString stringWithFormat:@"%@.%@.%@.", cHSDPCaptureKeychainIdentifier, tokenName, appBundleDisplayNameAndIdentifier()];
}


+ (BOOL)hasUserAcceptedTermsnConditions:(NSString *)userEmail {
    [self checkAndMigrateTermsAndConditons];
    NSMutableArray *acceptedUsers = [NSMutableArray arrayWithArray:[DIRegistrationStorageProvider fetchValueForKey:cTermsAndConditionsAccepted error:nil]];
    return [acceptedUsers containsObject:userEmail];
}


+ (void)userAcceptedTermsnConditions:(NSString *)userEmail {
    NSMutableArray *acceptedUsers = [NSMutableArray arrayWithArray:[DIRegistrationStorageProvider fetchValueForKey:cTermsAndConditionsAccepted error:nil]];
    if ((userEmail != nil) && (![acceptedUsers containsObject:userEmail])) {
        [acceptedUsers addObject:userEmail];
        [DIRegistrationStorageProvider storeValueForKey:cTermsAndConditionsAccepted value:acceptedUsers error:nil];
    }
}

+ (ConsentStatus *)providePersonalConsentStateForUser:(NSString *)userEmail {
    NSDictionary *userConsentDetails = [DIRegistrationStorageProvider fetchValueForKey:cPersonalConsentAccepted error:nil];
    ConsentStatus *userState =  ((ConsentStatus *)[userConsentDetails objectForKey:cPersonalConsentAccepted]);
    return userState;
}

+ (void)userProvidedPersonalConsent:(NSString *)userEmail andStatus:(ConsentStates)state {
    ConsentStatus *status = [[ConsentStatus alloc] initWithStatus:state version:1 timestamp:[NSDate date]];
    NSDictionary *userConsentDetails = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:status,userEmail,nil] forKeys: [NSArray arrayWithObjects:cPersonalConsentAccepted,UserEmail,nil]];
    [DIRegistrationStorageProvider storeValueForKey:cPersonalConsentAccepted value:userConsentDetails error:nil];
}

+ (void)removePersonalConsentForUser {
    [DIRegistrationStorageProvider removeValueForKey:cPersonalConsentAccepted];
}

+ (void)checkAndMigrateTermsAndConditons {
    NSArray *allKeys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",@"TERMS_N_CONDITIONS_ACCEPTED__"];
    NSArray *filteredArray = [allKeys filteredArrayUsingPredicate:predicate];

    if (filteredArray.count == 0) return;
    NSMutableArray *migratedEmails = [NSMutableArray new];
    for (NSString *object in filteredArray) {
        [migratedEmails addObject:[object stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@__",cTermsAndConditionsAccepted] withString:@""]];
    }
    [DIRegistrationStorageProvider storeValueForKey:cTermsAndConditionsAccepted value:migratedEmails error:nil];

    for (NSString *termsAndCondtionsAccepted in filteredArray) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:termsAndCondtionsAccepted];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


+ (void)checkForUnsupportedSigninProviders:(NSArray *)signInProviders {
    for (NSString *providerStr in signInProviders) {
        if ([providerStr caseInsensitiveCompare:@"twitter"] == NSOrderedSame) {
            [NSException raise:@"Unsupported Signin Provider" format:@"%@ is not a supported provider.", providerStr];
        }
    }
}


+ (NSString *)getAppStateString:(AIAIAppState)appstate {
    switch (appstate) {
        case AIAIAppStateTEST:
            return kStateTest;
        case AIAIAppStateDEVELOPMENT:
            return kStateDevelopment;
        case AIAIAppStateSTAGING:
            return kStateStaging;
        case AIAIAppStateACCEPTANCE:
            return kStateEvaluation;
        case AIAIAppStatePRODUCTION:
            return kStateProduction;
        default:
            return kStateDevelopment;
    }
}


+ (NSArray *)getSupportedCountries {
    NSArray *platformSupportedCountries = [self userregistrationSupportedCountries];
    NSDictionary *countryMaps = [DIRegistrationAppConfig getPropertyForKey:@"servicediscovery.countryMapping"
                                                                     group:@"appinfra" error:nil];
    if (countryMaps.count > 0) {//This piece is a wrokaround added only for Aurora. If any other proposition get to a problem in this piece, they are probably pointing to wrong version/branch.
        NSArray *mappedCountries = countryMaps.allKeys;
        platformSupportedCountries = [platformSupportedCountries arrayByAddingObjectsFromArray:mappedCountries];
    }
    
    NSArray *propositionsSupportedCountries = [self propositionSupportedCountries];
    if (propositionsSupportedCountries) {
        NSMutableOrderedSet *urSupportedCountriesSet = [NSMutableOrderedSet orderedSetWithArray:platformSupportedCountries];
        NSSet *propositionsSupportedCountriesSet = [NSSet setWithArray:propositionsSupportedCountries];
        [urSupportedCountriesSet intersectSet:propositionsSupportedCountriesSet];
        return [urSupportedCountriesSet array];
    } else {
        return platformSupportedCountries;
    }
}


+ (NSArray *)userregistrationSupportedCountries {
    return @[@"RW",@"BG",@"CZ",@"DK",@"AT",@"CH",@"DE",@"GR",@"AU",@"CA",@"GB",@"HK",@"ID",@"IE",@"IN",@"MY",@"NZ",@"PH",@"PK",@"SA",@"SG",@"US",@"ZA",@"AR",@"CL",@"CO",@"ES",@"MX",@"PE",@"EE",@"FI",@"BE",@"FR",@"HR",@"HU",@"IT",@"JP",@"KR",@"LT",@"LV",@"NL",@"NO",@"PL",@"BR",@"PT",@"RO",@"RU",@"UA",@"SI",@"SK",@"SE",@"TH",@"TR",@"VN",@"CN",@"TW",@"AE",@"BH",@"EG",@"KW",@"LB",@"OM",@"QA",@"BY"];
}


+ (id)configValueForKey:(NSString *)key countryCode:(NSString *)code error:(NSError * __autoreleasing *)error {
    id configValue = [DIRegistrationAppConfig getPropertyForKey:key group:@"UserRegistration" error:error];
    if ([configValue isKindOfClass:[NSDictionary class]]) {
        id configForCountry = configValue[code];
        if (!configForCountry) {
            return configValue[@"default"];
        } else {
            return configForCountry;
        }
    } else {
        return configValue;
    }
}

    
+ (void)log:(AILogLevel)level format:(NSString *)format, ... {
    [self log:level eventId:@"PhilipsRegistration" format:format];
}
    
    
+ (void)log:(AILogLevel)level eventId:(NSString *)eventId format:(NSString *)format, ... {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [[URSettingsWrapper sharedInstance].appLogging log:level eventId:eventId message:message];
        va_end(args);
    }
}


+ (void)setHSDPUserUUID:(NSString *)hsdpUUID {
    [URSettingsWrapper sharedInstance].dependencies.appInfra.cloudLogging.hsdpUserUUID = hsdpUUID;
}


+ (NSArray *)propositionSupportedCountries {
    NSArray *supportedCountries = [self configValueForKey:SupportedHomeCountries countryCode:nil error:nil];
    return supportedCountries;
}


+ (NSString *)propositionFallbackCountry {
    NSString *fallbackCountry = [self configValueForKey:FallbackHomeCountry countryCode:nil error:nil];;
    return fallbackCountry ? fallbackCountry : @"US";
}


+ (NSInteger)passwordStrength:(NSString *)pwdText {
    NSInteger strength = ([pwdText hasCorrectLengthForPassword] * 2) +
    [pwdText containsAlphabets] +
    [pwdText containsAllowedSpecialCharacters] +
    [pwdText containsNumbers];

    return strength;
}


+ (NSString *)convertURLRequestToString:(NSURLRequest *)request {
    __block NSMutableString *curlCommandString = [NSMutableString stringWithFormat:@"curl -v -X %@ ", request.HTTPMethod];
    [curlCommandString appendFormat:@"\'%@\' ", request.URL.absoluteString];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *val, BOOL *stop) {
        [curlCommandString appendFormat:@"-H \'%@: %@\' ", key, val];
    }];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    if (cookies) {
        [curlCommandString appendFormat:@"-H \'Cookie:"];
        for (NSHTTPCookie *cookie in cookies) {
            [curlCommandString appendFormat:@" %@=%@;", cookie.name, cookie.value];
        }
        [curlCommandString appendFormat:@"\' "];
    }
    
    if (request.HTTPBody) {
        if ([request.allHTTPHeaderFields[@"Content-Length"] intValue] < 4096) {
            [curlCommandString appendFormat:@"-d \'%@\'",
             [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
        } else {
            [curlCommandString appendFormat:@"[TOO MUCH DATA TO INCLUDE]"];
        }
    }
    
    return curlCommandString;
}


+ (NSString *)getURFormattedLogError:(NSError *)inputError withDomain:(NSString *)domainName {
    NSString *errorDomain = domainName.length > 0 ? domainName:inputError.domain;
    return [NSString stringWithFormat:@"errorCode:%ld, errorDomain:%@, userInfo:%@", (long)inputError.code, errorDomain, inputError.userInfo.description];
}


+ (NSString *)getURConfigurationLog {
    return [NSString stringWithFormat:@"App Name : %@,\n App LocalizedName : %@,\n App Version : %@,\n App MicrositeID : %@,\n App State : %@,\n App Sector : %@,\n App ServiceDiscoveryEnvironment : %@\n",[DIRegistrationAppIdentity getAppName],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],[DIRegistrationAppIdentity getAppVersion],[DIRegistrationAppIdentity getMicrositeId],[RegistrationUtility getAppStateString:[DIRegistrationAppIdentity getAppState]],
            [DIRegistrationAppIdentity getSector],
            [DIRegistrationAppIdentity getServiceDiscoveryEnvironment]];
}

+(BOOL)isWeChatAppInstalled {
    if (NSClassFromString(@"WXApi"))
    {
        Class signInClass = NSClassFromString(@"WXApi");
        SEL appInstaller = NSSelectorFromString(@"isWXAppInstalled");
        BOOL (*urlHandler)(id, SEL) = (void *)[signInClass methodForSelector:appInstaller];
        return urlHandler(signInClass, appInstaller);
    }
    return false;
}

@end
