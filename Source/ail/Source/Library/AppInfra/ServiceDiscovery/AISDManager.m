//
//  APIManager.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/3/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
//

#import "AISDManager.h"
#import "AppInfra.h"
#import "AIUtility.h"
#import "AISDNetworkWrapper.h"
#import "AIInternalTaggingUtility.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AILogging.h"
#import "AIInternalLogger.h"

NSString * const ServiceDiscoveryDataDownloadCompletedNotification = @"ail.serviceDiscoveryDataDownloadCompleted";

static NSString *const URLTagTest = @"apps%2b%2benv%2btest";
static NSString *const URLTagDevelopment = @"apps%2b%2benv%2bdev";
static NSString *const URLTagStaging = @"apps%2b%2benv%2bstage";
static NSString *const URLTagAcceptance = @"apps%2b%2benv%2bacc";
static NSString *const URLTagProduction = @"apps%2b%2benv%2bprod";

static NSString *const baseURLProduction = @"www.philips.com";
static NSString *const baseURLStaging = @"stg.philips.com";

static NSString *const stateTesting = @"TEST";
static NSString *const stateDevelopment = @"DEVELOPMENT";
static NSString *const stateStaging = @"STAGING";
static NSString *const stateAccepteance = @"ACCEPTANCE";
static NSString *const stateProduction = @"PRODUCTION";

static NSString *const SDURLKey = @"ail.SDURL";
static NSString *const SDURLPlatformKey = @"ail.SDURLPlatform";

static NSString *const payloadKey = @"payload";

static NSString *const secureStorageKeyCountryCode = @"ail.Locale.CountryCode";
static NSString *const secureStorageKeySourceType = @"ail.Locale.SourceType";
static NSString *const sourceTypeSIM = @"SIM";
static NSString *const sourceTypeGEOIP = @"GEOIP";

static NSString *const eventID = @"SDManager";
static NSString *const lastUpdatedTime = @"ail.servicediscovery.lastupdatedtime";

static NSString *const appConfigPlatformSDEnvironment = @"servicediscovery.platformEnvironment";
static NSString *const appConfigPlatformMicrositeId = @"servicediscovery.platformMicrositeId";
static NSString *const appConfigAppInfraGroup = @"appinfra";
static NSString *const appConfigSDDownloadMode = @"servicediscovery.propositionEnabled";

static NSString *const errorDomainAIServiceDisc = @"ail.ServiceDiscovery";

typedef NS_ENUM(NSUInteger, AISDURLType) {
    AISDURLTypeProposition = 1,
    AISDURLTypePlatform
};

@interface AISDManager()

@property(nonatomic, weak)id<AIAppInfraProtocol> aiAppInfra;
@property(nonatomic, strong)AISDNetworkWrapper *networkWrapper;
@property(nonatomic, strong)NSString *homeCountryCode;
@property(nonatomic, strong)NSString *homeCountrySourceType;

@end

@implementation AISDManager

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
        self.networkWrapper = [[AISDNetworkWrapper alloc]initWithAppInfra:self.aiAppInfra];
    }
    return self;
}


- (void)downloadPlatformData:(void (^)(AISDURLs *, NSError *))completionHandler SDURLs:(AISDURLs *)SDURLs {
    NSString * platformURL = [self getSDURLForType:AISDURLTypePlatform];
    //Downloading platform URLS
    if (platformURL) {
        [AIInternalLogger log:AILogLevelDebug eventId:eventID message:kAilTagDownloadPlatform];
        [self downloadData:completionHandler
                    SDURLs:SDURLs
                       URL:platformURL
 shouldContinueForPlatform:NO];
    } else {
        [AIInternalLogger log:AILogLevelError eventId:eventID message:@"platform url is null"];
    }
}


