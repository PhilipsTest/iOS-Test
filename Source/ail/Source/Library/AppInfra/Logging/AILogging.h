//
//  AILogging.h
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  
 All rights are reserved. Reproduction or dissemination in whole or 
 in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import "AILoggingProtocol.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppInfra.h"
#import "AILoggingConfig.h"
#import "AICloudLogMetadata.h"
#import "AICloudLoggingProtocol.h"

/**
 *  This class encapsulates implementation and business logic of logging.
 */
@interface AILogging : NSObject <AICloudLoggingProtocol>

@property(nonatomic,strong)id<AIAppInfraProtocol>aiAppInfra;
@property (nonatomic, strong) AILoggingConfig * logConfig;

/*
 Setting Log Level with Log Level, Event Id, Message and Component
 */
-(void)setLevel:(AILogLevel)level
        eventId:(NSString *)eventId
        message:(NSString *)message
dictionary:(NSDictionary *)dictionary;

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra ;

@end
