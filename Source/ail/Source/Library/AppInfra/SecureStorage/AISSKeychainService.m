//
//  HSDPKeychainService.m
// App Infra
//
//  Created by Harsh on 24/08/2015.
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "AISSKeychainService.h"
#import "AISSUtility.h"

static NSString *AISSKeychainUtilsErrorDomain = @"com.philips.platform.appinfra.KeychainUtilsErrorDomain";

@implementation AISSKeychainService

// method to store the key securely
+ (BOOL)storeValue:(NSData *)value forKey:(NSString *)key andTokenType:(NSString *)tokenType {
    
    if(!key || !tokenType || !value)
        return false;
   
    NSError *getError = nil;
    NSData *existingTokenValue = [self getValueForTokenType:tokenType andKey:key error:&getError];
    if ([getError code] == -1999) {
        // There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
        // Delete the existing item before moving on entering a correct one.
        getError = nil;
        [self deleteValueForKey:key andtokenType:tokenType error:&getError];
        if ([getError code] != noErr){
            return NO;
        }
    }
    OSStatus status = noErr;
    if (existingTokenValue) {
        // We have an existing, properly entered item with a password.
        // Update the existing item.
        if (![existingTokenValue isEqualToData:value]) {
            //Only update if we're allowed to update existing.  If not, simply do nothing.
            NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClass),
                             kSecAttrService,
                             kSecAttrLabel,
                             kSecAttrAccount,
                             kSecAttrAccessible,
                             nil];
            
            NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClassGenericPassword),
                                tokenType,
                                tokenType,
                                key,
                                kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
                                nil];
            
            NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
            
            status = SecItemUpdate((CFDictionaryRef) CFBridgingRetain(query), (CFDictionaryRef) CFBridgingRetain([NSDictionary dictionaryWithObject: value forKey: (NSString *) CFBridgingRelease(kSecValueData)]));
        }
    }
    else {
        NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *)CFBridgingRelease(kSecClass),
                         kSecAttrService,
                         kSecAttrLabel,
                         kSecAttrAccount,
                         kSecValueData,
                         kSecAttrAccessible,
                         nil];
        
        NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClassGenericPassword),
                            tokenType,
                            tokenType,
                            key,
                            value,
                            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
                            nil];
        
        NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
        
        status = SecItemAdd((CFDictionaryRef) CFBridgingRetain(query), NULL);
    }
    return status == noErr;
    
}

// method to fetch the secure key
+ (NSData *)getValueForTokenType:(NSString *)tokenType andKey:(NSString *)key error:(NSError * __autoreleasing *)error {
    
    if (!tokenType || !key) {
        if (error != nil) {
            *error = [NSError errorWithDomain: AISSKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return nil;
    }
   
    
    // Set up a query dictionary with the base query attributes: item type (generic), username, and service
    NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClass), kSecAttrAccount, kSecAttrService, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClassGenericPassword), key, tokenType, nil];
    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).
    
    NSDictionary *attributeResult = NULL;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
     //replaced (id) to (NSObject *) ;commenting to remove tics compiler warning
    [attributeQuery setObject: (NSObject *) kCFBooleanTrue forKey:CFBridgingRelease(kSecReturnAttributes)];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef) (attributeQuery), (void*)&attributeResult);
    
    if (status != noErr) {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound) {
            //Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain: AISSKeychainUtilsErrorDomain code: status userInfo: nil];
        }
        return nil;
    }
    
    // We have an existing item, now query for the password data associated with it.
    NSData *resultData = nil;
    NSMutableDictionary *tokenQuery = [query mutableCopy];
    //[tokenQuery setObject: (id) kCFBooleanTrue forKey: CFBridgingRelease(kSecReturnData)];commenting to remove tics compiler warning
    [tokenQuery setObject: (NSObject *) kCFBooleanTrue forKey: CFBridgingRelease(kSecReturnData)];
    status = SecItemCopyMatching((__bridge CFDictionaryRef)(tokenQuery), (void *) &resultData);
    
    if (attributeResult){
       NSString *currentpdm =  attributeResult[(NSString *) CFBridgingRelease(kSecAttrAccessible)];
       if ([currentpdm isKindOfClass:[NSString class]] && ![currentpdm isEqualToString:(NSString *) CFBridgingRelease(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)] ){
              [self migrate:resultData forKey:key andTokenType:tokenType];
       }
   }
    
    if (status != noErr) {
        if (status == errSecItemNotFound) {
            if (error != nil) {
                *error = [NSError errorWithDomain: AISSKeychainUtilsErrorDomain code: -1999 userInfo: nil];
            }
        }
        else {
            if (error != nil) {
                *error = [NSError errorWithDomain: AISSKeychainUtilsErrorDomain code: status userInfo: nil];
            }
        }
        return nil;
    }
    if (!resultData) {
        if (error != nil) {
            *error = [NSError errorWithDomain: AISSKeychainUtilsErrorDomain code: -1999 userInfo: nil];
        }
    }
    return resultData;
}

+(BOOL)migrate:(NSData *)value forKey:(NSString *)key andTokenType:(NSString *)tokenType {

if(!key || !tokenType || !value)
        return false;



    OSStatus status = noErr;

            NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *)CFBridgingRelease(kSecClass),
                         kSecAttrService,
                         //kSecAttrLabel,
                         kSecAttrAccount,
                         kSecValueData,
                         kSecAttrAccessible,
                         nil];
    
        NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClassGenericPassword),
                           // tokenType,
                            tokenType,
                            key,
                            value,
                            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
                            nil];
    
        NSArray *keysWithAccessAttribute = [[NSArray alloc] initWithObjects: (NSString *)CFBridgingRelease(kSecClass),
                         kSecAttrService,
                         kSecAttrLabel,
                         kSecAttrAccount,
                         kSecAttrAccessible,
                         nil];
    
        NSArray *objectsWithAccessAttribute = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClassGenericPassword),
                            tokenType,
                            tokenType,
                            key,
                            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                            nil];
        NSDictionary *deleteQuery = [[NSDictionary alloc] initWithObjects: objectsWithAccessAttribute forKeys: keysWithAccessAttribute];
    
        NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
        SecItemDelete((__bridge CFDictionaryRef)(deleteQuery));
    
        status = SecItemAdd((CFDictionaryRef) CFBridgingRetain(query), NULL);
    
 
    return status == noErr;

}

// method to delete the secure key
+ (BOOL)deleteValueForKey:(NSString *)key andtokenType: (NSString *)tokenType error: (NSError * __autoreleasing *) error {
    if (!key || !tokenType) {
        if (error != nil) {
            *error = [NSError errorWithDomain: AISSKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return NO;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClass), kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) CFBridgingRelease(kSecClassGenericPassword), key, tokenType, kCFBooleanTrue, nil];
    
    NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
    
    if (error != nil && status != noErr) {
        *error = [NSError errorWithDomain: AISSKeychainUtilsErrorDomain code: status userInfo: nil];
        
        return NO;
    }
    return YES;
}
@end