- (void)downloadPlatformAndPropositionData:(void (^)(AISDURLs *, NSError *))completionHandler {
    __block NSString * propositionURL = [self getSDURLForType:AISDURLTypeProposition];
    //Downloading proposition URLS
    if (propositionURL) {
        [AIInternalLogger log:AILogLevelDebug
                      eventId:eventID
                      message:kAilTagDownloadProposition];
        AISDURLs * SDURLs = [[AISDURLs alloc]initWithAppInfra:self.aiAppInfra];
        [self downloadData:completionHandler
                    SDURLs:SDURLs
                       URL:propositionURL
 shouldContinueForPlatform:YES];
    } else {
        [AIInternalLogger log:AILogLevelError eventId:eventID message:@"proposition url is null"];
    }
}


- (void)downloadData:(void (^)(AISDURLs *, NSError *))completionHandler SDURLs:(AISDURLs *)SDURLs URL:(NSString *)url shouldContinueForPlatform:(BOOL)shouldContinue {
    __block NSString *sdurl = url;
    [self.networkWrapper serviceDiscoveryDataWithURL:url
                                   completionHandler:^(NSDictionary*  responseProposition, NSError *propositionError) {
                                       if (responseProposition) {
                                           NSDictionary * payloadProp = responseProposition[payloadKey];
                                           AISDModel * sdModel = [[AISDModel alloc]initWithDictionary:payloadProp
                                                                                             appInfra:self.aiAppInfra];
                                           AISDURLType type;
                                           if (shouldContinue){
                                               type = AISDURLTypeProposition;
                                               SDURLs.propositionURLs = sdModel;
                                           }
                                           else{
                                               SDURLs.platformURLs = sdModel;
                                               type = AISDURLTypePlatform;
                                           }
                                           NSString *countryCode = [self savedCountryCode];
                                           if (countryCode == nil) {
                                               [self saveCountryCode:sdModel.country sourceType:sourceTypeGEOIP];
                                               sdurl = [NSString stringWithFormat:@"%@&country=%@",
                                                        url,sdModel.country];
                                               BOOL shouldRetry = NO;
                                               NSString *mappedCountry = [self getCountryMapping:sdModel.country];
                                               if (mappedCountry) {
                                                   shouldRetry = YES;
                                                   sdurl = [NSString stringWithFormat:@"%@&country=%@",
                                                            url,mappedCountry];
                                               }
                                               if (shouldRetry) {
                                                   [self downloadData:completionHandler
                                                               SDURLs:SDURLs
                                                                  URL:sdurl
                                            shouldContinueForPlatform:shouldContinue];
                                                   return ;
                                               }
                                           }
                                           [self cacheDownloadedURLs:responseProposition
                                                           URLString:sdurl
                                                             URLType:type];
                                           if (shouldContinue) {
                                               [self downloadPlatformData:completionHandler SDURLs:SDURLs];
                                           } else {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:ServiceDiscoveryDataDownloadCompletedNotification
                                                                                                       object:nil];
                                               });
                                               completionHandler(SDURLs, nil);
                                           }
                                       } else {
                                           [self clearDownloadedURLs];
                                           completionHandler(nil, propositionError);
                                       }
                                   }];
}


//it will asynchronously download platform URL set and proposition URL set. Completion block will be called
//only when both the download finishes
-(void)getServiceDiscoveryDataWithcompletionHandler:(void (^)( AISDURLs *  SDURLs, NSError *  error))completionHandler {
    [self validatePlatformMicroSiteID];
    if ([self isPropostionEnabled]) {
        [self downloadPlatformAndPropositionData:completionHandler];
    } else {
        AISDURLs * SDURLs = [[AISDURLs alloc]initWithAppInfra:self.aiAppInfra];
        [self downloadPlatformData:completionHandler SDURLs:SDURLs];
    }
}


