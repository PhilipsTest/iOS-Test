//
//  AIAppConfiguration.m
//  AppInfra
//
//  Created by leslie on 01/08/16.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AIAppConfiguration.h"
#import "AppInfra.h"
#import "AIStorageProvider.h"
#import "AIUtility.h"
#import "AIInternalLogger.h"
NSString * const AppConfigCloudRefreshCompletedNotification = @"AppConfigCloudRefreshCompletedNotification";

#define kAppConfigName @"AppConfig"
#define kAppConfigSecureStoreKey @"ail.app_config"
#define kAppDynamicConfigSecureStoreKey @"ail.app_dynamic_config"

#define kErrorDomainAIAppConfig              @"com.philips.platform.appinfra.AppConfiguration"
#define kGroupNotExists    @"The given group doesn't exists"
#define kKeyNotExists      @"The given key doesn't exists"
#define kNoDataForGroup    @"No data found for the given group"
#define kNoDataForKey      @"No data found for the given key"
#define kErrorDeviceStore       @"DeviceStore Error"

#define kExceptionInvalidArgumentsReason @"Invalid Parameters"
static NSString *const aiACEventId = @"AIAppConfig";
static NSString *const cloudConfigFileName = @"CloudConfig.json";
static NSString *const cloudURLKey = @"ail.cloudconfig";

@interface AIAppConfiguration()

@property(nonatomic,strong)NSDictionary *configuration;
@property(nonatomic,strong)NSDictionary *staticConfiguration;
@property(nonatomic,strong)NSDictionary *cloudConfiguration;
@property(nonatomic,strong) id<AIAppInfraProtocol> aiAppInfra;
@property(nonatomic, strong)NSLock *downloadLock;

@end

@implementation AIAppConfiguration

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
        self.configuration = [self getSavedConfig];
        self.cloudConfiguration = [self savedCouldConfig];
        self.staticConfiguration = [self readAppConfigurationFromFile];
        self.downloadLock = [NSLock new];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(serviceDiscoveryUpdated)
                                                     name:ServiceDiscoveryDataDownloadCompletedNotification
                                                   object:nil];
    }
    return self;
}

-(void)serviceDiscoveryUpdated{
    [self refreshCloudConfig:^(AIACRefreshResult refreshResult, NSError *error) {
        if (refreshResult == AIACRefreshResultRefreshedFromServer) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AppConfigCloudRefreshCompletedNotification
                                                                object:nil];
        }
    }];
}

-(BOOL)isValidKey:(NSString *)key {
    NSString *characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-";
    NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString
                                          :characters] invertedSet];
    return ([key rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}


//for checking empty and nil strings
-(BOOL)isEmptyString:(NSString *)string {
    
    if (string == nil) {
        return YES;
    }
    
    if(string.length==0
       || [string stringByReplacingOccurrencesOfString:@" " withString:@""].length ==0)
    {
        return YES;
    }
    return NO;
}

//checking whether value type is either String, Number, Array of Strings, Array of Numbers
-(BOOL)isValidValue:(id)value {
    if([AIUtility isNull:value]) {
        return YES;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray * arr = (NSArray *)value;
        for (id element in arr) {
            if (![element isKindOfClass:[NSString class]]
                && ![element isKindOfClass:[NSNumber class]]) {
                return NO;
            }
        }
        return YES;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary*dict = (NSDictionary *)value ;
        NSArray * arr = [dict allKeys];
        for (id key in arr) {
            if (![self isValidValue:dict[key]]) {
                return NO;
            }
        }
        return YES;
    }
    [AIInternalLogger log:AILogLevelError
                  eventId:aiACEventId
                  message:@"Trying to save unsupported value"];
    return NO;
}

-(id)propertyForKey:(NSString *)key
              group:(NSString *)group
              error:(NSError * __autoreleasing *)error
             source:(NSDictionary *)source {
    NSString * uppercaseKey = [[key copy] uppercaseString];
    group = [group uppercaseString];
    NSString * errorDesc = @"";
    AIACError errorCode = AIACErrorNoError;
    
    if([self isEmptyString:group] ||
       [self isEmptyString:uppercaseKey] ||
       ![self isValidKey:uppercaseKey] ||
       ![self isValidKey:group])
    {
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                         reason:kExceptionInvalidArgumentsReason
                                                       userInfo:nil];
        @throw exception;
    }
    else {
        if (source == NULL) {
            // error fetching from secure storage
            errorDesc = kErrorDeviceStore;
            errorCode = AIACErrorDeviceStoreError;
        }
        
        else if (![AIUtility isNull:source]) {
            if ([[source allKeys] containsObject:group]) {
                NSDictionary * groupDict = [source valueForKey:group];
                if (![AIUtility isNull:groupDict] && [[groupDict allKeys]containsObject:uppercaseKey]) {
                    id value = groupDict[uppercaseKey];
                    if ([AIUtility isNull:value]) {
                        // value is nil
                        errorDesc = kNoDataForKey;
                        errorCode = AIACErrorNoDataFoundForKey;
                    }
                    else {
                        //found value
                        return value;
                    }
                }
                else {
                    //group is nil
                    errorDesc = kKeyNotExists;
                    errorCode = AIACErrorKeyNotExists;
                }
            }
            else {
                // group doesnt exists
                errorDesc = kGroupNotExists;
                errorCode = AIACErrorGroupNotExists;
            }
            
        }
        if(error!= NULL){
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey:errorDesc};
            *error = [[NSError alloc]initWithDomain:kErrorDomainAIAppConfig
                                               code:errorCode
                                           userInfo:userInfo];
        }
        return nil;
    }
    
}

