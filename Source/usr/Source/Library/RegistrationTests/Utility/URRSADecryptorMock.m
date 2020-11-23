//
//  URRSADecryptorMock.m
//  Registration
//
//  Created by Sai Pasumarthy on 24/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URRSADecryptorMock.h"

@implementation URRSADecryptorMock

static NSData *base64_decode(NSString *str) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}


+ (NSString *)decryptString:(NSString *)string withPrivateKey:(NSString *)privateKey {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data withPrivateKey:privateKey];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return dataString;
}


+ (NSData *)decryptData:(NSData *)data withPrivateKey:(NSString *)privateKey {
    if(!data || !privateKey) {
        return nil;
    }
    SecKeyRef keyRef = [self addPrivateKey:privateKey];
    if(!keyRef) {
        return nil;
    }
    return [self decryptData:data withKeyRef:keyRef];
}


+ (SecKeyRef)addPrivateKey:(NSString *)key {
    NSRange spos;
    NSRange epos;
    spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    if(spos.length > 0) {
        epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    } else {
        spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
        epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    }
    if(spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger sposLocation = spos.location + spos.length;
        NSUInteger eposLocation = epos.location;
        NSRange range = NSMakeRange(sposLocation, eposLocation - sposLocation);
        key = [key substringWithRange:range];
    }
    key = [[key componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \r\n\t"]] componentsJoinedByString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data) {
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"URRSADecryptor_PrivateKey";
    NSData *dataTag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    privateKey[(__bridge id)kSecClass]              = (__bridge id) kSecClassKey;
    privateKey[(__bridge id)kSecAttrKeyType]        = (__bridge id) kSecAttrKeyTypeRSA;
    privateKey[(__bridge id)kSecAttrApplicationTag] = dataTag;
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    privateKey[(__bridge id)kSecValueData]           = data;
    privateKey[(__bridge id)kSecAttrKeyClass]        = (__bridge id) kSecAttrKeyClassPrivate;
    privateKey[(__bridge id)kSecReturnPersistentRef] = @(YES);

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil) {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    privateKey[(__bridge id)kSecReturnRef] = @(YES);
    privateKey[(__bridge id)kSecAttrKeyType] = (__bridge id) kSecAttrKeyTypeRSA;

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr) {
        return nil;
    }
    return keyRef;
}


+ (NSData *)stripPrivateKeyHeader:(NSData *)privateDataKey {
    // Skip ASN.1 private key header
    if (privateDataKey == nil) return(nil);
    
    unsigned long length = [privateDataKey length];
    if (!length) return(nil);
    
    unsigned char *charKey = (unsigned char *)[privateDataKey bytes];
    unsigned int  index	 = 22; //magic byte at offset 22
    
    if (0x04 != charKey[index++]) return nil;
    
    //calculate length of the key
    unsigned int charLength = charKey[index++];
    int det = charLength & 0x80;
    if (!det) {
        charLength = charLength & 0x7f;
    } else {
        int byteCount = charLength & 0x7f;
        if (byteCount + index > length) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &charKey[index];
        index += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        charLength = accum;
    }
    
    // Now make a new NSData from this buffer
    return [privateDataKey subdataWithRange:NSMakeRange(index, charLength)];
}


+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef {
    const uint8_t *dataBuffer = (const uint8_t *)[data bytes];
    size_t dataBufferLength = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outputBuffer = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *decryptData = [[NSMutableData alloc] init];
    for(int idx = 0; idx < dataBufferLength; idx += src_block_size) {
        size_t dataLength = dataBufferLength - idx;
        if(dataLength > src_block_size){
            dataLength = src_block_size;
        }
        
        size_t outputLength = block_size;
        OSStatus status;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               dataBuffer + idx,
                               dataLength,
                               outputBuffer,
                               &outputLength
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            decryptData = nil;
            break;
        } else {
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outputLength;
            for ( int i = 0; i < outputLength; i++ ) {
                if ( outputBuffer[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [decryptData appendBytes:&outputBuffer[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outputBuffer);
    CFRelease(keyRef);
    return decryptData;
}

@end