-(void)homeCountryCodeWithCompletion:(void(^)(NSString *countryCode, NSString *sourceType, NSError *error))completionHandler {
    
    NSString *countryCode = [self savedCountryCode];
    NSString *sourceType = [self savedCountryCodeSourceType];
    if ([countryCode length] <= 0 ) {
        
        countryCode = [self getCountryCodeFromSIM];
        
        if (countryCode) {
            [AIInternalLogger log:AILogLevelDebug
                          eventId:eventID
                          message:[NSString stringWithFormat:@"country from sim with country code: %@",
                                   countryCode]];
            [self saveCountryCode:countryCode sourceType:sourceTypeSIM];
            completionHandler(countryCode, sourceTypeSIM, nil);
        } else {
            [self getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
                NSString * country = [self savedCountryCode]?[self savedCountryCode]:[SDURLs getCountryCode];
                if (country) {
                    //[self saveCountryCode:country sourceType:sourceTypeGEOIP];
                    completionHandler(country, sourceTypeGEOIP, nil);
                } else {
                    completionHandler(nil, nil, error);
                }
            }];
        }
    } else {
        completionHandler(countryCode, sourceType, nil);
    }
}


-(void)validatePlatformMicroSiteID {
    NSAssert([self getPlatformMicrositeID], @"Platform micrositeId in app config cannot be empty");
    
    NSString *micrositeIDAcceptedCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSCharacterSet *blockedCharacters;
    blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:micrositeIDAcceptedCharacters] invertedSet];
    NSAssert([[self getPlatformMicrositeID] rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound, @"micrositeId should be alpha numeric");
    
    NSString * environment = [self getPlatformEnvironment];
    NSAssert((environment && environment.length>0), @"Platform service discovery environment cannot be empty in App config  file");
    environment = environment.uppercaseString;
    NSArray * availableEnvironments = @[@"STAGING", @"PRODUCTION"];
    
    NSString * message = @"Platform service discovery environment in App config  file must match one of the following values \n PRODUCTION, \n STAGING";
    if (![availableEnvironments containsObject:environment]) {
        [AIInternalLogger log:AILogLevelError eventId:eventID message:message];
    }
    NSAssert([availableEnvironments containsObject:environment], message);
}


-(NSString *)getCountryCodeFromSIM {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *mobileCountryCode = [carrier isoCountryCode];
    mobileCountryCode = [mobileCountryCode uppercaseString];
    return mobileCountryCode;
}


-(NSString *)getSDBaseURLForEnvironment:(NSString *)environment {
    NSString *baseURL;
    if([environment caseInsensitiveCompare:stateStaging]==NSOrderedSame)
        baseURL = baseURLStaging;
    else if([environment caseInsensitiveCompare:stateProduction]==NSOrderedSame)
        baseURL = baseURLProduction;
    return baseURL;
}


-(NSString *)getAppStateStringFromState:(AIAIAppState)state {
    NSString *appState;
    switch (state) {
        case AIAIAppStateTEST:
            appState = URLTagTest;
            break;
        case AIAIAppStateDEVELOPMENT:
            appState = URLTagDevelopment;
            break;
        case AIAIAppStateSTAGING:
            appState = URLTagStaging;
            break;
        case AIAIAppStateACCEPTANCE:
            appState = URLTagAcceptance;
            break;
        case AIAIAppStatePRODUCTION:
            appState = URLTagProduction;
            break;
    }
    return appState;
}


-(NSString *)getPlatformMicrositeID {
    NSString * micrositeId;
    id value = [self.aiAppInfra.appConfig getDefaultPropertyForKey:appConfigPlatformMicrositeId
                                                             group:appConfigAppInfraGroup
                                                             error:nil];;
    if ([value isKindOfClass:[NSNumber class]]) {
        micrositeId = ((NSNumber *)value).stringValue;
    } else if ([value isKindOfClass:[NSString class]]) {
        micrositeId = value;
    }
    return micrositeId;
}


-(NSString *)getPlatformEnvironment {
    NSString * environment;
    if ([self.aiAppInfra.appIdentity getAppState] == AIAIAppStatePRODUCTION) {
        environment = [self.aiAppInfra.appConfig getDefaultPropertyForKey:appConfigPlatformSDEnvironment
                                                                    group:appConfigAppInfraGroup
                                                                    error:nil];
    } else {
        environment = [self.aiAppInfra.appConfig getPropertyForKey:appConfigPlatformSDEnvironment
                                                             group:appConfigAppInfraGroup
                                                             error:nil];
    }
    return environment;
}


