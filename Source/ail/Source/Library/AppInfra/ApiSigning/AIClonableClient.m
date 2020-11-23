//
//  AIHSDPPHSApiSigning.m
//  AppInfra
//
//  Created by Abhishek on 27/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>

#import "AIClonableClient.h"
#import "ps_hmac.h"

#define kResultSize 64
#define kDataSize   32

NSString *ALGORITHM_NAME = @"HmacSHA256";

@interface AIHSDPPHSApiSigning ()

@property (nonatomic)NSString *sharedKey; //Shared key in String format e95f5e71...
@property (nonatomic)unsigned char *hsdpKey; //Hsdp signing key formatted as a 128byte hex string. 730f1863726de1...

@end

@implementation AIHSDPPHSApiSigning

/**
 Create an API signer instance according to HSDP specification
 @param sharedKey Api signing shared key
 @param hexKey Api signing secret key in hex string format.
 @return Class instance AIHSDPPHSApiSigning
 */
- (id)initApiSigner:(NSString *)sharedKey andhexKey:(NSString *)hexKey {
    self = [super init];
    if (self) {
        self.sharedKey = sharedKey;
        self.hsdpKey = [self convertToHexValueFromString:hexKey];
    }
    return self;
}


/**
 Create an API signer instance according to HSDP specification
 @param requestMethod Type of method(POST, GET)
 @param url Request URL
 @param requestUrlQuery Request URL query. applicationName=uGrow
 @param allHttpHeaderFields Request http header fields. Current date is passed as http header value.
 @param httpBody Request body
 @return signature
 */
- (NSString *)createSignature:(NSString *)requestMethod
                       dhpUrl:(NSString *)url
                  queryString:(NSString *)requestUrlQuery
                      headers:(NSDictionary *)allHttpHeaderFields
                  requestBody:(NSData *)httpBody {
    
    NSData *signatureKey = [self hashRequest:requestMethod
                                 queryString:requestUrlQuery
                                     headers:allHttpHeaderFields
                                 requestBody:httpBody];
    NSData *signature = [self hashedValueOfData:url WithKey:signatureKey];
    
    return [self buildAuthorizationHeaderValue:allHttpHeaderFields
                                  signatureKey:[signature base64EncodedStringWithOptions:0]];
}


#pragma mark -
#pragma mark - Private Methods

- (NSString *)buildAuthorizationHeaderValue:(NSDictionary *)allHttpHeaderFields
                               signatureKey:(NSString *)encodedKey {
    NSMutableString *authorizationString = [NSMutableString stringWithString:ALGORITHM_NAME];
    
    [authorizationString appendString:@";"];
    [authorizationString appendString:@"Credential:"];
    [authorizationString appendString:self.sharedKey];
    [authorizationString appendString:@";"];
    [authorizationString appendString:@"SignedHeaders:"];
    
    for (NSString *header in [allHttpHeaderFields allKeys])
    {
        [authorizationString appendFormat:@"%@",header];
        if ([allHttpHeaderFields allKeys].count>[[allHttpHeaderFields allKeys] indexOfObject:header]+1) {
            [authorizationString appendString:@","];
        }
    }
    
    [authorizationString appendString:@";"];
    [authorizationString appendString:@"Signature:"];
    [authorizationString appendString:encodedKey];
    
    return authorizationString;
}


- (NSData *)hashRequest:(NSString *)requestMethod
            queryString:(NSString *)requestUrlQuery
                headers:(NSDictionary *)allHttpHeaderFields
            requestBody:(NSData *)httpBody {
    NSData *methodHash = [self hashedValueOfData:requestMethod];
    
    NSData *queryStringHash = [self hashedValueOfData:requestUrlQuery WithKey:methodHash];
    NSString *requestBody = nil;
    
    if (httpBody.length > 0) {
        requestBody = [[NSString alloc]initWithData:httpBody encoding:NSUTF8StringEncoding];
    }
    
    NSData *bodyHash = [self hashedValueOfData:requestBody WithKey:queryStringHash];
    NSString *headers = [self convertToString:allHttpHeaderFields];
    
    return [self hashedValueOfData:headers WithKey:bodyHash];
}

#pragma mark -
#pragma mark - Hashing methods

- (NSData *)hashedValueOfData:(NSString *)dataIn WithKey:(NSData*)key {
    NSData *data = [dataIn dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac( kCCHmacAlgSHA256,
           key.bytes, key.length,
           data.bytes, data.length,
           macOut.mutableBytes);
    
    return macOut;
}


- (NSData *)hashedValueOfData:(NSString *)method {
    unsigned char *result = malloc(sizeof(unsigned char) * kResultSize);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcast-qual"
    ps_hmac(self.hsdpKey, (unsigned char *) [method UTF8String], (int)method.length, result);
#pragma clang diagnostic pop
    NSData *macOut = [NSData dataWithBytes:(const void *)result length:kDataSize];
    
    return macOut;
}

#pragma mark -
#pragma mark - Utility Methods

- (NSString *)convertToString:(NSDictionary *)allKeys {
    if (!allKeys.count) return nil;
    
    NSMutableArray *headersArray = [NSMutableArray new];
    [allKeys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [headersArray addObject:[NSString stringWithFormat:@"%@:%@;",key,obj]];
    }];
    return [headersArray componentsJoinedByString:@""];
}

- (unsigned char *) convertToHexValueFromString:(NSString *)hexString {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wsign-conversion"
#pragma clang diagnostic ignored "-Wsign-compare"
    unsigned char *myBuffer = (unsigned char *)malloc((int)[hexString length] / 2 + 1);
    
    bzero(myBuffer, [hexString length] / 2 + 1);
    
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        
        myBuffer[i / 2] = (char)anInt;
    }
#pragma clang diagnostic pop
    return myBuffer;
}
@end
