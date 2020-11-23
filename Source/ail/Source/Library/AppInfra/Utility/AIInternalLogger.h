//
//  AIInternalLog.h
//  AppInfra
//
//  Created by Hashim MH on 06/08/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol AILoggingProtocol;

@interface AIInternalLogger : NSObject
typedef NS_ENUM(NSInteger, AILogLevel);

@property (class,nonatomic,strong) id<AILoggingProtocol>appInfraLogger;
+(void)log:(AILogLevel)loglevel
   eventId:(NSString*)eventId
   message:(NSString*)message;
@end