-(NSString *)getSDURLForType:(AISDURLType)URLType {
    NSString *sector, *micrositeID, *environment;
    
    NSString *appState = [self getAppStateStringFromState:[self.aiAppInfra.appIdentity getAppState]];
    switch (URLType) {
        case AISDURLTypePlatform:
            sector = @"b2c";
            micrositeID = [self getPlatformMicrositeID];
            environment = [self getPlatformEnvironment];
            environment = [self getSDBaseURLForEnvironment:environment];
            break;
        case AISDURLTypeProposition:
            sector = [self.aiAppInfra.appIdentity getSector];
            micrositeID = [self.aiAppInfra.appIdentity getMicrositeId];
            environment  = [self getSDBaseURLForEnvironment:[self.aiAppInfra.appIdentity getServiceDiscoveryEnvironment]];
            break;
    }
    
    if (!micrositeID) {
        return nil;
    }
    
    NSString * locale = [self.aiAppInfra.internationalization getUILocaleString];
    locale = [self localeCorrectionForSDServer:locale];
    NSString *URLString = [NSString stringWithFormat:@"https://%@/api/v1/discovery/%@/%@?locale=%@&tags=%@",environment,sector,micrositeID,locale,appState];
    
    NSString *countryCode = [self savedCountryCode];
    if (countryCode == nil) {
        countryCode = [self getCountryCodeFromSIM];
        if (countryCode) {
            [self saveCountryCode:countryCode sourceType:sourceTypeSIM];
        }
    }
    
    if(countryCode.length>0) {
        NSString *mappedCountry = [self getCountryMapping:countryCode];
        if (mappedCountry) {
            countryCode = mappedCountry;
        }
        URLString = [NSString stringWithFormat:@"%@&country=%@",URLString,countryCode];
    }
    return URLString;
}


//for some locales os is giving region code as country
-(NSString*)localeCorrectionForSDServer:(NSString*)localeString {
    
    NSString *localeCountry = [[NSLocale localeWithLocaleIdentifier:localeString] objectForKey:NSLocaleCountryCode];
    if ([[NSLocale ISOCountryCodes] containsObject:localeCountry]){
        return localeString;
    }
    return [[NSLocale localeWithLocaleIdentifier:localeString] objectForKey:NSLocaleLanguageCode];
}


-(NSString *)getCachedURLsPathForURLType:(AISDURLType)URLType {
    NSString * fileName;
    switch (URLType) {
        case AISDURLTypeProposition:
            fileName = @"SDURLs.json";
            break;
        case AISDURLTypePlatform:
            fileName = @"SDURLsPlatform.json";
            break;
    }
    return [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:fileName];
}


