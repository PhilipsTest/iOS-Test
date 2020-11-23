//
//  NSData+Encryption.m
// App Infra
//
//  Created by Adarsh Kumar Rai on 02/02/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import "NSData+AISSStatementParser.h"
#import <CommonCrypto/CommonCrypto.h>
#import "AISSUtility.h"
#import "AIStorageProviderProtocol.h"

#pragma mark - Macro Definitions of Secure Variables
#define keyPtr                  suffixPtr
#define numBytesEncrypted       byteSize
#define encryptedData           parsedData
#define initialisationVector    suffixDCK
#define dataToBeDecrypted       loadedData


@implementation NSData (Encryption)

// method to generate the secured data
- (NSData *)AES256EncryptWithKey:(NSData *)key
         andInitialisationVector:(NSData*)initialisationVector
                           error:(NSError * __autoreleasing *)error{
    
    if(!key)
    {
        if(error!= NULL){
         *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage code:AISSErrorCodeUnknownKey userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionEmptyKey forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    memcpy(keyPtr, key.bytes, sizeof(key.bytes));
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          initialisationVector.bytes,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSMutableData *encryptedData=[NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        [encryptedData appendData:initialisationVector];
        return encryptedData;
    }
    else
    {
        if(error!= NULL)
        *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage code:AISSErrorCodeEncryptionError userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionEncryptionFailure forKey:NSLocalizedDescriptionKey]];
        
    }
    
    free(buffer);
    return nil;
}
// method to convert into actual data
- (NSData *)AES256DecryptWithKey:(NSData *)key
                           error:(NSError * __autoreleasing *)error {
    
    if(!key)
    {
        if(error!= NULL){
        *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage code:AISSErrorCodeUnknownKey userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionEmptyKey forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    memcpy(keyPtr, key.bytes, sizeof(key.bytes));
    /*
       The below if statement is return to handle failure scenario where user converts storing object into NSData which is of length less that kCCBlockSizeAES128 and directly store in NSUserDefault and then trying to fetch the same object with decrypt API
     */
    
    if(self.length <= kCCBlockSizeAES128 ){
        if(error!= NULL){
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage code:AISSErrorCodeDecryptionError userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionDecryptionFailure forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }else{
    NSData *initialisationVector=[self subdataWithRange:NSMakeRange(self.length-kCCBlockSizeAES128, kCCBlockSizeAES128)];
    NSData *dataToBeDecrypted=[self subdataWithRange:NSMakeRange(0, self.length-kCCBlockSizeAES128)];
    NSUInteger dataLength = [dataToBeDecrypted length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          initialisationVector.bytes,
                                          [dataToBeDecrypted bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    else
    {
        if(error!= NULL)
        *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage code:AISSErrorCodeDecryptionError userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionDecryptionFailure forKey:NSLocalizedDescriptionKey]];
    }

    
    free(buffer);
    return nil;
  }
}

@end
