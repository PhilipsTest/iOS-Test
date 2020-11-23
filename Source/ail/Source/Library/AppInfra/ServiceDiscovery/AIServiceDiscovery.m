
//
//  AISDServiceDiscoveryInterface.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/8/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
//

#import "AIServiceDiscovery.h"
#import "AISDManager.h"
#import "AISDService.h"
#import "AppInfra.h"
#import "AIUtility.h"
#import "AIInternalTaggingUtility.h"
#import "AIInternalLogger.h"

static const double kAILHoldbackTimeInSeconds = 10.0;

#define kUserSourceType       @"PREF"
#define kSDEvent @"AIServiceDiscovery"

NSString * const AILServiceDiscoveryHomeCountryChangedNotification = @"ail.servicediscovery.homecountryChanged";

@interface AIServiceDiscovery()

@property(nonatomic,retain)id<AIAppInfraProtocol> aiAppInfra;
@property(nonatomic, strong)AISDManager * sdManager;
@property(nonatomic, strong)AISDURLs * cachedSDURLs;
@property(nonatomic,strong)NSDate *lastErrorTimeStamp;

@end

@implementation AIServiceDiscovery{
    dispatch_semaphore_t semaphore;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma mark - Initialization
- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
        self.sdManager = [[AISDManager alloc]initWithAppInfra:appInfra];
        //semaphore to lock cuncurrent call to refresh api.
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - Public methods
- (void)getHomeCountry:(void(^)(NSString *countryCode, NSString *sourceType, NSError *error))completionHandler {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(self->semaphore, DISPATCH_TIME_FOREVER);
        [self.sdManager homeCountryCodeWithCompletion:^(NSString *homeCountryCode, NSString *sourceType, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if ([AIInternalTaggingUtility isNetworkError:error]) {
                        AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:kSDEvent
                                                                               serverName:nil
                                                                                errorCode:nil
                                                                             errorMessage:[error localizedDescription]];
                        [self.aiAppInfra.tagging trackErrorAction:AITaggingInformationalError taggingError:taggingError];
                    } else {
                        AITaggingError *error = [[AITaggingError alloc] initWithErrorType:kSDEvent
                                                                               serverName:nil
                                                                                errorCode:nil
                                                                             errorMessage:kAilTagHomeCountryError];
                        [self.aiAppInfra.tagging trackErrorAction:AITaggingTechnicalError taggingError:error];
                    }
                 }
                completionHandler(homeCountryCode, sourceType, error);
            });
            dispatch_semaphore_signal(self->semaphore);
        }];
    });
}

-(NSString *)getHomeCountry
{
    return [self.sdManager savedCountryCode];
}

-(void)setHomeCountry:(NSString *)countryCode
{
    if (![countryCode isEqualToString:[self.sdManager savedCountryCode]]) {
        if ([self validateCountryCode:countryCode]){
            [self.sdManager saveCountryCode:countryCode sourceType:kUserSourceType];
            //reset the cached data
            [self.sdManager clearDownloadedURLs];
            self.cachedSDURLs = nil;
            
            //posting notification if home country is set using setHomeCountry
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            NSDictionary * userInfo = @{@"ail.servicediscovery.homeCountry":countryCode};
            [notificationCenter postNotificationName:AILServiceDiscoveryHomeCountryChangedNotification object:nil userInfo:userInfo];
            
            // Initiated refresh
            [AIInternalLogger log:AILogLevelDebug eventId:kSDEvent message:@"refreshing due to country change"];
            [self refresh:^(NSError *error) {}];
        }
        else{
            NSAssert([self validateCountryCode:countryCode], @"Please enter a valid country code, code must be according to ISO 3166-1 (2 uppercase alphabets)");
            [AIInternalLogger log:AILogLevelError eventId:kSDEvent message:@"Please enter a valid country code, code must be according to ISO 3166-1 (2 uppercase alphabets)"];
        }
    }
}

