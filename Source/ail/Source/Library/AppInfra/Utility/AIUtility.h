//
//  AISDUtility.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/17/16.
//  Copyright © 2016 /*Copyright (c) Koninklijke Philips N.V., 2016 All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>

@interface AIUtility : NSObject

+ (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

+ (BOOL)URLUnSafeCharactersExists:(NSString *)strURLComponent;

+ (BOOL)isNull:(id)value;

+ (NSString *)appInfraDocumentsDirectory;

+ (NSUInteger) lengthInBytesForString:(NSString *)input;

+ (BOOL)saveDictionary:(NSDictionary*)dictionary toPath:(NSString*)path NS_SWIFT_NAME(save(_:to:));

+ (NSDictionary*)fetchDictionaryFromPath:(NSString*)path NS_SWIFT_NAME(fetchDictionary(from:));

+ (NSString *)deviceModel;

+ (NSString *)lightsOn:(NSString *)input;

+ (NSString *)stringToHex:(NSString *)input;

+ (NSString *)stringFromHex:(NSString *)input;

+ (NSString *)convertDatetoString:(NSDate *)date;

+ (NSDate *)convertStringtoDate:(NSString *)strDate;

+(BOOL)storeDataToFile:(id)data toPath:(NSString *)path error:(NSError **)error;

+(id)fetchFileFromPath:(NSString *)path error:(NSError **)error;

+(BOOL)removeFileFromPath:(NSString *)path error:(NSError **)error;

@end
