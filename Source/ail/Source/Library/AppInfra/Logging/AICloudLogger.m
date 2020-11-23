//
//  AICloudLogger.m
//  AppInfra
//
//  Created by Hashim MH on 25/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AICloudLogger.h"
#import <AppInfra/AppInfra-Swift.h>
#import "AILogMetaData.h"
#import "AILogUtilities.h"
#import <CoreData/CoreData.h>
#import "AppInfra.h"

#define kMaxMessageLength 1024

API_AVAILABLE(ios(10.0))
@interface AICloudLogger ()
{
    AIClouldLoggingSyncManager *syncManager;
}
@end


@implementation AICloudLogger

static AICloudLogger *sharedInstance;

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.appInfra = appInfra ;
        [self initSyncManager];
    }
    return self;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self  clearProcessingLog];
    }
    return self;
    
}


-(void)clearProcessingLog {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"AILog"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"status == %@",@"inProcess" ];
    NSError *error;
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    [[AILogCoreDataStack shared].managedObjectContext executeRequest:delete error:&error];
    [[AILogCoreDataStack shared].managedObjectContext save:&error];
}


-(void)setAppInfra:(id<AIAppInfraProtocol> )appInfra {
    _appInfra = appInfra;
    [self initSyncManager];
}


-(void)setCloudBatchLimit:(NSUInteger)cloudBatchLimit {
    syncManager.cloudBatchLimit = cloudBatchLimit;
    _cloudBatchLimit = cloudBatchLimit;
}


-(void)initSyncManager {
    syncManager = [[AIClouldLoggingSyncManager alloc]initWithAppInfra:self.appInfra ];
    syncManager.cloudBatchLimit = self.cloudBatchLimit;
}


+ (instancetype)sharedInstance {
    static dispatch_once_t AICloudLoggerOnceToken;
    
    dispatch_once(&AICloudLoggerOnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


- (void)logMessage:(DDLogMessage *)logMessage {
    
    if ([self isMessageExceedsSizeLimitForMessage:logMessage] || ![self shouldLog:logMessage] ){
        return;
    }
    
    AILogCoreDataStack *stack = AILogCoreDataStack.shared;
        
    [stack perform:^{
        AILog * log = [[AILog alloc]initWithContext:[stack managedObjectContext]];
        [log updateLogMessageWith:logMessage];
        [log updateCloudLogMetaDataWithData:[self cloudLogMetaData]];
        NSInteger logCount = [log saveData];
        if (logCount > self.cloudBatchLimit){
            [self->syncManager syncWithForced:NO];
        }
    }];
}


-(BOOL)shouldLog:(DDLogMessage *)logMessage {
    AILogMetaData *metaData = (AILogMetaData *)logMessage.tag;
    if (logMessage && metaData && [metaData isKindOfClass:[AILogMetaData class]]) {
        if([metaData.component containsString:@"ail"]){
            return false;
        }
        else if (logMessage.flag & DDLogLevelInfo ){
            return true;
        }
    }
    return false;
}


-(BOOL)isMessageExceedsSizeLimitForMessage:(DDLogMessage *)logMessage {
    AILogMetaData *tagData = (AILogMetaData *)logMessage.tag;
    NSUInteger messgeLength = logMessage.message.length;
    NSUInteger paramLength = tagData.params?tagData.params.description.length :0;
    NSUInteger totalMessageLength = messgeLength+paramLength;
    
    if (totalMessageLength < kMaxMessageLength ){
        return false;
    }
    
#ifdef DEBUG
    NSLog(@"Log message shouldn’t exceed more than 1 KB");
#endif
    return true;
}


@synthesize logFormatter;

@end
