//
//  AIInternalLog.m
//  AppInfra
//
//  Created by Hashim MH on 06/08/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AIInternalLogger.h"
#import "AILoggingProtocol.h"

@implementation AIInternalLogger
static id<AILoggingProtocol> internalLogger = nil;
+(id<AILoggingProtocol>)appInfraLogger{
    return internalLogger;
}

+(void)setAppInfraLogger:(id<AILoggingProtocol>)logger{
    internalLogger = logger;
}

+(void)log:(AILogLevel)loglevel
   eventId:(NSString*)eventId
   message:(NSString*)message{
    [AIInternalLogger.appInfraLogger log:loglevel eventId:eventId message:message];
}
@end


