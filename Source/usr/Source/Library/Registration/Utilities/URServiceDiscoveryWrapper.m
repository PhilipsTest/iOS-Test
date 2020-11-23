//
//  URServiceDiscoveryWrapper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 10/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URServiceDiscoveryWrapper.h"
#import "DIConstants.h"
#import "URBaseErrorParser.h"
#import "DIRegistrationConstants.h"

@interface URServiceDiscoveryWrapper ()
@property (nonatomic, strong, readwrite) NSString *countryCode;
@property (nonatomic, strong) id<AIServiceDiscoveryProtocol> serviceDiscovery;
@end

@implementation URServiceDiscoveryWrapper

- (instancetype)initWithServiceDiscovery:(id<AIServiceDiscoveryProtocol>)serviceDiscovery {
    self = [super init];
    if (self) {
        _serviceDiscovery = serviceDiscovery;
    }
    return self;
}


- (NSArray *)serviceIdArray {
    return @[kJanRainBaseURLKey,
             kEmailVerificationURLKey,
             kResetPasswordURLKey,
             kMobileFlowSupportedKey,
             kJanRainFlowDownloadURLKey,
             kJanRainEngageURLKey,
             kJanRainEngageURLKeyCN,
             kMyPhilipsLandingPageURLKey,
             kURXSMSVerificationURLKey,
             kHSDPBaseURLKey];

}


- (void)getHomeCountryWithCompletion:(void(^)(NSString *countryCode, NSString *locale, NSDictionary *serviceURLs, NSError *error))completion {
    [self.serviceDiscovery getHomeCountry:^(NSString *countryCodeString, NSString *sourceType, NSError *error) {
        if (countryCodeString && !error) {
            if (![[RegistrationUtility getSupportedCountries] containsObject:countryCodeString]) {//ServiceDiscovery returned unsupported URL. Need to fallback to supported country.
                NSString *fallbackCountry = [RegistrationUtility propositionFallbackCountry];
                [self setHomeCountry:fallbackCountry withCompletion:^(NSString *locale, NSDictionary *serviceURLs, NSError *countryError) {
                    if (countryError) {
                        completion (nil, nil, nil, [URBaseErrorParser errorForErrorCode:countryError.code]);
                    } else {
                        completion(fallbackCountry, locale, serviceURLs, countryError);
                    }
                }];
                return;
            }
            [self downloadServiceURLsWithCompletion:^(NSString *locale, NSDictionary *serviceURLs, NSError *downloadURLError) {
                if (serviceURLs && !downloadURLError) {
                    self.countryCode = countryCodeString;
                    completion (countryCodeString, locale, serviceURLs, nil);
                } else {
                    completion (nil, nil, nil, [URBaseErrorParser errorForErrorCode:downloadURLError.code]);
                }
            }];
        } else {
            completion (nil, nil, nil, [URBaseErrorParser errorForErrorCode:error.code]);
        }
    }];
}


- (void)setHomeCountry:(NSString *)countryCode withCompletion:(void(^)(NSString *locale, NSDictionary *serviceURLs, NSError *error))completion {
    [self.serviceDiscovery setHomeCountry:countryCode];
    [self downloadServiceURLsWithCompletion:^(NSString *locale, NSDictionary *serviceURLs, NSError *error) {
        if (serviceURLs && !error) {
            self.countryCode = countryCode;
            completion(locale, serviceURLs, nil);
        } else {
            completion (nil, nil, error);
        }
    }];
}


- (void)downloadServiceURLsWithCompletion:(void(^)(NSString *locale, NSDictionary *serviceURLs, NSError *error))completion {
    [self.serviceDiscovery getServicesWithCountryPreference:[self serviceIdArray] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *error) {
        if (services && !error) {
                NSMutableDictionary *urlsDictionary = [[NSMutableDictionary alloc] initWithCapacity:services.allKeys.count];
                NSString *localeString;
                for (NSString *serviceId in services.allKeys) {
                    AISDService *aiService = services[serviceId];
                    urlsDictionary[serviceId] = aiService.url;
                    if (aiService.locale != nil) {
                        localeString = aiService.locale;
                    } else {
                        completion (nil, nil, [URBaseErrorParser errorForErrorCode:DIUnexpectedErrorCode]);
                    }
                }
                BOOL isMobileFlow = [urlsDictionary[kURXSMSVerificationURLKey] length] > 0;
                localeString = [self adjustedLocaleForFlow:isMobileFlow locale:localeString];
                completion (localeString, urlsDictionary, nil);
        } else {
            completion (nil, nil, error);
        }
    } replacement:nil];
}


- (void)localeWithLanguagePreference:(void(^)(NSString *locale))completion {
    [self.serviceDiscovery getServicesWithLanguagePreference:@[kJanRainBaseURLKey] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *error) {
        AISDService *aiService = services[kJanRainBaseURLKey];
        if(completion) {
            completion(aiService.locale);
        }
    }replacement:nil];
}


- (NSString *)adjustedLocaleForFlow:(BOOL)isMobileFlow locale:(NSString *)localeString {
    if (isMobileFlow) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:localeString];
        NSString *language = [locale objectForKey:NSLocaleLanguageCode];
        return ([language caseInsensitiveCompare:@"zh"] == NSOrderedSame) ? @"zh-CN" : @"en-US";
    } else {
        return [localeString stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    }
}

@end