-(id)getDefaultPropertyForKey: (NSString *)key group:(NSString *)group error:(NSError * __autoreleasing *)error{
    
    if (!self.staticConfiguration) {
        self.staticConfiguration = [self readAppConfigurationFromFile];
    }
    return [self propertyForKey:key group:group error:error source:self.staticConfiguration];
}

-(id)getPropertyForKey: (NSString *)key group:(NSString *)group error:(NSError * __autoreleasing *)error {
    if(!self.configuration)
        self.configuration = [self getSavedConfig];
    NSError *dynamicReadError;
    id dynamicValue =  [self propertyForKey:key
                                      group:group
                                      error:&dynamicReadError
                                     source:self.configuration];
    if ( dynamicValue && !dynamicReadError ) {
        NSString *message = [NSString stringWithFormat:@"value of %@ reading from dynamic",key];
        [AIInternalLogger log:AILogLevelDebug
                      eventId:aiACEventId
                      message:message];
        return dynamicValue;
    }
    else if (![[dynamicReadError localizedDescription] isEqualToString: kKeyNotExists] &&
             ![[dynamicReadError localizedDescription] isEqualToString: kGroupNotExists] &&
             self.configuration ){
        //return error
        if(error!= NULL) {
            *error = dynamicReadError;
        }
        return nil;
    }
    NSError *cloudReadError;
    id cloudValue = [self propertyForKey:key
                                   group:group
                                   error:&cloudReadError
                                  source:self.cloudConfiguration];
    if (cloudValue && !cloudReadError) {
        NSString *message = [NSString stringWithFormat:@"value of %@ reading from cloud",key];
        [AIInternalLogger log:AILogLevelDebug
                      eventId:aiACEventId
                      message:message];
        
        return cloudValue;
    }
    else if (![[cloudReadError localizedDescription] isEqualToString: kKeyNotExists] &&
             ![[cloudReadError localizedDescription] isEqualToString: kGroupNotExists]&&
             self.cloudConfiguration){
        //return error
        if(error!= NULL) {
            *error = cloudReadError;
        }
        return nil;
    }
    return [self propertyForKey:key group:group error:error source:self.staticConfiguration];
}

