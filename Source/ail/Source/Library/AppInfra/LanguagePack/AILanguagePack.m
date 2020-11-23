
//
//  AILanguagePack.m
//  AppInfra
//
//  Created by Hashim MH on 13/03/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AILanguagePack.h"
#import "AIUtility.h"
#define kErrorDomainAILanguagePack @"com.philips.platform.appinfra.languagePack"
#define kLanguagePackEventID @"AILanguagePack"
#define kLanguagePackKey @"languagePack.serviceId"
#import "AppInfra.h"
#import "AIInternalLogger.h"

@interface AILanguagePack() {
    NSDictionary *languagePackOverview;
    NSDictionary *cloudLocalization;
}
@property(nonatomic,weak) id<AIAppInfraProtocol> aiAppInfra;
@property(nonatomic,strong) NSDictionary *cachedLanguagePackOverviewDetails;
@property(nonatomic,weak) id<AIRESTClientProtocol> RESTClient;

@end


@implementation AILanguagePack
@synthesize cachedLanguagePackOverviewDetails = _cachedLanguagePackOverviewDetails;

#pragma mark init methods
- (nullable instancetype)initWithAppInfra:(nonnull id<AIAppInfraProtocol> )appInfra {
    
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
        [self invalidateLanguagePack];
    }
    return self;
    
}


-(void)invalidateLanguagePack {
    BOOL isDownloadedPackInvalid = NO;
    
    if (self.cachedLanguagePackOverviewDetails &&
        self.cachedLanguagePackOverviewDetails[@"locale"] &&
        ![self.cachedLanguagePackOverviewDetails[@"locale"] isEqualToString:[self getPreferredLocales]]) {
        isDownloadedPackInvalid = YES;
    }
    
    if (isDownloadedPackInvalid) {
        [self removeFileAtPath:[self metedataFilePath]];
        [self removeFileAtPath:[self activatedJasonFilePath]];
        [self removeFileAtPath:[self downloadedJasonFilePath]];
        [AIInternalLogger log:AILogLevelDebug
                      eventId:kLanguagePackEventID
                      message:@"Deleting old languagepack files"];
        
    }
}


-(void)removeFileAtPath:(NSString*)path {
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


-(id<AIRESTClientProtocol>)RESTClient {
    if (!_RESTClient) {
        self.RESTClient = [self.aiAppInfra.RESTClient createInstanceWithBaseURL:nil];
        self.RESTClient.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    return _RESTClient;
}

#pragma mark Public APIs

-(void)refresh:(nullable void(^)(AILPRefreshStatus refreshResult,NSError * _Nullable error))completionHandler {
    AILPRefreshStatus refreshResult = AILPRefreshStatusNoRefreshRequired;
    NSError *refreshError;
    
    NSString *serviceId =  [self getServiceIdWithError:&refreshError];
    if (serviceId && !refreshError) {
        [self downloadOverviewFileforServiceId:serviceId withCompletion:completionHandler];
        return;
    }
    refreshResult = AILPRefreshStatusRefreshFailed;
    if (completionHandler) {
        completionHandler(refreshResult,refreshError);
    }
}

#pragma mark Helper Methods

-(NSString*)getServiceIdWithError:(NSError* __autoreleasing *)error  {
    //read service id from appconfig
    NSError *appConfigError;
    NSString *serviceId = [self.aiAppInfra.appConfig
                           getPropertyForKey:kLanguagePackKey
                           group:@"appinfra"
                           error:&appConfigError];
    
    NSAssert(!serviceId || [serviceId isKindOfClass:[NSString class]], @"language pack serviceID should be string");
    NSAssert(!serviceId || serviceId.length>0, @"language pack serviceID cannot be empty in App config  file");
    
    if (serviceId && !appConfigError && [serviceId isKindOfClass:[NSString class]]) {
        [AIInternalLogger log:AILogLevelDebug
                      eventId:kLanguagePackEventID
                      message:serviceId];
        return serviceId;
    }
    else if (appConfigError) {
        [AIInternalLogger log:AILogLevelError
                      eventId:kLanguagePackEventID
                      message:appConfigError.localizedDescription];
        //return error
        if (error!= NULL) {
            *error = appConfigError;
        }
        return  nil;
        
    }
    
    [AIInternalLogger log:AILogLevelError
                  eventId:kLanguagePackEventID
                  message:@"Invalid Service ID for Language Pack"];
    //return error
    if(error!= NULL){
        *error = [[NSError alloc]initWithDomain:kErrorDomainAILanguagePack
                                           code:AILPErrorServiceIdError
                                       userInfo:@{NSLocalizedDescriptionKey:@"Invalid ServiceID"}];
    }
    return  nil;
}


-(void)downloadOverviewFileforServiceId:(NSString*)serviceId
                         withCompletion:(nullable void(^)(AILPRefreshStatus refreshResult,NSError * _Nullable error))completionHandler {
    [self.aiAppInfra.serviceDiscovery getServicesWithCountryPreference:@[serviceId] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *error) {
        AISDService *service = services[serviceId];
        [AIInternalLogger log:AILogLevelDebug
                      eventId:kLanguagePackEventID
                      message:service.url];
        if (service.url && !error) {
            [self.RESTClient GET:service.url
                      parameters:nil
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             if (responseObject) {
                                 self->languagePackOverview = responseObject;
                                 [AIInternalLogger log:AILogLevelDebug
                                               eventId:kLanguagePackEventID
                                               message:[responseObject description]];
                                 if ([self shouldUpdateCurrentLanguagePack]) {
                                     [self downloadLanguagePackWithCompletion:completionHandler];
                                 } else {
                                     if (completionHandler != nil) {
                                         completionHandler(AILPRefreshStatusNoRefreshRequired,nil);
                                     }
                                 }
                             } else {
                                 [AIInternalLogger log:AILogLevelError
                                               eventId:kLanguagePackEventID
                                               message:@"Empty overview file"];
                                 NSError *noDataError =[[NSError alloc]initWithDomain:kErrorDomainAILanguagePack
                                                                                 code:AILPErrorServiceIdError
                                                                             userInfo:@{NSLocalizedDescriptionKey:@"Not able to read overview file"}];
                                 if (completionHandler) {
                                     completionHandler(AILPRefreshStatusRefreshFailed,noDataError);
                                 }
                             }
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull rerror) {
                             
                             [AIInternalLogger log:AILogLevelError
                                           eventId:kLanguagePackEventID
                                           message:rerror.localizedDescription];
                             if (completionHandler) {
                                 completionHandler(AILPRefreshStatusRefreshFailed,rerror);
                             }
                         }];
        } else {
            if (completionHandler) {
                completionHandler(AILPRefreshStatusRefreshFailed,error);
            }
        }
        
    } replacement:nil];
}


