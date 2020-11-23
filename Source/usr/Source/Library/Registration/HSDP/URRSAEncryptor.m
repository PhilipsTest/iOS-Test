//
//  URRSAEncryptor.m
//  Registration
//
//  Created by Sai Pasumarthy on 23/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URRSAEncryptor.h"
#import "DILogger.h"

@implementation URRSAEncryptor

static NSString *base64_encode_data(NSData *data) {
    data = [data base64EncodedDataWithOptions:0];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


static NSData *base64_decode(NSString *string) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}


+ (NSString *)encryptString:(NSString *)string withPublicKey:(NSString *)publicKey {
    NSData *encryptedData = [self encryptData:[string dataUsingEncoding:NSUTF8StringEncoding] withPublicKey:publicKey];
    NSString *encodedString = base64_encode_data(encryptedData);
    return encodedString;
}


+ (NSData *)encryptData:(NSData *)data withPublicKey:(NSString *)publicKey {
    if(!data || !publicKey) {
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:publicKey];
    if(!keyRef) {
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}


+ (SecKeyRef)addPublicKey:(NSString *)key {
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger sposLocation = spos.location + spos.length;
        NSUInteger eposLocation = epos.location;
        NSRange range = NSMakeRange(sposLocation, eposLocation - sposLocation);
        key = [key substringWithRange:range];
    }
    
    key = [[key componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \r\n\t"]] componentsJoinedByString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data) {
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"URRSAEncrypter_PubKey";
    NSData *dataTag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    publicKey[(__bridge id)kSecClass]              = (__bridge id)kSecClassKey;
    publicKey[(__bridge id)kSecAttrKeyType]        = (__bridge id)kSecAttrKeyTypeRSA;
    publicKey[(__bridge id)kSecAttrApplicationTag] = dataTag;
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    publicKey[(__bridge id)kSecValueData]           = data;
    publicKey[(__bridge id)kSecAttrKeyClass]        = (__bridge id)kSecAttrKeyClassPublic;
    publicKey[(__bridge id)kSecReturnPersistentRef] = @(YES);

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    publicKey[(__bridge id)kSecReturnRef]   = @(YES);
    publicKey[(__bridge id)kSecAttrKeyType] = (__bridge id)kSecAttrKeyTypeRSA;

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}


+ (NSData *)stripPublicKeyHeader:(NSData *)publicDataKey {
    // Skip ASN.1 public key header
    if (publicDataKey == nil) return(nil);
    
    unsigned long dataKeyLength = [publicDataKey length];
    if (!dataKeyLength) return(nil);
    
    const unsigned char *charKey = [publicDataKey bytes];
    unsigned int  index	 = 0;
    
    if (charKey[index++] != 0x30) return(nil);
    
    if (charKey[index] > 0x80) {
        index += charKey[index] - 0x80 + 1;
    } else {
        index++;
    }
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&charKey[index], seqiod, 15)) return(nil);
    
    index += 15;
    
    if (charKey[index++] != 0x03) return(nil);
    
    if (charKey[index] > 0x80) {
        index += charKey[index] - 0x80 + 1;
    } else {
        index++;
    }
    
    if (charKey[index++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&charKey[index] length:dataKeyLength - index]);
}


+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef)keyRef {
    const uint8_t *dataBuffer = (const uint8_t *)[data bytes];
    size_t dataBufferLength   = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outputBuffer = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *encryptData = [[NSMutableData alloc] init];
    for(NSUInteger index = 0; index < dataBufferLength; index += src_block_size) {
        size_t dataLength = dataBufferLength - index;
        if(dataLength > src_block_size) {
            dataLength = src_block_size;
        }
        
        size_t outputLength = block_size;
        OSStatus status;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               dataBuffer + index,
                               dataLength,
                               outputBuffer,
                               &outputLength
                               );
        if (status != 0) {
            DIRDebugLog(@"Could not encrypt HSDP uuid to be sent to analytics. Error Code: %d", status);
            encryptData = nil;
            break;
        } else {
            [encryptData appendBytes:outputBuffer length:outputLength];
        }
    }
    
    free(outputBuffer);
    CFRelease(keyRef);
    return encryptData;
}

@end
