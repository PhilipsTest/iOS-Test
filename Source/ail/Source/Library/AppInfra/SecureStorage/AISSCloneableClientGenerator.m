//
//  AESKeyGenerator.m
// App Infra
//
//  Created by Adarsh Kumar Rai on 02/02/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import "AISSCloneableClientGenerator.h"
#import <CommonCrypto/CommonCrypto.h>

#pragma mark - Macro Definitions of Secure Variables
#define randomString        statString

@implementation AESKeyGenerator

+(NSData*)generateInitialisationVectorForKey:(NSData*)key {
    
    if(!key)
        return nil;
    
    NSString *alphabet  = @"abcdefghZijklYmXnWoVpUqTrSsRtQuPvOwNxMyLzK0J1I2H3G4F5E6D7C8B9A";
    u_int32_t textLength = (u_int32_t)alphabet.length;
    NSMutableString *randomString = [NSMutableString stringWithCapacity:kCCBlockSizeAES128];
    for (NSUInteger intIndex = 0U; intIndex < kCCBlockSizeAES128; intIndex++) {
        u_int32_t intRandomValue = arc4random_uniform(textLength);
        unichar unichar = [alphabet characterAtIndex:intRandomValue];
        [randomString appendFormat:@"%C", unichar];
    }
    NSData *ivData=[randomString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *ivOut=[NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    void *b = ivOut.mutableBytes;
    size_t size = sizeof(key);
    CCHmac(kCCHmacAlgSHA256, key.bytes,size, ivData.bytes, ivData.length,b);
    NSUInteger loc = (CC_SHA256_DIGEST_LENGTH-kCCBlockSizeAES128)/2;
    NSRange range = NSMakeRange(loc, kCCBlockSizeAES128);
    return [ivOut subdataWithRange:range];
}

+(NSData*)generateSecureAccessKey {
    uint8_t buffer[kCCKeySizeAES128+kCCKeySizeAES256+kCCKeySizeAES192];
    int suucess =SecRandomCopyBytes(kSecRandomDefault, sizeof(buffer), buffer);
    if (suucess == 0) {
        NSData *data=[[NSData alloc]initWithBytes:buffer length:sizeof(buffer)];
        data=[data subdataWithRange:NSMakeRange(kCCKeySizeAES192, kCCKeySizeAES256)];
        return data;
    }
    return nil;
}
@end