-(void)downloadLanguagePackWithCompletion:(nullable void(^)(AILPRefreshStatus refreshResult,NSError * _Nullable error))completionHandler {
    NSDictionary *localeInfo =[self getPreferredLanguagePackInfo];
    NSString *url = localeInfo[@"url"];
    
    if (!url) {
        NSError *noDataError =[[NSError alloc]initWithDomain:kErrorDomainAILanguagePack
                                                        code:AILPErrorFatalError
                                                    userInfo:@{NSLocalizedDescriptionKey:@"Not able to find the url for language pack"}];
        [AIInternalLogger log:AILogLevelError
                      eventId:kLanguagePackEventID
                      message:[noDataError userInfo][NSLocalizedDescriptionKey]];
        if (completionHandler) {
            completionHandler(AILPRefreshStatusRefreshFailed,noDataError);
        }
        return;
    }
    [AIInternalLogger log:AILogLevelDebug
                  eventId:kLanguagePackEventID
                  message:[NSString stringWithFormat:@"Downloading Language Pack from %@",url]];
    //TODO: delete the downloaded lp and info
    [self.RESTClient GET:url
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (responseObject) {
                         [AIInternalLogger log:AILogLevelDebug
                                       eventId:kLanguagePackEventID
                                       message:[responseObject description]];
                         NSString *dataPath = [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack"];
                         NSError *error;
                         if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])//Check
                             [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                                       withIntermediateDirectories:NO
                                                                        attributes:nil
                                                                             error:&error]; //Will Create folder
                         NSString *path = [self downloadedJasonFilePath];
                         NSDictionary *data = (NSDictionary *)responseObject;
                         if (data && [data isKindOfClass:[NSDictionary class]] && [[data allKeys] count] > 0) {
                             [data writeToFile:path atomically:YES];
                             NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                                    error:nil];
                             if (![attrs[NSFileProtectionKey]
                                   isEqual:NSFileProtectionComplete]) {
                                 attrs = @{NSFileProtectionKey:NSFileProtectionComplete};
                                 [[NSFileManager defaultManager] setAttributes:attrs
                                                                  ofItemAtPath:path
                                                                         error:nil];
                             }
                             [AIInternalLogger log:AILogLevelDebug
                                           eventId:kLanguagePackEventID
                                           message:@"language pack succesfully downloaded"];
                             
                             self.cachedLanguagePackOverviewDetails = localeInfo;
                             [self updateLanguagePackLocalInfo];
                             if (completionHandler) {
                                 completionHandler(AILPRefreshStatusRefreshedFromServer,nil);
                             }
                         } else {
                             [AIInternalLogger log:AILogLevelError eventId:kLanguagePackEventID message:@"language pack Content Invalid"];
                             NSError *InvalidDataError = [[NSError alloc]initWithDomain:kErrorDomainAILanguagePack
                                                                                   code:AILPErrorInvalidJson
                                                                               userInfo:@{NSLocalizedDescriptionKey:@"Not able to convert the content of file to dictionary"}];
                             if(completionHandler) {
                                 completionHandler(AILPRefreshStatusRefreshFailed,InvalidDataError);
                             }
                         }
                     } else {
                         [AIInternalLogger log:AILogLevelError
                                       eventId:kLanguagePackEventID
                                       message:@"Empty language pack"];
                         NSError *noDataError =[[NSError alloc]initWithDomain:kErrorDomainAILanguagePack
                                                                         code:AILPErrorServiceIdError
                                                                     userInfo:@{NSLocalizedDescriptionKey:@"Not able to read languagePack file"}];
                         if (completionHandler) {
                             completionHandler(AILPRefreshStatusRefreshFailed,noDataError);
                         }
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     [AIInternalLogger log:AILogLevelError
                                   eventId:kLanguagePackEventID
                                   message:error.localizedDescription];
                     if (completionHandler) {
                         completionHandler(AILPRefreshStatusRefreshFailed,error);
                     }
                 }];
}


