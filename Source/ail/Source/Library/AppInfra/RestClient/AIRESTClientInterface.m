//
//  AIRESTClientInterface.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 17/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import "AIRESTClientInterface.h"
#import "AICustomURLCache.h"
#import "AIRESTClientURLResponseSerialization.h"
#import "AIServiceDiscoveryProtocol.h"
#import "AIStorageProvider.h"
#import "RESTClientReachability.h"
#import "AILoggingProtocol.h"
#import "AILSSLPublicKeyManager.h"
#include <CommonCrypto/CommonDigest.h>
#import "AIInternalLogger.h"
#define AppInfraRestErrorDomain @"ail.restClient"
#define kRESTEventId @"AIRest"
#define kSSLPinEventId @"Public-key pins Mismatch"

@interface NSData(SHA256)
-(NSString*)sha256HashBase64;
@end

@implementation NSData(SHA256)
-(NSString*)sha256HashBase64 {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(self.bytes,(unsigned int)self.length, digest);
    NSData *hashData=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *base64hash = [hashData base64EncodedStringWithOptions:0];
    return base64hash;
}
@end


@interface AIRESTClientInterface()
@property(nonatomic, strong)id<AIAppInfraProtocol> appInfra;
@property(nonatomic,strong)RESTClientReachability *reachablility;
@end

@implementation AIRESTClientInterface

@synthesize attemptsToRecreateUploadTasksForBackgroundSessions;

static NSString * const kHTTPError  = @"http calls are depricated use https calls only";
static NSString * const kEmptyURLError  = @"Invalid URL,URL cannot be empty";

static NSString * const kPublicKeyPinCertificateExpired = @"Certificate signature matching the Stored pinned Public-key is expired";
static NSString *const kPublicKeyPinMismatchCertificateExpired = @"Mismatch of certificate signature with stored pinned Public-key due to expiry";
static NSString *const kPublicKeyPinMismatchCertificate = @"Mismatch of certificate signature with stored pinned Public-key";
#pragma mark - create instance

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.appInfra = appInfra;
        self.reachablility = [RESTClientReachability reachabilityForInternetConnection];
        self.reachablility.appinfra = appInfra;
        [self startNotifier];
        [NSURLCache setSharedURLCache:[[AICustomURLCache alloc]initWithAppInfra:appInfra]];
        self.responseSerializer = [AIRESTClientJSONResponseSerializer serializer];
        
        AILSSLPublicKeyManager *pinManager = [AILSSLPublicKeyManager sharedSSLPublicKeyManager];
        pinManager.appInfra = appInfra;
        
        __weak typeof(self) weakSelf = self;
        [self setDataTaskWillCacheResponseBlock:^NSCachedURLResponse * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSCachedURLResponse * _Nonnull proposedResponse) {
            return [weakSelf encryptResponseForCaching:proposedResponse];
        }];
    }
    return self;
}

- (id<AIRESTClientProtocol>)manager {
    return [self createInstanceWithBaseURL:nil];
}

- (id<AIRESTClientProtocol>)createInstanceWithBaseURL:(nullable NSURL *)url {
    return [self createInstanceWithBaseURL:url sessionConfiguration:nil];
}

- (id<AIRESTClientProtocol>)createInstanceWithBaseURL:(nullable NSURL *)url
                                 sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration {
    AIRESTClientInterface * restClient =[[AIRESTClientInterface alloc]initWithBaseURL:url sessionConfiguration:configuration];
    restClient.responseSerializer = [AIRESTClientJSONResponseSerializer serializer];
    restClient.appInfra = self.appInfra;
    //encrypting the cached data
    __weak typeof(self) weakSelf = self;
    [restClient setDataTaskWillCacheResponseBlock:^NSCachedURLResponse * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSCachedURLResponse * _Nonnull proposedResponse) {
        return [weakSelf encryptResponseForCaching:proposedResponse];
    }];
    
    [restClient setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        BOOL isValid = [self isValidCertificateTrust:serverTrust];
        NSString *hostName = challenge.protectionSpace.host;
        if(isValid == false) {
            AILSSLPublicKeyManager *pinManager = [AILSSLPublicKeyManager sharedSSLPublicKeyManager];
            
            [pinManager logWithEventId:kSSLPinEventId
                               message:kPublicKeyPinMismatchCertificate hostName:hostName];
        }
        [self validateCertificateInChallenge:challenge hostName:hostName];
        return isValid ? NSURLSessionAuthChallengeUseCredential : NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }];
    
    return restClient;
}