-(void)getServicesWithLanguagePreference:(NSArray *)serviceIds
                   withCompletionHandler:(void(^)(NSDictionary<NSString*,AISDService*> * services,NSError *error))completionHandler
{
    [self loadServiceDiscoveryWithcompletionHandler:^(AISDURLs*  SDURLs, NSError *error) {
        if (SDURLs) {
            NSDictionary * services = [SDURLs getServicesWithServiceID:serviceIds Preference:AISDLanguagePreference];
            if (services) {
                completionHandler(services, error);
            }
            else {
                completionHandler(services, [AISDManager getSDError:AISDCannotFindURLError]);
            }
        }
        else {
            completionHandler(nil, error);
        }
    }];
}

-(void)getServicesWithLanguagePreference:(NSArray *)serviceIds
                   withCompletionHandler:(void(^)(NSDictionary<NSString*,AISDService*> *services,NSError *error))completionHandler
                             replacement:(NSDictionary *)replacement
{
    [self getServicesWithLanguagePreference:serviceIds withCompletionHandler:^(NSDictionary<NSString *,AISDService *> * _Nonnull services, NSError * _Nonnull error) {
        NSDictionary * output = [self getParameterReplacedServices:services replacement:replacement];
        completionHandler(output, error);
    }];
}

-(void)getServicesWithCountryPreference:(NSArray *)serviceIds
                  withCompletionHandler:(void(^)(NSDictionary<NSString*,AISDService*>* services,NSError *error))completionHandler
{
    [self loadServiceDiscoveryWithcompletionHandler:^(AISDURLs*  SDURLs, NSError *error) {
        if (SDURLs) {
            NSDictionary * services = [SDURLs getServicesWithServiceID:serviceIds Preference:AISDCountryPreference];
            if (services) {
                completionHandler(services, error);
            }
            else {
                completionHandler(services, [AISDManager getSDError:AISDCannotFindURLError]);
            }
        }
        else {
            completionHandler(nil, error);
        }
    }];
}

-(void)getServicesWithCountryPreference:(NSArray *)serviceIds
                  withCompletionHandler:(void(^)(NSDictionary<NSString*,AISDService*> *services,NSError *error))completionHandler
                            replacement:(NSDictionary *)replacement
{
    [self getServicesWithCountryPreference:serviceIds withCompletionHandler:^(NSDictionary<NSString *,AISDService *> * _Nonnull services, NSError * _Nonnull error) {
        NSDictionary * output = [self getParameterReplacedServices:services replacement:replacement];
        completionHandler(output, error);
    }];
}

- (void)refresh:(void(^)(NSError *error))completionHandler {
    [self fetchServiceDicoveryWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        if(error){
            if ([AIInternalTaggingUtility isNetworkError:error]) {
                AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:kSDEvent
                                                                       serverName:nil
                                                                        errorCode:nil
                                                                     errorMessage:[error localizedDescription]];
                [self.aiAppInfra.tagging trackErrorAction:AITaggingInformationalError taggingError:taggingError];
            } else {
                AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:kSDEvent
                                                                       serverName:nil
                                                                        errorCode:[NSString stringWithFormat:@"%ld", [error code]]
                                                                     errorMessage:kAilTagSDRefreshError];
                [self.aiAppInfra.tagging trackErrorAction:AITaggingTechnicalError taggingError:taggingError];
            }
        }
        completionHandler(error);
    }];
}

-(NSString *)applyURLParameters:(NSString *)URLString parameters:(NSDictionary *)map {
    for (NSString * key in map.allKeys) {
        NSString *value = [map objectForKey:key];
        if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            if ([AIUtility isNull:key] == NO && [AIUtility isNull:value] == NO) {
                NSString * replace = [NSString stringWithFormat:@"%%%@%%",key];
                URLString = [URLString stringByReplacingOccurrencesOfString:replace withString:value];
            }
        }
    }
    if (!URLString) {
        [AIInternalLogger log:AILogLevelError
                                           eventId:kSDEvent
                                           message:@"Malformed URL"];
        AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:kSDEvent
                                                               serverName:nil
                                                                errorCode:nil
                                                             errorMessage:kAilTagMalformedUrl];
        [self.aiAppInfra.tagging trackErrorAction:AITaggingTechnicalError taggingError:taggingError];
    }
    return URLString;
}