-(NSDictionary *)getPreferredLanguagePackInfo {
    NSString *preferredLocale = [self getPreferredLocales];
    preferredLocale = [preferredLocale stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    if (languagePackOverview && languagePackOverview[@"languages"] && [languagePackOverview[@"languages"] count] )
    {
        NSArray *availableLocalizations = languagePackOverview[@"languages"];
        for (NSDictionary *lpInfo in availableLocalizations) {
            if ([preferredLocale isEqualToString:lpInfo[@"locale"]]) {
                return lpInfo;
            }
        }
    }
    return nil;
}


-(NSString*)getPreferredLocales {
    return [self.aiAppInfra.internationalization getUILocaleString];
}


-(BOOL)shouldUpdateCurrentLanguagePack {
    BOOL shouldUpdateLanguagePack = true;
    NSString *currentLocale = [self getPreferredLanguagePackInfo][@"locale"];
    if (self.cachedLanguagePackOverviewDetails != nil && languagePackOverview != nil) {
        NSArray *overviewFileContent = languagePackOverview[@"languages"];
        NSArray *allLocales = [overviewFileContent valueForKey:@"locale"];
        if([allLocales containsObject:currentLocale]) {
            NSUInteger index = [allLocales indexOfObject:currentLocale];
            NSDictionary *newLocaleDictionary = [overviewFileContent objectAtIndex:index];
            if (([[newLocaleDictionary valueForKey:@"url"] isEqualToString:[self.cachedLanguagePackOverviewDetails valueForKey:@"url"]]) && ([[newLocaleDictionary valueForKey:@"remoteVersion"] intValue] <=[[self.cachedLanguagePackOverviewDetails valueForKey:@"remoteVersion"]intValue])) {
                shouldUpdateLanguagePack = false;
            }
        }
    }
    
    return shouldUpdateLanguagePack;
}


-(void)activate:(nullable void(^)(AILPActivateStatus activatedStatus,NSError * _Nullable error))completionHandler {
    AILPActivateStatus activatedStatus = AILPActivateStatusNoUpdateStored;
    NSError *activateError = nil;
    NSString *downloadedJsonPath = [self downloadedJasonFilePath];
    NSString *activatedJsonPath = [self activatedJasonFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:downloadedJsonPath]) {
        if (![[NSFileManager defaultManager]fileExistsAtPath:activatedJsonPath]) {
            NSDictionary *downloadedJsonDict = [NSDictionary dictionaryWithContentsOfFile:downloadedJsonPath];
            [downloadedJsonDict writeToFile:activatedJsonPath atomically:true];
            [[NSFileManager defaultManager] removeItemAtPath:downloadedJsonPath
                                                       error:&activateError];
        } else {
            [[NSFileManager defaultManager]replaceItemAtURL:[NSURL URLWithString:activatedJsonPath]
                                              withItemAtURL:[NSURL URLWithString:downloadedJsonPath]
                                             backupItemName:nil
                                                    options:NSFileManagerItemReplacementUsingNewMetadataOnly
                                           resultingItemURL:nil
                                                      error:&activateError];
        }
        cloudLocalization = [NSDictionary dictionaryWithContentsOfFile:activatedJsonPath];
        NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:activatedJsonPath
                                                                               error:&activateError];
        if (![attrs[NSFileProtectionKey] isEqual:NSFileProtectionComplete]) {
            attrs = @{NSFileProtectionKey:NSFileProtectionComplete};
            [[NSFileManager defaultManager] setAttributes:attrs
                                             ofItemAtPath:activatedJsonPath
                                                    error:&activateError];
        }
        activatedStatus = (activateError == nil)? AILPActivateStatusUpdateActivated:AILPActivateStatusFailed;
        if (activateError != nil) {
            [AIInternalLogger log:AILogLevelError
                          eventId:kLanguagePackEventID
                          message:[activateError userInfo][NSLocalizedDescriptionKey]];
        } else {
            [AIInternalLogger log:AILogLevelDebug
                          eventId:kLanguagePackEventID
                          message:[NSString stringWithFormat:@"Activated Language Pack at %@",activatedJsonPath]];
        }
    } else if (![[NSFileManager defaultManager]fileExistsAtPath:activatedJsonPath]) {
        activatedStatus = AILPActivateStatusFailed;
        activateError =[[NSError alloc]initWithDomain:kErrorDomainAILanguagePack
                                                 code:AILPErrorServiceIdError
                                             userInfo:@{NSLocalizedDescriptionKey:@"No Language Pack Available"}];
        [AIInternalLogger log:AILogLevelError
                      eventId:kLanguagePackEventID
                      message:[activateError userInfo][NSLocalizedDescriptionKey]];
    }
    if (completionHandler != nil) {
        completionHandler(activatedStatus,activateError);
    }
}


