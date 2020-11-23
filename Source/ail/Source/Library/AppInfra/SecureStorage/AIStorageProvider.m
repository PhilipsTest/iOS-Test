//
//  StorageProvider.m
// App Infra
//
//  Created by Adarsh Kumar Rai,Modified by Ravi Kiran HR on 29/01/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
//

#import "AIStorageProvider.h"
#import "AISSKeychainService.h"
#import "AISSUtility.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+AISSStatementParser.h"
#import "AISSCloneableClientGenerator.h"
#import "AIStorageProviderProtocol.h"
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>
#import "AIUtility.h"


@import Security;

#define KEYCHAIN_ACCESS_KEY        @"KEYCHAIN-STORAGE-KEY"
#define KEYCHAIN_TOKEN_TYPE        @"keychain_storage_token_type"

#pragma mark - Macro Definitions of Secure Variables
#define encryptData loadData
#define decryptData parseData
#define secureAccessKey            clonedClient
#define fetchSecureAccessKey       methodToGetVariable
#define storeSecureAccessKey       methodToSaveVariable
#define encryptedData              parsedStatement
#define decryptedData              loadedStatement
#define MD5Algorithm               @"jpeg"


@interface AISSSecureStorage()
- (NSString *)getDeviceCapability;
@end

@implementation AISSSecureStorage

typedef NS_ENUM(NSInteger, DataType) {
    jpegType = 1,
};

/*@function: storeValueforkey
 @description:  Method to store any object securely into user defaults
 @params: "object" any object to be securely stored
 @param: "key" a string to identify the data on user defaults
 @param "error" retruns an NSError object if error occurs
 @result: bool returns for success YES for failure NO
 */
- (BOOL)storeValueForKey:(nonnull NSString*)key
                   value:(nonnull id<NSCoding>)object
                   error:(NSError *_Nullable*_Nullable)error{
    // empty check for key
    if(key.length==0 || [key stringByReplacingOccurrencesOfString:@" " withString:@""].length ==0)
    {
        if(error!= NULL){
        *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                           code:AISSErrorCodeUnknownKey
                                       userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionEmptyKey
                                                                            forKey:NSLocalizedDescriptionKey]];
        }
        return NO;
    }
    
    NSData *encryptedData = [self encryptData:object error:error];
    if (encryptedData) {
        [[NSUserDefaults standardUserDefaults] setObject:encryptedData forKey:key];
        return YES;
    }
    
    return NO;
}

/**
 Method to fetch the object stored against the key provided

 @param key "key" a string to identify the data on user defaults
 @param error "error" retruns an NSError object if error occurs
 @return value for that particular key
 */
