// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DIRefreshSecretSignature.h"
#import <CommonCrypto/CommonHMAC.h>


@implementation DIRefreshSecretSignature

+ (NSString *)buildRefreshSignatureFromDate:(NSString *)dateString refreshSecret:(NSString *)refreshSecret accessToken:(NSString *)accessToken {
    NSString *accessTokenString = [NSString stringWithFormat:@"refresh_access_token\n%@\n%@\n", dateString, accessToken];
    NSData *signature = [self hashedValueOfData:accessTokenString withSecretKey:refreshSecret];
    return [signature base64EncodedStringWithOptions:0];
}


+ (NSData *)hashedValueOfData:(NSString *)dataIn withSecretKey:(NSString *)key {
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [dataIn dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1,
           keyData.bytes, keyData.length,
           data.bytes, data.length,
           macOut.mutableBytes);
    
    return macOut;
}

@end
