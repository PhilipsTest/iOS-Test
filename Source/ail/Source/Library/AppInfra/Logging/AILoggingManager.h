//
//  AILoggingManager.h
//  AppInfra
//
//  Created by Hashim MH on 03/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AILoggingConfig.h"
#import "AICloudLogger.h"
#import "AICloudLogMetadata.h"
@protocol AIAppInfraProtocol;
@interface AILoggingManager : NSObject

-(instancetype)initWithConfig:(AILoggingConfig*)config;


@property (nonatomic, strong) AILoggingConfig * logConfig;

-(DDFileLogger *)fileLogger;
-(DDTTYLogger *)consoleLogger;
-(AICloudLogger *)cloudLoggerWithAppInfra:(id<AIAppInfraProtocol>)appinfra metaData:(AICloudLogMetadata*)cloudLogMetaData;

@end
