//
//  AISSLPinManager.m
//  AppInfra
//
//  Created by Anthony G on 24/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AILSSLPublicKeyManager.h"
#import "AILoggingProtocol.h"
#import "AIStorageProvider.h"
#import "AIInternalLogger.h"
static NSString * const kRegexPinPattern = @"(?<=pin-sha256=\").*?(?=\")";
static NSString * const kRegexMaxAgePattern = @"(?<=max-age=)[0-9]+";

@interface NSString(Regex)
-(NSArray *)substringsMatchingPattern:(NSString *)pattern;
@end

@implementation NSString(Regex)
-(NSArray *)substringsMatchingPattern:(NSString *)pattern {
    NSMutableArray *regPins = [@[] mutableCopy];
    NSRegularExpression *pinRegex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:nil];
    NSArray *pinResults = [pinRegex matchesInString:self
                                            options:NSMatchingReportCompletion
                                              range:NSMakeRange(0, self.length)];
    for(NSTextCheckingResult* textResult in pinResults) {
        [regPins addObject:[self substringWithRange:textResult.range]];
    }
    return regPins.copy;
}
@end

@interface AILSSLPublicKeyManager()
@property (nonatomic, strong) NSMutableDictionary *publicPinInfo;
@property (nonatomic, strong) NSMutableDictionary *logCounterInfo;
@end

@implementation AILSSLPublicKeyManager
// create singleton instance to access cached data
+ (instancetype)sharedSSLPublicKeyManager {
    static AILSSLPublicKeyManager *shared = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.publicPinInfo = [@{} mutableCopy];
        self.logCounterInfo = [@{} mutableCopy];
    }
    return self;
}


-(void)setPublicPinsInfo:(id<NSCoding>)pinsInfo forHostName:(NSString*)hostName
                   error:(NSError *_Nullable*_Nullable)error {
    [self.publicPinInfo setObject:pinsInfo forKey:hostName];
    [self.appInfra.storageProvider storeValueForKey:hostName value:pinsInfo error:error];
}


-(NSDictionary *)publicPinsInfoForHostName:(NSString*)hostName error:( NSError * __autoreleasing *)error {
    NSDictionary *pinsInfo = self.publicPinInfo[hostName];
    if (pinsInfo) {
        return pinsInfo;
    }
    id storedPins = [self.appInfra.storageProvider fetchValueForKey:hostName error:error];
    if ([storedPins isKindOfClass:[NSDictionary class]]) {
        self.publicPinInfo[hostName] = storedPins;
        return pinsInfo;
    }
    return nil;
}

- (void)logWithEventId:(NSString *)eventId
               message:(NSString *)message
              hostName:(NSString *)hostName {
    NSNumber *counter = nil;
    if(hostName) {
        counter = self.logCounterInfo[hostName];
        self.logCounterInfo[hostName] = @(counter.integerValue+1);
    }
    if(counter.integerValue <= 3) {
        NSDictionary *logInfo = @{@"hostname": hostName ? hostName : @""};
        [AIInternalLogger.appInfraLogger log:AILogLevelDebug eventId:eventId message:message dictionary:logInfo];
    }
}


+(NSArray *)extractPublicKeysFromText:(NSString *)publicKeyPinInfoStr {
    return [publicKeyPinInfoStr substringsMatchingPattern:kRegexPinPattern];
}


+(NSString *)extractMaxAgeFromText:(NSString *)publicKeyPinInfoStr {
    return [[publicKeyPinInfoStr substringsMatchingPattern:kRegexMaxAgePattern] lastObject];
}
@end