#pragma mark - Helper methods

-(NSDictionary *)getParameterReplacedServices:(NSDictionary *)inputServices replacement:(NSDictionary *)replacement{
    NSMutableDictionary * outputDict = [NSMutableDictionary new];
    for (NSString * serviceID in inputServices) {
        AISDService * service = [inputServices objectForKey:serviceID];
        NSString * outputURL = [self applyURLParameters:service.url parameters:replacement];
        
        if (outputURL) {
            AISDService * outputService = [[AISDService alloc]initWithUrl:outputURL andLocale:service.locale];
            [outputDict setObject:outputService forKey:serviceID];
        }
        else {
            [outputDict setObject:service forKey:serviceID];
        }
    }
    return outputDict;
}

-(BOOL)shouldRetryDownload
{
    // check for the time stamp of last error occured and initiate the download if  its older than hold back time
    NSTimeInterval timeGap = [self.lastErrorTimeStamp timeIntervalSinceNow];
    if(!self.lastErrorTimeStamp) // return true for the first time download
        return true;
    NSString *message = [NSString stringWithFormat:@"Last error occured in %.4f seconds. Hold back time:%.4f",-timeGap,kAILHoldbackTimeInSeconds];
    [AIInternalLogger log:AILogLevelDebug
                                       eventId:kSDEvent
                                       message:message];

    
    if(-timeGap > kAILHoldbackTimeInSeconds)
        return true;
    else
        return false;
}

-(void)fetchServiceDicoveryWithcompletionHandler:(void (^)( AISDURLs*  SDURLs, NSError *  error))completionHandler {
    
    // check for the time stamp of last error occured and initiate the download if  its older than hold back time
    if([self shouldRetryDownload])
    {
        [self.sdManager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
            if(error)
            {
                [self setLastErrorTimeStamp:[NSDate date]];
                completionHandler(nil ,error);
            }
            else
            {
                self.cachedSDURLs = SDURLs;
                completionHandler(SDURLs ,error);
            }
        }];
    }
    else
    {
        completionHandler(nil ,[AISDManager getSDError:AISDServerNotReachableError]);
    }
}

-(BOOL)validateCountryCode:(NSString *)countryCode
{
    if(countryCode.length == 2)
    {
        NSString *regex = @"[A-Z]+"; // check for one or more occurrence of string you can also use * instead + for ignoring null value
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:countryCode];
        return isValid;
    }
    else
        return false;
}

-(void)loadServiceDiscoveryWithcompletionHandler:(void (^)( AISDURLs*  SDURLs, NSError *  error))completionHandler {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        dispatch_semaphore_wait(self->semaphore, DISPATCH_TIME_FOREVER);
        
        if (self.cachedSDURLs == nil) {
            self.cachedSDURLs = [self.sdManager getCachedData];
        }
        
        BOOL urlsOlderThan24Hours = [self.sdManager savedURLsOlderthan24Hours];
        BOOL refreshRequired = [self.sdManager isRefreshRequired];
        
        if (refreshRequired || self.cachedSDURLs == nil || urlsOlderThan24Hours) {
            //cache will be cleared if any url parameter is changed
            if (refreshRequired) {
                [self.sdManager clearDownloadedURLs];
            }
            
            [AIInternalLogger log:AILogLevelDebug eventId:kSDEvent message:@"fething URLs from server"];
            [self fetchServiceDicoveryWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //if 24h expiry is reached and there was some error fetching from server, then load from cache
                    if (error && urlsOlderThan24Hours) {
                        completionHandler(self.cachedSDURLs, nil);
                    }
                    else {
                        completionHandler(SDURLs, error);
                    }
                });
                
                dispatch_semaphore_signal(self->semaphore);
            }];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(self.cachedSDURLs, nil);
            });
            
            dispatch_semaphore_signal(self->semaphore);
        }
    });
    
}

#pragma clang diagnostic pop
@end