-(void)updateLanguagePackLocalInfo {
    
    NSString *localeInfoSavePath = [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:localeInfoSavePath])//Check
        [[NSFileManager defaultManager] createDirectoryAtPath:localeInfoSavePath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error]; //Will Create folder
    
    NSString *path = [self metedataFilePath];
    if (self.cachedLanguagePackOverviewDetails) {
        [self.cachedLanguagePackOverviewDetails writeToFile:path atomically:true];
        NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                               error:nil];
        if (![attrs[NSFileProtectionKey] isEqual:NSFileProtectionComplete]) {
            attrs = @{NSFileProtectionKey:NSFileProtectionComplete};
            [[NSFileManager defaultManager] setAttributes:attrs ofItemAtPath:path error:nil];
        }
    }
}


-(NSString*)description {
    return  [languagePackOverview description];
}

#pragma mark Custom Getters

- (NSDictionary *)cachedLanguagePackOverviewDetails {
    if (_cachedLanguagePackOverviewDetails == nil) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self metedataFilePath]]) {
            _cachedLanguagePackOverviewDetails = [NSDictionary dictionaryWithContentsOfFile:[self metedataFilePath]];
        }
        return _cachedLanguagePackOverviewDetails;
        
    }
    return _cachedLanguagePackOverviewDetails;
}


- (nullable NSString *)localizedStringForKey:(NSString *_Nonnull)key {
    return [self localizedStringForKey:key value:@""];
}


- (NSString *)localizedStringForKey:(NSString *)key value:(nullable NSString *)value {
    if (!cloudLocalization) {
        cloudLocalization = [NSDictionary dictionaryWithContentsOfFile:[self activatedJasonFilePath]];
    }
    if (key && cloudLocalization) {
        NSString *cloudValue = cloudLocalization[key];
        if (!cloudValue) {
            cloudValue =   [NSBundle.mainBundle localizedStringForKey:key value:value table:nil];
        }
        return cloudValue ? cloudValue : value;
    }
    value = [NSBundle.mainBundle localizedStringForKey:key value:value table:nil];
    return value;
}


-(NSString*)metedataFilePath{
    return [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack/LangPackMetadata.json"];
}


-(NSString*)activatedJasonFilePath{
    return [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack/ActivatedLangPack.json"];
}


-(NSString*)downloadedJasonFilePath{
    return  [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack/DownloadedLangPack.json"];
}
@end
