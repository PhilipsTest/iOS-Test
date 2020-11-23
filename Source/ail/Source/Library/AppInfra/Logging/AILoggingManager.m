//
//  AILoggingManager.m
//  AppInfra
//
//  Created by Hashim MH on 03/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AILoggingManager.h"
#import "AILoggingFormatter.h"
///

@interface LoggingFileManagerDefault :DDLogFileManagerDefault

@property(nonatomic,retain)NSDateFormatter *dateFormatterFileName;
@property(nonatomic, strong)NSString * logFileName;

@end


@implementation LoggingFileManagerDefault

- (NSString *)newLogFileName {
    NSString * fileName = @"AppInfra";
    if (self.logFileName) {
        fileName = self.logFileName;
    }
    return [NSString stringWithFormat:@"%@ %@.log", fileName, [NSDate date]];
}

- (BOOL)isLogFile:(NSString *)fileName
{
    return [fileName hasSuffix:@".log"];
}

@end
//////////////



@implementation AILoggingManager

-(instancetype)initWithConfig:(AILoggingConfig*)config {
    self = [super init];
    if (self) {
        _logConfig = config;
    }
    return self;
}


-(DDFileLogger*)fileLogger{
    if (self.logConfig.fileLogEnabled) {
        AILoggingFormatter *logFormatter = [[AILoggingFormatter alloc]
                                            init];
        LoggingFileManagerDefault *fileManagerDefault = [[LoggingFileManagerDefault alloc] init];
        fileManagerDefault.logFileName = self.logConfig.fileName;
        fileManagerDefault.dateFormatterFileName = logFormatter.dateFormatter;
        DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManagerDefault];
        fileLogger.maximumFileSize = (unsigned long long)self.logConfig.fileSizeInBytes;
        fileLogger.logFileManager.maximumNumberOfLogFiles = self.logConfig.numberOfFiles;
        fileLogger.rollingFrequency = 0;
        fileLogger.doNotReuseLogFiles = NO;
        fileLogger.logFormatter =   logFormatter;
        return fileLogger;
        
    }

    return nil;
}
-(DDTTYLogger*)consoleLogger{
    
    if (self.logConfig.consoleLogEnabled) {
        [DDTTYLogger sharedInstance].logFormatter = [[AILoggingFormatter alloc]
                                                     init];
        return [DDTTYLogger sharedInstance];
    }
    return nil;
}

-(AICloudLogger *)cloudLoggerWithAppInfra:(id<AIAppInfraProtocol>)appinfra
                                 metaData:(AICloudLogMetadata*)cloudLogMetaData{
    
    if (self.logConfig.cloudLogEnabled) {
        [AICloudLogger sharedInstance].appInfra = appinfra;
        [AICloudLogger sharedInstance].cloudLogMetaData = cloudLogMetaData;
        [AICloudLogger sharedInstance].cloudBatchLimit = self.logConfig.cloudBatchLimit;

        return [AICloudLogger sharedInstance];
    }

    return nil;
}
@end
