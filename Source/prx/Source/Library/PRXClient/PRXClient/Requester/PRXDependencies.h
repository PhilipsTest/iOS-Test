//
//  PRXDependencies.h
//  PRXClient
//
//  Created by Hashim MH on 13/12/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppInfra/AppInfra.h>


@interface PRXDependencies : NSObject
/**
 * @brief constructior for creating dependency
 * @param appInfra instance of application appinfra
 * @param parentTLA three letter acronym of the caller eg: dcc (consumer care) , prg (product registration etc)
 * @since 2.2.0
 */
- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra parentTLA:(NSString*)parentTLA;


/**
 * Instance of AppInfra
 * @since 1.0.0
 */
@property (nonatomic , strong) id<AIAppInfraProtocol> appInfra;

/**
 * Three letter acronym of the caller eg: dcc (consumer care) , prg (product registration etc)
 * @since 1.0.0
 */
@property (nonatomic , strong) NSString *parentTLA;

@property (nonatomic , strong) id <AILoggingProtocol> prxLogging;
@end