-(BOOL)isValidCertificateTrust:(SecTrustRef)serverTrust {
    // Evaluate server certificate
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    
    BOOL certificateIsValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
    return certificateIsValid;
}

-(void)validateCertificateInChallenge:(NSURLAuthenticationChallenge *)challenge hostName:(NSString *)hostName  {
    // Get remote certificate
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    
    // Set SSL policies for domain name check
    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host)];
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    
    // Evaluate server certificate
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    AILSSLPublicKeyManager *pinManager = [AILSSLPublicKeyManager sharedSSLPublicKeyManager];
    NSDictionary *storedPinInfo =  [pinManager publicPinsInfoForHostName:hostName error:nil];
    NSArray *storedPins = storedPinInfo[@"pins"];
    if(!storedPins) {
        return;
    }
    
    BOOL isMatching = false;
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certRef = SecTrustGetCertificateAtIndex(serverTrust, i);
        NSData *pubKeyData =  [self getPublicKeyDataFromCertificate_unified: certRef];
        UInt8 rsa2048Asn1Header[] = { 0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00};
        NSData* headerData = [NSData dataWithBytes:(void*)rsa2048Asn1Header length:sizeof(rsa2048Asn1Header)];
        NSMutableData *pubKeyWithHeader = [headerData mutableCopy];
        [pubKeyWithHeader appendData:pubKeyData];
        NSString *sh = [pubKeyWithHeader sha256HashBase64];
        isMatching = [storedPins containsObject:sh];
        if (isMatching) {
            break;
        }
    }
    
    NSDate *expiryDate = storedPinInfo[@"maxAge"];
    BOOL isExpired = [expiryDate compare:[NSDate date]] == NSOrderedAscending;
    if(isMatching) {
        if (isExpired) {
            [pinManager logWithEventId:kSSLPinEventId
                              message:kPublicKeyPinCertificateExpired hostName:hostName];
        }
    }
    else {
        //Expired and mismatch
        if(isExpired) {
            [pinManager logWithEventId:kSSLPinEventId
                               message: kPublicKeyPinMismatchCertificateExpired
                              hostName:hostName];
        } else {
        //Mismatch
        [pinManager logWithEventId:kSSLPinEventId
                           message: kPublicKeyPinMismatchCertificate
                          hostName:hostName];
        }
    }
}




// Use the unified SecKey API (specifically SecKeyCopyExternalRepresentation())
- (NSData *)getPublicKeyDataFromCertificate_unified:(SecCertificateRef)certificate
{
    // Create an X509 trust using the using the certificate
    SecTrustRef trust;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustCreateWithCertificates(certificate, policy, &trust);
    
    // Get a public key reference for the certificate from the trust
    SecTrustResultType result;
    SecTrustEvaluate(trust, &result);
    SecKeyRef publicKey = SecTrustCopyPublicKey(trust);
    CFRelease(policy);
    CFRelease(trust);
    
    // Obtain the public key bytes from the key reference
    CFDataRef publicKeyData = SecKeyCopyExternalRepresentation(publicKey, NULL);
    CFRelease(publicKey);
    
    return (__bridge_transfer NSData *)publicKeyData;
}

-(id<AIRESTClientProtocol>)createInstanceWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return  [self createInstanceWithBaseURL:nil sessionConfiguration:configuration];
}

- (id<AIRESTClientProtocol>)createInstanceWithBaseURL:(nullable NSURL *)url
                                 sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                      withCachePolicy:(AIRESTURLRequestCachePolicy)cachePolicy
{
    configuration.URLCache = [NSURLCache sharedURLCache];
    
    // set the user preferred cache policy
    switch (cachePolicy) {
        case AIRESTURLRequestUseProtocolCachePolicy:
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        break;
        case AIRESTURLRequestReloadIgnoringLocalCacheData:
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        break;
        case AIRESTURLRequestReturnCacheDataElseLoad:
        configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        break;
        
        default:
        break;
    }
    id<AIRESTClientProtocol> restClient =[self createInstanceWithBaseURL:url sessionConfiguration:configuration];
    return restClient;
}

#pragma mark - Internet reachability check public methods