-(BOOL)setPropertyForKey: (NSString *)key group:(NSString *)group
                   value:(id)value
                   error:(NSError * __autoreleasing *)error {
    NSString * uppercaseKey = [[key copy] uppercaseString];
    NSString * uppercaseGroup = [group uppercaseString];
    NSString * errorDesc;
    AIACError errorCode = AIACErrorNoError;
    
    if ([self isEmptyString:uppercaseGroup] ||
        [self isEmptyString:uppercaseKey] ||
        ![self isValidKey:uppercaseKey] ||
        ![self isValidKey:uppercaseGroup] ||
        ![self isValidValue:value]) {
        NSAssert(0, kExceptionInvalidArgumentsReason);
        [AIInternalLogger log:AILogLevelError
                      eventId:aiACEventId
                      message:kExceptionInvalidArgumentsReason];
    }
    else {
        if(!self.configuration)
            self.configuration = [self getSavedConfig];
        
        if (self.configuration == nil) {
            self.configuration = [[NSMutableDictionary alloc]init];
        }
        //create new group dictionary
        NSMutableDictionary * mutableConfig = [self.configuration mutableCopy];
        NSMutableDictionary *groupDict = [self.configuration valueForKey:uppercaseGroup];
        if ([[self.configuration allKeys] containsObject:uppercaseGroup] && ![AIUtility isNull:groupDict]) {
            
            // setting value
            [groupDict setValue:value forKey:uppercaseKey];
        } else {
            // group doesnt exists
            groupDict = [[NSMutableDictionary alloc]init];
            [groupDict setValue:value forKey:uppercaseKey];
            [mutableConfig setValue:groupDict forKey:uppercaseGroup];
            self.configuration = mutableConfig;
        }
        //saving to secure storage
        BOOL storeSuccess = [self storeConfigSecurely:self.configuration];
        if (storeSuccess == YES) {
            return YES;
        }
        // error from secure storage
        errorDesc = kErrorDeviceStore;
        errorCode = AIACErrorDeviceStoreError;
        //update local cache because there can be mis match with secure storage
        self.configuration = [self getSavedConfig];
    }
    if(error!= NULL){
        NSDictionary * userInfo = @{NSLocalizedDescriptionKey:errorDesc};
        *error = [[NSError alloc]initWithDomain:kErrorDomainAIAppConfig code:errorCode
                                       userInfo:userInfo];
    }
    return NO;
}

//getting app configuration from app bundle
-(NSDictionary *)readAppConfigurationFromFile
{
    NSDictionary* json;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:kAppConfigName ofType:@"json"];
    NSAssert([[NSFileManager defaultManager]fileExistsAtPath:jsonPath]
             , @"AppConfig json file should be added to the bundle");
    NSData * data = [NSData dataWithContentsOfFile:jsonPath];
    NSError * error;
    
    json = [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers
                                             error:&error];
    NSAssert((json != nil || error == nil), @"Error reading AppConfig json");
    json = [self uppercaseKeysForDictionary:json];
    if ( ![[NSFileManager defaultManager]fileExistsAtPath:jsonPath] || !json || error ) {
        [AIInternalLogger log:AILogLevelError
                      eventId:aiACEventId
                      message:@"valid json file AppConfig.json is not found"];
    }
    return json;
}

//storing in secure storage
-(BOOL)storeConfigSecurely:(NSDictionary *)config {
    
    NSError * storeError;
    NSDictionary * uppercaseConfig = [self uppercaseKeysForDictionary:config];
    @synchronized (self) {
        [self.aiAppInfra.storageProvider storeValueForKey:kAppDynamicConfigSecureStoreKey
                                                    value:uppercaseConfig
                                                    error:&storeError];
    }
    if (storeError == NULL) {
        return YES;
    }
    [AIInternalLogger log:AILogLevelError
                  eventId:aiACEventId
                  message:@"ERROR while storing app config to secure storage"];
    
    return NO;
}


//getting saved config from secure storage
-(NSDictionary *)getSavedConfig{
    [self migrateIfNeeded];
    NSError * fetchError;
    NSDictionary * appConfig = (NSDictionary *)[self.aiAppInfra.storageProvider
                                                fetchValueForKey:kAppDynamicConfigSecureStoreKey
                                                error:&fetchError];
    if (appConfig == nil || fetchError != nil || ![appConfig isKindOfClass:[NSDictionary class]]) {
        //error fetching saved config in secure storage
        return nil;
    }
    appConfig = [self uppercaseKeysForDictionary:appConfig];
    return appConfig;
}