-(BOOL)savedURLsOlderthan24Hours {
    NSDate *now = [NSDate date];
    int daysToAdd = 1;
    NSDate *lastDownloadedDate = [[NSUserDefaults standardUserDefaults]objectForKey:lastUpdatedTime];
    NSDate *lastDownloadedDatePlusDay = [lastDownloadedDate dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    if([lastDownloadedDatePlusDay compare:now]==NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}


-(BOOL)isPropostionEnabled{
    NSError *error;
    BOOL isPropostionEnabled = [[self.aiAppInfra.appConfig getPropertyForKey:appConfigSDDownloadMode
                                                                       group:appConfigAppInfraGroup
                                                                       error:&error] boolValue];
    if (error || isPropostionEnabled) {
        return YES;
    }
    return NO;
    
}


-(BOOL)isRefreshRequired {
    NSString * URLStringPlatform = [self getSDURLForType:AISDURLTypePlatform];
    NSString * savedURLPlatform = [self.aiAppInfra.storageProvider fetchValueForKey:SDURLPlatformKey
                                                                              error:nil];
    
    if ([self isPropostionEnabled]){
        NSString * URLStringProposition = [self getSDURLForType:AISDURLTypeProposition];
        NSString * savedURLProposition = [self.aiAppInfra.storageProvider fetchValueForKey:SDURLKey
                                                                                     error:nil];
        if (savedURLProposition && URLStringProposition) {
            //if previously saved URL differs from current proposition URL, URLs are expired
            if (![savedURLProposition isEqualToString:URLStringProposition]) {
                return YES;
            }
        } else {
            return YES;
        }
    }
    
    if (savedURLPlatform && URLStringPlatform) {
        //if previously saved URL differs from current platform URL, URLs are expired
        if (![savedURLPlatform isEqualToString:URLStringPlatform]) {
            return YES;
        }
    } else {
        return YES;
    }
    return NO;
}


//returns the cached URLs.
-(AISDURLs *)getCachedData {
    AISDModel * propositionURLs = [self getModelFromFile:[self getCachedURLsPathForURLType:AISDURLTypeProposition]];
    AISDModel * platformURLs = [self getModelFromFile:[self getCachedURLsPathForURLType:AISDURLTypePlatform]];
    
    if (propositionURLs || platformURLs) {
        AISDURLs * SDURLs = [[AISDURLs alloc]initWithAppInfra:self.aiAppInfra];
        if ([self isPropostionEnabled]) {
            SDURLs.propositionURLs = propositionURLs;
        }
        SDURLs.platformURLs = platformURLs;
        return SDURLs;
    }
    return nil;
}


-(AISDModel *)getModelFromFile:(NSString *)filePath {
    NSData * data;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        data = [NSData dataWithContentsOfFile:filePath];
    }
    if (data) {
        NSError * error;
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            NSDictionary * payload = [json objectForKey:payloadKey];
            AISDModel * model = [[AISDModel alloc]initWithDictionary:payload
                                                            appInfra:self.aiAppInfra];
            if (model.matchByCountry && model.matchByLanguage && model.country) {
                return model;
            }
        }
    }
    return nil;
}


-(void)storeURLString:(NSString *)URLString URLType:(AISDURLType)URLType {
    NSString * storeKey;
    switch (URLType) {
        case AISDURLTypeProposition:
            storeKey = SDURLKey;
            break;
            
        case AISDURLTypePlatform:
            storeKey = SDURLPlatformKey;
            break;
    }
    //save the SD URL in secure storage. It is used for expiring downloaded data
    [self.aiAppInfra.storageProvider storeValueForKey:storeKey value:URLString error:nil];
}


-(void)cacheDownloadedURLs:(NSDictionary *)downloadedJson
                 URLString:(NSString *)URLString
                   URLType:(AISDURLType)URLType {
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:downloadedJson options:0 error:&error];
    if (error) {
        [AIInternalLogger log:AILogLevelError eventId:eventID message:@"Error in saving URLs"];
    } else {
        NSString * path = [self getCachedURLsPathForURLType:URLType];
        NSError * writeError;
        BOOL success = [data writeToFile:path
                                 options:NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication
                                   error:&writeError];
        
        NSString * message;
        AILogLevel level = AILogLevelError;
        if (success) {
            [self storeURLString:URLString URLType:URLType];
            [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:lastUpdatedTime];
            level = AILogLevelDebug;
            message = @"sd datervice saved to file";
        } else {
            message = [NSString stringWithFormat:@"%@ :%@",kAILTagSDDataStoreFailed,
                       writeError.localizedDescription];
            AITaggingError *error = [[AITaggingError alloc] initWithErrorType:@"AISDManager"
                                                                      serverName:nil
                                                                    errorCode:[NSString stringWithFormat:@"%ld", (long)[writeError code]]
                                                                    errorMessage:kAILTagSDDataStoreFailed];
               [self.aiAppInfra.tagging trackErrorAction:AITaggingTechnicalError taggingError:error];
        }
        [AIInternalLogger log:level
                      eventId:eventID
                      message:message];
    }
}


