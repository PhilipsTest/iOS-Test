//
//  AICloudLogger.h
//  AppInfra
//
//  Created by Hashim MH on 25/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AICloudLogMetadata.h"
@protocol AIAppInfraProtocol;

@interface AICloudLogger : NSObject <DDLogger>


- (void)logMessage:(DDLogMessage * __attribute__((unused)))logMessage;
- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra ;
@property(nonatomic,weak)id<AIAppInfraProtocol> appInfra;
@property (nonatomic, strong) AICloudLogMetadata *cloudLogMetaData;
@property(nonatomic) NSUInteger cloudBatchLimit;
@property (class, readonly, strong) AICloudLogger *sharedInstance;

@end