//migrate old data to new key
-(void)migrateIfNeeded{
    NSError * fetchError;
    NSDictionary *oldAppConfig;
    oldAppConfig = (NSDictionary *) [self.aiAppInfra.storageProvider fetchValueForKey:kAppConfigSecureStoreKey
                                                                                error:&fetchError];
    if (oldAppConfig != nil && fetchError == nil && [oldAppConfig isKindOfClass:[NSDictionary class]]) {
        NSDictionary *staticConfig = [self readAppConfigurationFromFile];
        NSMutableDictionary *migratedConfig = [[NSMutableDictionary alloc]init];
        for (NSString *key in oldAppConfig) {
            if (staticConfig[key]) {
                NSDictionary *migratedGroupConfig;
                migratedGroupConfig = [self removeCommonKeysforDictionary:oldAppConfig[key]
                                                           withDictionary:staticConfig[key]];
                [migratedConfig setValue:migratedGroupConfig forKey:key];
            }
            else{
                [migratedConfig setValue:oldAppConfig[key] forKey:key];
            }
            
        }
        [AIInternalLogger log:AILogLevelDebug
                      eventId:aiACEventId
                      message:@"Migrating old config data"];
        [self storeConfigSecurely:migratedConfig];
        [self.aiAppInfra.storageProvider storeValueForKey:kAppConfigSecureStoreKey
                                                    value:[NSNull null] error:nil];
    }
}


-(NSDictionary*)removeCommonKeysforDictionary:(NSDictionary*)dictionary1
                               withDictionary:(NSDictionary*)dictionary2
{
    NSMutableDictionary *resultDict = [dictionary1 mutableCopy];
    for (NSString *key in [dictionary1 allKeys]) {
        
        if (dictionary2[key] &&
            [dictionary1[key] isEqual: dictionary2[key]]) {
            [resultDict removeObjectForKey:key];
        }
    }
    return resultDict;
}


//convert two level of keys to uppercase string
-(NSDictionary*)uppercaseKeysForDictionary:(NSDictionary*)inputDict{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    for (NSString *key in [inputDict allKeys]) {
        id value = inputDict[key];
        [dictionary removeObjectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *innerDict = [[NSMutableDictionary alloc]init];
            for (NSString *ikey in [value allKeys]) {
                id innerValue = value[ikey];
                [innerDict removeObjectForKey:ikey];
                [innerDict setObject:innerValue forKey:[ikey uppercaseString]];
            }
            value = innerDict;
        }
        [dictionary setObject:value forKey:[key uppercaseString]];
        
    }
    inputDict = dictionary;
    return inputDict;
}


#pragma mark - cloud config methods
-(void)refreshCloudConfig :(void(^)(AIACRefreshResult, NSError*))completionHandler {
    if([self.downloadLock tryLock]) {
        [self downloadConfigFromCloud:^(AIACRefreshResult refreshResult, NSError *error) {
            if (completionHandler) {
                completionHandler(refreshResult,error);
            }
            [self.downloadLock unlock];
        }];
    } else {
        NSString * errorDesc = @"Download is in progress, Please try after some time";
        [AIInternalLogger log:AILogLevelVerbose
                      eventId:aiACEventId
                      message:errorDesc];
        
        NSDictionary * userInfo = @{NSLocalizedDescriptionKey:errorDesc};
        NSError *error = [[NSError alloc]initWithDomain:kErrorDomainAIAppConfig
                                                   code:AIACErrorDownloadInProgress
                                               userInfo:userInfo];
        
        if (completionHandler) {
            completionHandler(AIACRefreshResultRefreshFailed,error);
        }
    }
}


- (void)clearCloudConfigFile :(NSError * __autoreleasing *)error {
    [AIInternalLogger log:AILogLevelVerbose
                  eventId:aiACEventId
                  message:@"clearing cloud config file"];
    
    NSError *errorRead;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self cloudConfigPath]]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[self cloudConfigPath]
                                                                  error:&errorRead];
        if (success) {
            self.cloudConfiguration = nil;
            [self.aiAppInfra.storageProvider removeValueForKey:cloudURLKey];
        } else {
            [AIInternalLogger log:AILogLevelError
                          eventId:aiACEventId
                          message:errorRead.localizedDescription];
            if(error)
                *error = errorRead;
        }
    }
}