-(AIRESTClientReachabilityStatus)getNetworkReachabilityStatus
{
    switch ([self.reachablility currentReachabilityStatus]) {
        case NotReachable:
        return AIRESTClientReachabilityStatusNotReachable;
        break;
        case ReachableViaWiFi:
        return AIRESTClientReachabilityStatusReachableViaWiFi;
        break;
        case ReachableViaWWAN:
        return AIRESTClientReachabilityStatusReachableViaWWAN;
        break;        
        default:
        break;
    }
}

-(BOOL)isInternetReachable
{
    NetworkStatus status = [self.reachablility currentReachabilityStatus];
    if(status != NotReachable && ![self.reachablility connectionRequired])
    return YES;
    else
    return NO;
}

- (BOOL)startNotifier
{
    return [self.reachablility startNotifier];
}

- (void)stopNotifier
{
    [self.reachablility stopNotifier];
}

-(NSCachedURLResponse *)encryptResponseForCaching:(NSCachedURLResponse *)proposedResponse {
    
    NSCachedURLResponse * cachedResponse;
    NSError * error;
    
    NSURLResponse *response = proposedResponse.response;
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
    NSDictionary *headers = HTTPResponse.allHeaderFields;
    
    if (![[headers objectForKey:@"AIEStatus"] isEqualToString:@"true"]) {
        
        NSMutableDictionary *modifiedHeaders = headers.mutableCopy;
        [modifiedHeaders setObject:@"true" forKey:@"AIEStatus"];
        NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                               initWithURL:HTTPResponse.URL
                                               statusCode:HTTPResponse.statusCode
                                               HTTPVersion:@"HTTP/1.1"
                                               headerFields:modifiedHeaders];
        
        
        NSData* encryptedData = [self.appInfra.storageProvider loadData:proposedResponse.data error:&error];
        
        cachedResponse = [[NSCachedURLResponse alloc]initWithResponse:modifiedResponse
                                                                 data:encryptedData
                                                             userInfo:proposedResponse.userInfo
                                                        storagePolicy:proposedResponse.storagePolicy];
        
    }
    else {
        cachedResponse = proposedResponse;
    }
    
    return cachedResponse;
}


-(BOOL)isValidUrl:(NSString *)urlString {
    if ([self.baseURL.absoluteString.lowercaseString containsString:@"http://"] || [urlString.lowercaseString containsString:@"http://"]) {
        NSString *message = [NSString stringWithFormat:@"%@ is not a valid https url",urlString];
        [AIInternalLogger log:AILogLevelDebug eventId:kRESTEventId message:message];
        return NO;
    }
    else {
        return YES;
    }
}

-(void)createCompleteURL:(NSString *)serviceURL
           pathComponent:(nullable NSString *)pathComponent
                   error:(NSError *)error
              completion:(void(^)(NSString*serviceURL,NSError *error))completionHandler
{
    if (serviceURL != nil && ![serviceURL isEqualToString:@""]) {
        if(pathComponent && pathComponent.length>0)
        serviceURL = [serviceURL stringByAppendingString:pathComponent];
        completionHandler(serviceURL, error);
    }
    else {
        if (error) {
            completionHandler(serviceURL, error);
        }
        else {
            NSError * serviceURLError = [[NSError alloc]initWithDomain:AppInfraRestErrorDomain code:0 userInfo:[NSDictionary dictionaryWithObject:@"Service discovery cannot find any url" forKey:NSLocalizedDescriptionKey]];
             [AIInternalLogger log:AILogLevelError eventId:kRESTEventId message:@"Service discovery cannot find any url"];
            completionHandler(nil, serviceURLError);
            
        }
    }
}

-(void)serviceURLWithServiceID:(NSString *)serviceID
                    preference:(AIRESTServiceIDPreference)preference
                 pathComponent:(nullable NSString *)pathComponent
                    completion:(void(^)(NSString*serviceURL,NSError *error))completionHandler
{
    if (preference == AIRESTServiceIDPreferenceCountry) {
        [self.appInfra.serviceDiscovery getServicesWithCountryPreference:@[serviceID] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *countryFinalerror) {
            AISDService *service = services[serviceID];
            [self createCompleteURL:service.url pathComponent:pathComponent error:countryFinalerror completion:^(NSString *URL, NSError *countryFinalerror) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(URL, countryFinalerror);
                });
            }];
        } replacement:nil];
    }
    else {
        [self.appInfra.serviceDiscovery getServicesWithLanguagePreference:@[serviceID] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *languageFinalerror) {
            AISDService *service = services[serviceID];
            [self createCompleteURL:service.url pathComponent:pathComponent error:languageFinalerror completion:^(NSString *URL, NSError *languageFinalerror) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(URL, languageFinalerror);
                });
            }];
        } replacement:nil];
    }
}

