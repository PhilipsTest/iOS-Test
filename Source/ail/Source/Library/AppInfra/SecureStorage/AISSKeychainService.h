//
//  HSDPKeychainService.h
//  App Infra
//
//  Created by Harsh on 24/08/2015.
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AISSKeychainService : NSObject
// method to store the key securely
+ (BOOL)storeValue:(NSData *)value forKey:(NSString *)key andTokenType:(NSString *)tokenType;
// method to fetch the secure key
+ (NSData *)getValueForTokenType:(NSString *)tokenType andKey:(NSString *)key error:(NSError **)error;
// method to delete the secure key
+ (BOOL)deleteValueForKey:(NSString *)key andtokenType: (NSString *)tokenType error: (NSError **) error;
@end
