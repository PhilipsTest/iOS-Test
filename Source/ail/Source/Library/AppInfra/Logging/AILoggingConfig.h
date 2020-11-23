//
//  AILoggingConfig.h
//  AppInfra
//
//  Created by leslie on 07/04/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface AILoggingConfig : NSObject

@property(nonatomic, copy) NSString * fileName;
@property(nonatomic) NSUInteger numberOfFiles;
@property(nonatomic) NSInteger fileSizeInBytes;
@property(nonatomic) DDLogLevel logLevel;
@property(nonatomic) BOOL fileLogEnabled;
@property(nonatomic) BOOL consoleLogEnabled;
@property(nonatomic) BOOL componentLevelLogEnabled;
@property(nonatomic, strong) NSArray * componentIds;
@property(nonatomic) BOOL isReleaseConfig;
@property(nonatomic) BOOL cloudLogEnabled;
@property(nonatomic) NSUInteger cloudBatchLimit;


-(instancetype)initWithConfig:(NSDictionary*)config;

@end