-(nullable id)fetchValueForKey:(nonnull NSString*)key
                         error:( NSError *_Nullable*_Nullable)error{
    // empty check for key
    if(key.length==0 || [key stringByReplacingOccurrencesOfString:@" " withString:@""].length ==0){
        
        if(error!= NULL){
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodeUnknownKey
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionEmptyKey forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }
    
    // fetch data from user defaults
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    
    if (!data) {
        if(error!= NULL){
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodeNoDataFoundForKey
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionEmptyData forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }
    /*
     The below if statement is return to handle failure scenario where user directly store object other than type NSData in NSUserDefault and then trying to fetch the same object with decrypt API
     */
    else if(![data isKindOfClass:[NSData class]]){
        if(error!= NULL){
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodeInvalidDataType
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionDataParsing forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }
    else
    {        
        id unarchivedData = [self decryptData:data  error:error];
        return unarchivedData;
        
    }
    return nil;
}

-(NSData *)unArchiveData:(NSData *)data

{
    NSData *unarchivedData;
    @try {
         unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        unarchivedData = nil;
    }
    return unarchivedData;
}

-(NSData *)archiveData:(id<NSCoding>)data

{
    NSData *archivedData;
    @try {
        archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
    }
    @catch (NSException *exception) {
        archivedData = nil;
    }
    return archivedData;
}

/*@function: removeValueForKey
 @description:  Method to delete the object stored against the key provided
 @param: "key" a string to identify the data on user defaults
 @result: void doesn't return any value
 */
- (void)removeValueForKey:(nonnull NSString*)key {
    // empty check for key
    if(key.length==0 || [key stringByReplacingOccurrencesOfString:@" " withString:@""].length ==0)
        return;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

-(NSData*)encryptData:(nonnull id<NSCoding>)object
                error:(NSError *_Nullable*_Nullable)error{

    if (!object) {
        if(error!= NULL)
        {
        *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                           code:AISSErrorCodeAccessKeyFailure
                                       userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionInvalidParam forKey:NSLocalizedDescriptionKey]];
        }
    return nil;
 
    }
    
    
    NSData *data=[self archiveData:object];
    //Check if it can be archived
    if (!data) {
        if(error!= NULL){
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodearchiveFailure
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionArchive forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }
    
    NSData *secureAccessKey = [self fetchSecureAccessKey];
    if (!secureAccessKey) {
        if(error!= NULL)
        {
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodeAccessKeyFailure
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionAccessKey forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
        
    }
    
    
    NSError *encryptError;
    NSData *encryptedData=[data AES256EncryptWithKey:secureAccessKey andInitialisationVector:[AESKeyGenerator generateInitialisationVectorForKey:secureAccessKey] error:&encryptError];
    if(encryptError)
    {
        if(error!= NULL)
        {
            *error = encryptError;
            
        }
        return nil;
    }
    
    
    return encryptedData;
}

-(id)decryptData:(nonnull NSData*)data
                error:(NSError *_Nullable*_Nullable)error{
    
    if (!data) {
        if(error!= NULL)
        {
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodeInvalidInput
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionInvalidParam forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
        
    }

    NSData *secureAccessKey = [self fetchSecureAccessKey];
    if (!secureAccessKey) {
        if(error!= NULL)
        {
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodeAccessKeyFailure
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionAccessKey forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
   
    }
    
    NSError *decryptError;
    NSData *decryptedData=[data AES256DecryptWithKey:secureAccessKey error:&decryptError];
    if(decryptError)
    {
        if(error!= NULL)
            *error = decryptError;
        return nil;
    }
    // check for decryption falure
    if (!decryptedData) {
        if(error!= NULL){
            *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                               code:AISSErrorCodeDecryptionError
                                           userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionDecryptionFailure forKey:NSLocalizedDescriptionKey]];
        }
    }
    else
    {
        id unarchivedData = [self unArchiveData:decryptedData];
        
        if (!unarchivedData) {
            if(error!= NULL){
                *error = [[NSError alloc]initWithDomain:kErrorDomainAISecureStorage
                                                   code:AISSErrorCodeUnarchiveFailure
                                               userInfo:[NSDictionary dictionaryWithObject:kErrorDescriptionUnarchive forKey:NSLocalizedDescriptionKey]];
            }
            return nil;

        }
        return unarchivedData;
    }

    return nil;
}

-(BOOL) deviceHasPasscode {
    NSData* secret = [@"Device has passcode set?" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attributes = @{ (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword, (__bridge id)kSecAttrService: @"LocalDeviceServices",  (__bridge id)kSecAttrAccount: @"NoAccount", (__bridge id)kSecValueData: secret, (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly };
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
    if (status == errSecSuccess) { // item added okay, passcode has been set
        SecItemDelete((__bridge CFDictionaryRef)attributes);
        
        return true;
    }
    
    return false;
}

-(NSString *)getDeviceCapability {
    NSArray * pathArray = [NSArray arrayWithObjects:@"/private/var/stash",
                           @"/private/var/lib/apt",
                           @"/private/var/tmp/cydia.log",
                           @"/private/var/lib/cydia",
                           @"/private/var/mobile/Library/SBSettings/Themes",
                           @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                           @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                           @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                           @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                           @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                           @"/var/cache/apt",
                           @"/var/lib/apt",
                           @"/var/lib/cydia",
                           @"/var/log/syslog",
                           @"/var/tmp/cydia.log",
                           @"/bin/bash",
                           @"/bin/sh",
                           @"/usr/sbin/sshd",
                           @"/usr/libexec/ssh-keysign",
                           @"/usr/sbin/sshd",
                           @"/usr/bin/sshd",
                           @"/usr/libexec/sftp-server",
                           @"/etc/ssh/sshd_config",
                           @"/etc/apt",
                           @"/private/var/lib/apt/",
                           @"/Applications/Cydia.app",
                           @"/Applications/RockApp.app",
                           @"/Applications/Icy.app",
                           @"/Applications/WinterBoard.app",
                           @"/Applications/SBSettings.app",
                           @"/Applications/MxTube.app",
                           @"/Applications/IntelliScreen.app",
                           @"/Applications/FakeCarrier.app",
                           @"/Applications/blackra1n.app", nil];
    
    NSString * trueStatus = @"true";
    for (NSString * path in pathArray) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            return trueStatus;
    }
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]) {
        return trueStatus;
    }
    
    NSError *error;
    NSString *stringToBeWritten = @"Jailbreak Test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error == nil){
        return trueStatus;
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    }
    

    
    int p = fork();
    if (p > 0) {
        return trueStatus;
    }
    
    uint32_t count = _dyld_image_count();
    for(uint32_t i = 0; i < count; i++)
    {
        const char *dyld = _dyld_get_image_name(i);
        if(!strstr(dyld, "MobileSubstrate")) {
            continue;
        }
        else {
            return trueStatus;
        }
    }
    
    return @"false";
}

- (BOOL)storeDataToFile:(nonnull NSString *)filePath type:(nonnull NSString *)type data:(nonnull id)data error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@",[AIUtility appInfraDocumentsDirectory],filePath,type];
    return [AIUtility storeDataToFile:data toPath:path error:error];
}

- (nullable id)fetchDataFromFile:(nonnull NSString *)filePath type:(nonnull NSString *)type error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@",[AIUtility appInfraDocumentsDirectory],filePath,type];
    return [AIUtility fetchFileFromPath:path error:error];
}

- (BOOL)removeFileFromPath:(nonnull NSString *)filePath type:(nonnull NSString *)type error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@",[AIUtility appInfraDocumentsDirectory],filePath,type];
    return [AIUtility removeFileFromPath:path error:error];
}

#pragma mark - Helper Methods

// method to store secure access key
- (void)storeSecureAccessKey:(NSData*)key {
    [AISSKeychainService storeValue:key
                             forKey:KEYCHAIN_ACCESS_KEY
                       andTokenType:[AISSUtility serviceNameForTokenName:KEYCHAIN_TOKEN_TYPE]];
}


// method to fetch secure access key
// or generate a key if there is no key in keychain
- (NSData*)fetchSecureAccessKey {
    NSData *secureAccessKey=[AISSKeychainService getValueForTokenType:
                             [AISSUtility serviceNameForTokenName:KEYCHAIN_TOKEN_TYPE]
                                                           andKey:KEYCHAIN_ACCESS_KEY error:nil];
    if (secureAccessKey.length<kCCKeySizeAES256) {
        secureAccessKey=[AESKeyGenerator generateSecureAccessKey];
        if (secureAccessKey.length<kCCKeySizeAES256) {
            return nil;
        }
        [self storeSecureAccessKey:secureAccessKey];
        
    }
    return secureAccessKey;
}
@end