-(void)clearDownloadedURLs {
    NSString * propositionPath = [self getCachedURLsPathForURLType:AISDURLTypeProposition];
    if ([[NSFileManager defaultManager] fileExistsAtPath:propositionPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:propositionPath error:nil];
    }
    NSString * platformPath = [self getCachedURLsPathForURLType:AISDURLTypePlatform];
    if ([[NSFileManager defaultManager] fileExistsAtPath:platformPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:platformPath error:nil];
    }
    [AIInternalLogger log:AILogLevelDebug
                  eventId:eventID
                  message:@"Cleared cached SD data"];
}


-(void)saveCountryCode:(NSString *)countryCode sourceType:(NSString *)sourceType {
    NSError *error;
    [self.aiAppInfra.storageProvider storeValueForKey:secureStorageKeyCountryCode
                                                value:[NSString stringWithFormat:@"%@",countryCode]
                                                error:&error];
    [self.aiAppInfra.storageProvider storeValueForKey:secureStorageKeySourceType
                                                value: [NSString stringWithFormat:@"%@",sourceType]
                                                error:&error];
    
    if(error) {
        AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:@"AISDManager"
                                                               serverName:nil
                                                                errorCode:[NSString stringWithFormat:@"%ld", (long)[error code]]
                                                             errorMessage:kAilTagSetHomeCountrySaveError];
        [self.aiAppInfra.tagging trackErrorAction:AITaggingTechnicalError taggingError:taggingError];
    }
    
    self.homeCountrySourceType = sourceType;
    self.homeCountryCode = countryCode;
    [AIInternalLogger log:AILogLevelDebug
                  eventId:eventID
                  message:[NSString stringWithFormat:@"Country Code: %@",countryCode]];
}


-(NSString *)savedCountryCode {
    NSString * countryCode;
    if (self.homeCountryCode) {
        countryCode = self.homeCountryCode;
    }
    else {
        NSError *error;
        countryCode = [self.aiAppInfra.storageProvider fetchValueForKey:secureStorageKeyCountryCode
                                                                  error:&error];
        self.homeCountryCode = countryCode;
    }
    return countryCode;
}


-(NSString *)savedCountryCodeSourceType {
    NSString * sourceType;
    if (self.homeCountrySourceType) {
        sourceType = self.homeCountrySourceType;
    }
    else {
        sourceType = [self.aiAppInfra.storageProvider fetchValueForKey:secureStorageKeySourceType
                                                                 error:nil];
        self.homeCountrySourceType = sourceType;
    }
    return sourceType;
}


-(NSString*)getCountryMapping:(NSString*)country {
    NSError *error;
    NSDictionary *countryMaps = [self.aiAppInfra.appConfig getPropertyForKey:@"servicediscovery.countryMapping"
                                                                       group:@"appinfra"
                                                                       error:&error];
    if (!error &&
        countryMaps &&
        [countryMaps isKindOfClass:[NSDictionary class]]&&
        countryMaps.count
        ) {
        NSString * countrycode = countryMaps[country];
        if (countrycode && countrycode.length >0) {
            return  countrycode;
        }
    }
    return nil;
}


+(NSError *) getSDError:(AISDError) error {
    NSString * message;
    
    switch (error) {
        case AISDCannotFindURLError:
            message = @"ServiceDiscovery cannot find URL";
            break;
        case AISDMalformedURLError:
            message = @"ServiceDiscovery URL error:Malformed URL";
            break;
        case AISDCannotFindLocaleError:
            message = @"ServiceDiscovery cannot find the locale";
            break;
        case AISDServerNotReachableError:
            message = @"Server is not reachable at the moment,Please try after some time";
            break;
        case AISDServerError:
            message = @"Server Error";
            break;
        case AISDNoNetworkError:
            message = @"Internet is not reachable";
            break;
    }
    
    return [[NSError alloc]initWithDomain:errorDomainAIServiceDisc
                                     code:error
                                 userInfo:@{NSLocalizedDescriptionKey:message}];
}

@end
