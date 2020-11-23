//
//  AILoggingConfig.m
//  AppInfra
//
//  Created by leslie on 07/04/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AILoggingConfig.h"

#ifdef DEBUG
#define DEBUGMODE YES
#else
#define DEBUGMODE NO
#endif

NSString const * kfileName = @"fileName";
NSString const * knumberOfFiles = @"numberOfFiles";
NSString const * kfileSizeInBytes = @"fileSizeInBytes";
NSString const * klogLevel = @"logLevel";
NSString const * kfileLogEnabled = @"fileLogEnabled";
NSString const * kconsoleLogEnabled = @"consoleLogEnabled";
NSString const * kcompLevelLogEnabled = @"componentLevelLogEnabled";
NSString const * kcomponentIds = @"componentIds";
NSString const * kcloudLogEnabled = @"cloudLogEnabled";
NSString const * kbatchLimit = @"cloudBatchLimit";
NSUInteger const KbatchLimitDefaultValue = 5 ;
NSUInteger const KbatchLimitMaximumValue = 25 ;


@implementation AILoggingConfig

-(instancetype)initWithConfig:(NSDictionary*)config {
    self = [super init];
    if (self) {
        self.fileName = config[kfileName];
        self.numberOfFiles = [config[knumberOfFiles] unsignedIntegerValue];
        self.fileSizeInBytes = [config[kfileSizeInBytes] integerValue];
        self.fileLogEnabled = [config[kfileLogEnabled] boolValue];
        self.componentLevelLogEnabled = [config[kcompLevelLogEnabled] boolValue];
        self.cloudLogEnabled = [config[kcloudLogEnabled] boolValue];
        
        if (config[klogLevel]) {
            self.logLevel = [self getLogLevelValue:config[klogLevel]];
        }
        else {
            NSString * level = @"all";
            if (self.isReleaseConfig) {
                level = @"off";
            }
            self.logLevel = [self getLogLevelValue:config[level]];
        }
        
        if (config[kconsoleLogEnabled]) {
            self.consoleLogEnabled = [config[kconsoleLogEnabled] boolValue];
        }
        else {
            self.consoleLogEnabled = !self.isReleaseConfig;
        }
        
        if (config[kbatchLimit]) {
            NSNumber * batchLimit = (NSNumber *)config[kbatchLimit];
            if (batchLimit.unsignedIntegerValue
                && batchLimit.unsignedIntegerValue < KbatchLimitMaximumValue
                && batchLimit.unsignedIntegerValue != 0 ) {
                self.cloudBatchLimit = batchLimit.unsignedIntegerValue;
            } else if (batchLimit.unsignedIntegerValue == 0 ){
                self.cloudBatchLimit = KbatchLimitDefaultValue;
            } else {
                self.cloudBatchLimit = KbatchLimitMaximumValue;
            }
        } else if (self.cloudLogEnabled) {
            self.cloudBatchLimit = KbatchLimitDefaultValue;
        }
        self.componentIds = config[kcomponentIds];
    }
    return self;
}


-(DDLogLevel)getLogLevelValue:(NSString *)level {
    NSArray *arrLogLevel = @[@"off",
                             @"error",
                             @"warn",
                             @"info",
                             @"debug",
                             @"verbose",
                             @"all"];
    NSUInteger values[] = {
        DDLogLevelOff,
        DDLogLevelError,
        DDLogLevelWarning,
        DDLogLevelInfo,
        DDLogLevelDebug,
        DDLogLevelVerbose,
        DDLogLevelAll};
    
    return (DDLogLevel)values[[arrLogLevel indexOfObject:level.lowercaseString]];
}

@end
