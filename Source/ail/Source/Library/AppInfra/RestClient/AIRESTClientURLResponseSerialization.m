//
//  AIRESTClientURLResponseSerialization.m
//  AppInfra
//
//  Created by leslie on 10/09/16.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AIRESTClientURLResponseSerialization.h"
#import "AILoggingProtocol.h"
#import "AILSSLPublicKeyManager.h"
#import "AIStorageProvider.h"

static NSString * const kPublicKeyNotFoundNetwork = @"Could not find Public-Key-Pins in network response";
static NSString * const kPublicKeyNotFoundStorage = @"Could not find Public-Key-Pins in storage";
static NSString * const kPublicKeyPinMismatchHeader = @"Pinned Public-key received in response header does not match with stored value of pinned Public-key";

#define kSSLPinEventId @"Public-key pins Mismatch"

@interface ResponseSerializerUtility : NSObject

+(NSData *)processResponse:(NSURLResponse *)response
                      data:(NSData *)data
                     validResponse:(BOOL)isvalid;
@end

@implementation ResponseSerializerUtility : NSObject 

+(NSData *)processResponse:(NSURLResponse *)response
                      data:(NSData *)data
                     validResponse:(BOOL)isvalid {
    if (!isvalid) {
        return data;
    }
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:response.URL];
    NSCachedURLResponse * cachedResponse = [[NSURLCache sharedURLCache]
                                            cachedResponseForRequest:request];
    
    AIStorageProvider * storageProvider = [[AIStorageProvider alloc]init];
    NSError * decryptError;
    NSData * decrypted;
    //decrypting the cached data
    if (cachedResponse) {
        decrypted = [storageProvider parseData:cachedResponse.data error:&decryptError];
    }
    else if (data && data.length > 0) {
        
        @try {
            decrypted = [storageProvider parseData:data error:&decryptError];
        } @catch (NSException *exception) {
            //TODO
        }
    }
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        [self processSSLPublicPinsFromResponse:(NSHTTPURLResponse*)response];
    }
    
    if (decrypted && !decryptError) {
        return decrypted;
    }
    return data;
}


+(void)processSSLPublicPinsFromResponse:(NSHTTPURLResponse *)response {
    AILSSLPublicKeyManager *pinManger = [AILSSLPublicKeyManager sharedSSLPublicKeyManager];
    NSString *hostName = response.URL.host;
    if(hostName == nil) {
        return;
    }
    NSDictionary *headerFields = response.allHeaderFields;
    NSString *publicKeyPinsText = headerFields[@"public-key-pins"];
    NSArray *publicPins = [AILSSLPublicKeyManager extractPublicKeysFromText:publicKeyPinsText];
    NSDictionary *storedPublicPinInfo = [pinManger publicPinsInfoForHostName:hostName error:nil];
    
    if(publicPins == nil || publicKeyPinsText == nil) {
        if(storedPublicPinInfo != nil) {
            [pinManger logWithEventId:kSSLPinEventId
                              message:kPublicKeyNotFoundNetwork hostName:hostName];
        }
        return;
    }
    
    NSError *storageReadError = nil;
    BOOL isStored = [self compareStoredPins:publicPins hostName:hostName error:&storageReadError];
    NSString *maxAgeText = [AILSSLPublicKeyManager extractMaxAgeFromText:publicKeyPinsText];
    NSDate *expiryDate = [[NSDate new] dateByAddingTimeInterval: maxAgeText.floatValue];
    
    NSDictionary *pinDetails = @{@"pins": publicPins,
                                 @"maxAge": expiryDate};
    
    if(storedPublicPinInfo == nil) {
        [pinManger logWithEventId:kSSLPinEventId
                          message:kPublicKeyNotFoundStorage hostName:hostName];
        if (pinDetails) {
            [pinManger setPublicPinsInfo:pinDetails forHostName:hostName error:nil];
        }
        return;
    }
    
    if (storageReadError == nil) {
        if(isStored == false) {
            [pinManger logWithEventId:kSSLPinEventId
                              message:kPublicKeyPinMismatchHeader hostName:hostName];
            
            [pinManger setPublicPinsInfo:pinDetails forHostName:hostName error:nil];
        } else {
            NSDictionary *info = [pinManger publicPinsInfoForHostName:hostName error:nil];
            NSDate *tMaxDate = info[@"maxAge"];
            NSDate *addedBufferDate = [tMaxDate dateByAddingTimeInterval: 86400];
            if ([expiryDate compare: addedBufferDate] == NSOrderedDescending) {
                NSMutableDictionary *mutableInfo = [info mutableCopy];
                mutableInfo[@"maxAge"] = expiryDate;
                [pinManger setPublicPinsInfo:mutableInfo forHostName:hostName error:nil];
            }
        }
    }
    else {
        [pinManger setPublicPinsInfo:pinDetails forHostName:hostName error:nil];
    }
}


+(BOOL)compareStoredPins:(NSArray *)pins hostName:(NSString *)hostName error:(NSError * __autoreleasing *)error {
    AILSSLPublicKeyManager *manager = [AILSSLPublicKeyManager sharedSSLPublicKeyManager];
    NSDictionary *storedPinInfo = [manager publicPinsInfoForHostName:hostName error:error];
    NSArray *storedPins = storedPinInfo[@"pins"];
    NSSet *storedSet = [NSSet setWithArray:storedPins];
    NSSet *pinSet = [NSSet setWithArray:pins];
    if([storedSet intersectsSet:pinSet] == true) {
        return true;
    }
    return false;
}

@end

@implementation AIRESTClientHTTPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSData * processedData = [ResponseSerializerUtility processResponse:response
                                                                   data:data
                                                          validResponse:[super validateResponse:(NSHTTPURLResponse *)response
                                                                                           data:data
                                                                                          error:error]];
    
    return [super responseObjectForResponse:response data:processedData error:error];
}

@end

@implementation AIRESTClientJSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSData * processedData = [ResponseSerializerUtility processResponse:response
                                                                   data:data
                                                          validResponse:[super validateResponse:(NSHTTPURLResponse *)response
                                                                                           data:data
                                                                                          error:error]];
    return [super responseObjectForResponse:response data:processedData error:error];
}

@end

@implementation AIRESTClientXMLParserResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSData * processedData = [ResponseSerializerUtility processResponse:response
                                                                   data:data
                                                          validResponse:[super validateResponse:(NSHTTPURLResponse *)response
                                                                                           data:data
                                                                                          error:error]];
    
    return [super responseObjectForResponse:response data:processedData error:error];
}

@end

@implementation AIRESTClientPropertyListResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSData * processedData = [ResponseSerializerUtility processResponse:response
                                                                   data:data
                                                          validResponse:[super validateResponse:(NSHTTPURLResponse *)response
                                                                                           data:data
                                                                                          error:error]];
    
    return [super responseObjectForResponse:response data:processedData error:error];
}

@end

@implementation AIRESTClientImageResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSData * processedData = [ResponseSerializerUtility processResponse:response
                                                                   data:data
                                                          validResponse:[super validateResponse:(NSHTTPURLResponse *)response
                                                                                           data:data
                                                                                          error:error]];
    
    return [super responseObjectForResponse:response data:processedData error:error];
}

@end

@implementation AIRESTClientCompoundResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSData * processedData = [ResponseSerializerUtility processResponse:response
                                                                   data:data
                                                          validResponse:[super validateResponse:(NSHTTPURLResponse *)response
                                                                                           data:data
                                                                                          error:error]];
    
    return [super responseObjectForResponse:response data:processedData error:error];
}

@end
