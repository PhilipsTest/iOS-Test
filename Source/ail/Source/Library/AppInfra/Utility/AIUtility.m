//
//  AISDUtility.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/17/16.
//  Copyright © 2016 /*Copyright (c) Koninklijke Philips N.V., 2016 All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import "AIUtility.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonCrypto.h>


@implementation AIUtility

#pragma mark - Helper Method
+ (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

+(BOOL)URLUnSafeCharactersExists:(NSString *)strURLComponent
{
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]";
    NSCharacterSet *escapeCharacters = [NSCharacterSet characterSetWithCharactersInString:charactersToEscape];
    NSRange range = [strURLComponent rangeOfCharacterFromSet:escapeCharacters];
    if (range.location == NSNotFound) {
        return false;
    }
    else
    {
        return true;
    }
}

+(BOOL)isNull:(id)value {
    if (value == [NSNull null] || value == nil || value == NULL) {
        return YES;
    }
    return NO;
}

+(NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (void)createDirectory:(NSString *)dirPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

+ (NSString *)appInfraDocumentsDirectory {
    NSString * appInfraPath = [[AIUtility documentsDirectoryPath] stringByAppendingPathComponent:@"/AppInfra"];
    [AIUtility createDirectory:appInfraPath];
    return appInfraPath;
}

+(BOOL)storeDataToFile:(id)data toPath:(NSString *)path error:(NSError **)error{
    NSString *dirPath = [path stringByDeletingLastPathComponent];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:error]; //Will Create folder
    
    if (data) {
        NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:data];

        BOOL status = [archieveData writeToFile:path options:0 error:error];

        NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
        if (![[attrs objectForKey: NSFileProtectionKey]
              isEqual:NSFileProtectionCompleteUntilFirstUserAuthentication]) {
            attrs = [NSDictionary dictionaryWithObject:NSFileProtectionCompleteUntilFirstUserAuthentication forKey:NSFileProtectionKey];
            [[NSFileManager defaultManager] setAttributes:attrs ofItemAtPath:path error:error];
        }
        return status;
    }
    return NO;
}

+(id)fetchFileFromPath:(NSString *)path error:(NSError **)error{
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:error];
    id unarchieveData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return unarchieveData;
}

+(BOOL)removeFileFromPath:(NSString *)path error:(NSError **)error{
    BOOL status = [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    return status;
}

+(BOOL)saveDictionary:(NSDictionary*)dictionary toPath:(NSString*)path {

    
    if (![path containsString:@"Documents/AppInfra"]) {
        path = [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:path];
    }

    NSString *dirPath = [path stringByDeletingLastPathComponent];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])//Check
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error]; //Will Create folder
    
    if (dictionary) {
        BOOL status = [dictionary writeToFile:path atomically:YES];
        
        NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        if (![[attrs objectForKey: NSFileProtectionKey]
              isEqual:NSFileProtectionComplete]) {
            attrs = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
            [[NSFileManager defaultManager] setAttributes:attrs ofItemAtPath:path error:nil];
        }
        return status;
    }
    return NO;
}

+(NSDictionary*)fetchDictionaryFromPath:(NSString*)path {
    NSString *dataPath = [AIUtility appInfraDocumentsDirectory];
    
    if (![path containsString:@"Documents/AppInfra"]) {
        path = [dataPath stringByAppendingPathComponent:path];
    }
    return  [NSDictionary dictionaryWithContentsOfFile: path];
}
+ (NSUInteger) lengthInBytesForString:(NSString *)input {
    return [input lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceModel {
    NSString *deviceType;
    struct utsname systemInfo;
    uname(&systemInfo);
    deviceType = [NSString stringWithCString:systemInfo.machine
                                    encoding:NSUTF8StringEncoding];
    return deviceType;
}

+ (NSString *)lightsOn:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)stringToHex:(NSString *)input
{
    NSUInteger len = [input length];
    unichar *chars = malloc(len * sizeof(unichar));
    [input getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString ;
}

+ (NSString *)stringFromHex:(NSString *)input
{
    NSMutableData *stringData = [[NSMutableData alloc] init] ;
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [input length] / 2; i++) {
        byte_chars[0] = [input characterAtIndex:i*2];
        byte_chars[1] = [input characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding] ;
}

+ (NSString *)convertDatetoString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    return stringFromDate;
}

+ (NSDate *)convertStringtoDate:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    return dateFromString;
}

@end
