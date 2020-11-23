//
//  ServiceDiscoveryModel.m
//
//  Created by Ravi Kiran HR on 6/14/16
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "AISDModel.h"
#import "AIUtility.h"
#import "AISDService.h"
#import "AISDResults.h"
#import "AISDConfigs.h"
#import "AppInfra.h"
#import "AISDManager.h"

NSString *const kBaseClassCountry = @"country";
NSString *const kBaseClassMatchByLanguage = @"matchByLanguage";
NSString *const kBaseClassMatchByCountry = @"matchByCountry";

@interface AISDModel()

@property(nonatomic, weak)id<AIAppInfraProtocol> aiAppInfra;

@end

@implementation AISDModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary appInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.country = [AIUtility objectOrNilForKey:kBaseClassCountry fromDictionary:dictionary];
        self.matchByLanguage = [AISDMatchByLanguage modelObjectWithDictionary:[dictionary objectForKey:kBaseClassMatchByLanguage]];
        self.matchByCountry = [AISDMatchByCountry modelObjectWithDictionary:[dictionary objectForKey:kBaseClassMatchByCountry]];
        self.aiAppInfra = appInfra;
    }
    return self;
}

-(NSString *)getServiceURLWithServiceID:(NSString *)serviceID Preference:(AISDPreference)preference {
    AISDResults *result = [self getResultsForPreference:preference];
    
    for (AISDConfigs * config in result.configs) {
        NSString * URLString = config.urls[serviceID];
        if (URLString) {
            URLString = [self urlDecodeForServiceDiscovery:URLString];
            return URLString;
        }
    }
    
    return nil;
}

-(NSDictionary *)getServicesWithServiceID:(NSArray *)serviceIDs Preference:(AISDPreference)preference {
    AISDResults *result = [self getResultsForPreference:preference];
    if (result.configs.count == 0) {
        return nil;
    }
    
    //create dictionary to hold url and locale
    NSMutableDictionary * outputDict = [NSMutableDictionary new];
    
    for (AISDConfigs * config in result.configs) {
        for (NSString *serviceId in serviceIDs) {
            AISDService * service = [outputDict objectForKey:serviceId];
            if (service == nil || service.error != nil) {
                service = [AISDService new];
                if (config.urls[serviceId]) {
                    NSString* URL = config.urls[serviceId];
                    service.url = [self urlDecodeForServiceDiscovery:URL];
                }
                else {
                    service.error = [AISDManager getSDError:AISDCannotFindURLError];
                }
                service.locale = result.locale;
                [outputDict setObject: service forKey: serviceId] ;
            }
        }
    }
    
    return outputDict;
}

-(NSString *)getLocaleWithPreference:(AISDPreference)preference {
    AISDResults *result = [self getResultsForPreference:preference];
    return result.locale;
}


-(AISDResults *)getResultsForPreference:(AISDPreference)preference {
    AISDResults *result;
    switch (preference) {
        case AISDLanguagePreference:
            if (self.matchByLanguage.available && self.matchByLanguage.results.count) {
                result =  self.matchByLanguage.results[0];
            }
            break;
            
        case AISDCountryPreference:
            result =  [self getCorrectResultsForLocaleList:[NSLocale preferredLanguages] results:self.matchByCountry.results];
            break;
    }
    return result;
}

//if there are multiple set of service urls find the best match based on the user language preference
-(AISDResults *)getCorrectResultsForLocaleList:(NSArray *)localeList results:(NSArray *)resultsArray {
    
    if (resultsArray.count == 0 || !resultsArray) {
        return nil;
    }
    
    for (NSString *locale in localeList) {
        for (AISDResults *result in resultsArray) {
            NSString* localeString = [locale stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            if ([localeString isEqualToString:result.locale]) {
                //full locale is matched.
                return result;
            }
            else {
                //US14053
                NSArray * languageDevice = [localeString componentsSeparatedByString:@"_"];
                NSArray * languageResponse = [result.locale componentsSeparatedByString:@"_"];
                
                if ([languageDevice[0] isEqualToString:languageResponse[0]]) {
                    //only language part is matched
                    return result;
                }
            }
        }
    }
    
    return resultsArray[0];
}

/*
 * some service discovery urls are encoded with %22 for "
 * this method will decode that to original form
 */
-(NSString*)urlDecodeForServiceDiscovery:(NSString*)url{
    NSString* newUrl = [url stringByReplacingOccurrencesOfString:@"%22" withString:@"\""];
    return newUrl;
}

@end
