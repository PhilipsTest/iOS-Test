//
//  AICloudApiSigner.m
//  AppInfra
//
//  Created by Hashim MH on 07/06/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AICloudApiSigner.h"
#import "ps_hmac.h"


@interface AICloudApiSigner ()
@property (nonatomic)NSString *sharedKey;
@property (nonatomic)unsigned char *hsdpKey;
@end
@implementation AICloudApiSigner
- (id)initApiSigner:(NSString *)sharedKey andhexKey:(NSString *)hexKey
{
    self = [super init];
    if (self) {
        self.sharedKey = sharedKey;
        self.hsdpKey = [self convertToHexValueFromString:hexKey];
    }
    return self;
}

- (NSString *)createSignature:(NSString *)requestMethod dhpUrl:(NSString *)url queryString:(NSString *)requestUrlQuery headers:(NSDictionary *)allHttpHeaderFields requestBody:(NSData *)httpBody {
    
    NSString *date = allHttpHeaderFields[@"SignedDate"];
    if (date && [date isKindOfClass:[NSString class]]){
        return [self createSignatureForCloudLogging:date];
    }
    return @"";
}

-(NSString*)createSignatureForCloudLogging:(NSString*)stringData{
    NSData *dateData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    NSString *dateDataBase64 =  [dateData base64EncodedStringWithOptions:0];
    unsigned char *result = malloc(sizeof(unsigned char) * 64);
    ps_hmac(self.hsdpKey, (unsigned char *) [dateDataBase64 UTF8String], (int)dateDataBase64.length, result);
    NSData *macOut = [NSData dataWithBytes:(const void *)result length:32];
    NSString *encodedKey = [macOut base64EncodedStringWithOptions:0];
    return [self buildCloudLoggingAuthorizationHeaderValueForsignatureKey:encodedKey];
}

- (NSString *)buildCloudLoggingAuthorizationHeaderValueForsignatureKey:(NSString *)encodedKey
{
    
    NSString *ALGORITHM_NAME = @"HmacSHA256";
    NSMutableString *authorizationString = [NSMutableString stringWithString:ALGORITHM_NAME];
    
    [authorizationString appendString:@";"];
    [authorizationString appendString:@"Credential:"];
    [authorizationString appendString:self.sharedKey];
    [authorizationString appendString:@";"];
    [authorizationString appendString:@"SignedHeaders:SignedDate"];
    [authorizationString appendString:@";"];
    [authorizationString appendString:@"Signature:"];
    [authorizationString appendString:encodedKey];
    
    return authorizationString;
}


- (unsigned char *) convertToHexValueFromString:(NSString *)hexString
{
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