-(void)downloadConfigFromCloud:(void(^)(AIACRefreshResult, NSError *))completionHandler {
    NSError * configError;
    NSString * cloudServiceID = [self.aiAppInfra.appConfig getPropertyForKey:@"appconfig.cloudServiceId"
                                                                       group:@"appinfra"
                                                                       error:&configError];
    if (cloudServiceID) {
        [self.aiAppInfra.serviceDiscovery getServicesWithCountryPreference:@[cloudServiceID] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *serviceURLError) {
            AISDService *service = services[cloudServiceID];
            if (service.url) {
                NSString * savedURL = [self.aiAppInfra.storageProvider fetchValueForKey:cloudURLKey
                                                                                  error:nil];
                if (![service.url isEqualToString:savedURL]) {
                    [self clearCloudConfigFile:nil];
                    [self.aiAppInfra.RESTClient GET:service.url
                                         parameters:nil
                                           progress:nil
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                if (responseObject) {
                                                    NSDictionary * responseDict = (NSDictionary *)responseObject;
                                                    [self saveDownloadedConfig:responseDict];
                                                    [self.aiAppInfra.storageProvider storeValueForKey:cloudURLKey
                                                                                                value:service.url
                                                                                                error:nil];
                                                    completionHandler(AIACRefreshResultRefreshedFromServer, nil);
                                                }
                                                else {
                                                    NSDictionary * userInfo = @{NSLocalizedDescriptionKey:@"Failed to download config from server"};
                                                    NSError * RESTError = [[NSError alloc]initWithDomain:kErrorDomainAIAppConfig
                                                                                                    code:AIACErrorServerError
                                                                                                userInfo:userInfo];
                                                    [AIInternalLogger log:AILogLevelError
                                                                  eventId:aiACEventId
                                                                  message:@"Failed to download config from server"];
                                                    
                                                    completionHandler(AIACRefreshResultRefreshFailed, RESTError);
                                                }
                                                
                                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                [AIInternalLogger log:AILogLevelError
                                                              eventId:aiACEventId
                                                              message:error.localizedDescription];
                                            }];
                }
                else {
                    completionHandler(AIACRefreshResultNoRefreshRequired, nil);
                }
            }
            else {
                [AIInternalLogger log:AILogLevelError
                              eventId:aiACEventId
                              message:serviceURLError.localizedDescription];
                completionHandler(AIACRefreshResultRefreshFailed, serviceURLError);
            }
        } replacement:nil];
    } else {
        [AIInternalLogger log:AILogLevelError
                      eventId:aiACEventId
                      message:configError.localizedDescription];
        NSError * serviceIdError = [[NSError alloc]initWithDomain:kErrorDomainAIAppConfig
                                                             code:AIACErrorServerError
                                                         userInfo:@{NSLocalizedDescriptionKey:@"No service id found for cloud config server url"}];
        completionHandler(AIACRefreshResultRefreshFailed, serviceIdError);
    }
}


-(NSString *)cloudConfigPath {
    return [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:cloudConfigFileName];
}


-(void)saveDownloadedConfig:(NSDictionary *)config {
    
    NSDictionary * uppercaseConfig = [self uppercaseKeysForDictionary:config];
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:uppercaseConfig options:0 error:&error];
    if (error) {
        [AIInternalLogger log:AILogLevelError
                      eventId:aiACEventId
                      message:@"Error in saving cloud config"];
    } else {
        NSString * path = [self cloudConfigPath];
        NSError * writeError;
        BOOL success = [data writeToFile:path
                                 options:NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication
                                   error:&writeError];
        
        NSString * message;
        AILogLevel level = AILogLevelError;
        if (success) {
            self.cloudConfiguration = uppercaseConfig;
            level = AILogLevelVerbose;
            message = @"cloud config saved to file";
        }
        else {
            message = [NSString stringWithFormat:@"error saving cloud config to file :%@",
                       writeError.localizedDescription];
        }
        
        [AIInternalLogger log:level
                      eventId:aiACEventId
                      message:message];
    }
}


-(NSDictionary *)savedCouldConfig {
    [AIInternalLogger log:AILogLevelVerbose
                  eventId:aiACEventId
                  message:@"reading cloud config from file"];
    NSData * data;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self cloudConfigPath]]) {
        data = [NSData dataWithContentsOfFile:[self cloudConfigPath]];
    }
    if (data) {
        NSError * error;
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            return json;
        }
    }
    return nil;
}


-(BOOL)resetConfig:(NSError * __autoreleasing *)error {
    NSError *errorReset;
    // Clear cloud config data
    [self clearCloudConfigFile:&errorReset];
    
    // Clear dynamic config data
    [self.aiAppInfra.storageProvider removeValueForKey:kAppDynamicConfigSecureStoreKey];
    
    // Clear cached config data
    self.configuration = nil;
    self.cloudConfiguration = nil;
    
    if(error!=NULL && errorReset)
        *error = errorReset;
    
    if(errorReset)
        return false;
    
    return true;
}

@end