#pragma mark - public methods

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    
    if (![self validateURL:URLString failure:failure]) {
        return nil;
    }
    [self addAuthenticationData];
    return [super GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}

- (void)GETWithServiceID:(NSString *)serviceID
              preference:(AIRESTServiceIDPreference)preference
           pathComponent:(nullable NSString *)pathComponent
    serviceURLCompletion:(nullable void (^)(NSURLSessionDataTask *task))serviceURLCompletion
              parameters:(nullable id)parameters
                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    
    [self serviceURLWithServiceID:serviceID preference:preference pathComponent:pathComponent completion:^(NSString *serviceURL, NSError *error) {
        
        if (error) {
            failure(nil, error);
        }
        else {
            [self GET:serviceURL parameters:parameters progress:downloadProgress success:success failure:failure];
        }
        
    }];
}

- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if (![self validateURL:URLString failure:failure]) {
        return nil;
    }
    [self addAuthenticationData];
    return [super HEAD:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (void)HEADWithServiceID:(NSString *)serviceID
               preference:(AIRESTServiceIDPreference)preference
            pathComponent:(nullable NSString *)pathComponent
     serviceURLCompletion:(nullable void (^)(NSURLSessionDataTask *task))serviceURLCompletion
               parameters:(nullable id)parameters
                  success:(nullable void (^)(NSURLSessionDataTask *task))success
                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    [self serviceURLWithServiceID:serviceID preference:preference pathComponent:pathComponent completion:^(NSString *serviceURL, NSError *error) {
        
        if (error) {
            failure(nil, error);
        }
        else {
            [self HEAD:serviceURL parameters:parameters success:success failure:failure];
        }
        
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if (![self validateURL:URLString failure:failure]) {
        return nil;
    }
    [self addAuthenticationData];
    return [super POST:URLString parameters:parameters headers:nil progress:uploadProgress success:success failure:failure];
}

- (void)POSTWithServiceID:(NSString *)serviceID
               preference:(AIRESTServiceIDPreference)preference
            pathComponent:(nullable NSString *)pathComponent
     serviceURLCompletion:(nullable void (^)(NSURLSessionDataTask *task))serviceURLCompletion
               parameters:(nullable id)parameters
                 progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    
    [self serviceURLWithServiceID:serviceID preference:preference pathComponent:pathComponent completion:^(NSString *serviceURL, NSError *error) {
        
        if (error) {
            failure(nil, error);
        }
        else {
            [self POST:serviceURL parameters:parameters progress:uploadProgress success:success failure:failure];
        }
        
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if (![self validateURL:URLString failure:failure]) {
        return nil;
    }
    [self addAuthenticationData];
    return [super POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if (![self validateURL:URLString failure:failure]) {
        return nil;
    }
    [self addAuthenticationData];
    return [super PUT:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (void)PUTWithServiceID:(NSString *)serviceID
              preference:(AIRESTServiceIDPreference)preference
           pathComponent:(nullable NSString *)pathComponent
    serviceURLCompletion:(nullable void (^)(NSURLSessionDataTask *task))serviceURLCompletion
              parameters:(nullable id)parameters
                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    
    [self serviceURLWithServiceID:serviceID preference:preference pathComponent:pathComponent completion:^(NSString *serviceURL, NSError *error) {
        
        if (error) {
            failure(nil, error);
        }
        else {
            [self PUT:serviceURL parameters:parameters success:success failure:failure];
        }
        
    }];
}

- (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if (![self validateURL:URLString failure:failure]) {
        return nil;
    }
    [self addAuthenticationData];
    return [super PATCH:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (void)PATCHWithServiceID:(NSString *)serviceID
                preference:(AIRESTServiceIDPreference)preference
             pathComponent:(nullable NSString *)pathComponent
      serviceURLCompletion:(nullable void (^)(NSURLSessionDataTask *task))serviceURLCompletion
                parameters:(nullable id)parameters
                   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    
    [self serviceURLWithServiceID:serviceID preference:preference pathComponent:pathComponent completion:^(NSString *serviceURL, NSError *error) {
        if (error) {
            failure(nil, error);
        }
        else {
            [self PATCH:serviceURL parameters:parameters success:success failure:failure];
        }
        
    }];
}

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if (![self validateURL:URLString failure:failure]) {
        return nil;
    }
    [self addAuthenticationData];
    return [super DELETE:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (void)DELETEWithServiceID:(NSString *)serviceID
                 preference:(AIRESTServiceIDPreference)preference
              pathComponent:(nullable NSString *)pathComponent
       serviceURLCompletion:(nullable void (^)(NSURLSessionDataTask *task))serviceURLCompletion
                 parameters:(nullable id)parameters
                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    
    
    [self serviceURLWithServiceID:serviceID preference:preference pathComponent:pathComponent completion:^(NSString *serviceURL, NSError *error) {
        
        if (error) {
            failure(nil, error);
        }
        else {
            [self DELETE:serviceURL parameters:parameters success:success failure:failure];
        }
        
    }];
}

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    NSAssert([self isValidUrl:request.URL.absoluteString], kHTTPError);
    [self addAuthenticationData];
    return [super downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
}

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                             destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    [self addAuthenticationData];
    return [super downloadTaskWithResumeData:resumeData progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                         progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error))completionHandler
{
    NSAssert([self isValidUrl:request.URL.absoluteString], kHTTPError);
    [self addAuthenticationData];
    return [super uploadTaskWithRequest:request fromFile:fileURL progress:uploadProgressBlock completionHandler:completionHandler];
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                         progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSAssert([self isValidUrl:request.URL.absoluteString], kHTTPError);
    [self addAuthenticationData];
    return [super uploadTaskWithRequest:request fromData:bodyData progress:uploadProgressBlock completionHandler:completionHandler];
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSAssert([self isValidUrl:request.URL.absoluteString], kHTTPError);
    [self addAuthenticationData];
    return [super uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    NSAssert([self isValidUrl:request.URL.absoluteString], kHTTPError);
    [self addAuthenticationData];
    return [super dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:completionHandler];
}
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    NSAssert([self isValidUrl:request.URL.absoluteString], kHTTPError);
    [self addAuthenticationData];
    return [super dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
}

- (void)invalidateSessionCancelingTasks:(BOOL)cancelPendingTasks {
    [super invalidateSessionCancelingTasks:cancelPendingTasks resetSession:true];
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    [super URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
}


#pragma mark - Helper methods
-(void)addAuthenticationData{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getTokenType)]  && [self.delegate respondsToSelector:@selector(getTokenValue)] ) {
        
        AIRESTClientTokenType tokenType = [self.delegate getTokenType];
        NSString *tokenValue = [self.delegate getTokenValue];
        if (!tokenValue && tokenValue.length == 0 && ![self isAuthTypeSupported:tokenType]) {
            return;
        }
        
        switch (tokenType) {
            case AIRESTClientTokenTypeOAUTH2:
                 [AIInternalLogger log:AILogLevelDebug eventId:kRESTEventId message:@"OAUTH2 adding auth data"];
            {
                NSString *headerValue = [NSString stringWithFormat:@"Bearer %@",tokenValue];
                [self.requestSerializer setValue:headerValue forHTTPHeaderField:@"Authorization"];
            }
            break;
            
            default:
            break;
        }
        
    }
    
}

-(BOOL)isAuthTypeSupported:(AIRESTClientTokenType)authType{
    if (authType == AIRESTClientTokenTypeOAUTH2) {
        return YES;
    }
    
    return NO;
}

-(BOOL)validateURL:(NSString *)URLString
           failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    if(!URLString)
    {
        dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
            NSError *error = [[NSError alloc]initWithDomain:AppInfraRestErrorDomain code:600 userInfo:[NSDictionary dictionaryWithObject:kEmptyURLError forKey:NSLocalizedDescriptionKey]];
            [AIInternalLogger log:AILogLevelError eventId:kRESTEventId message:kEmptyURLError];
            failure(nil,error);
        });
        return NO;
    }
    
    NSAssert([self isValidUrl:URLString], kHTTPError);
    return YES;
}

-(void)clearCacheResponse {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [super encodeWithCoder:coder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return [super initWithCoder:coder];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [super copyWithZone:zone];
}

@end
