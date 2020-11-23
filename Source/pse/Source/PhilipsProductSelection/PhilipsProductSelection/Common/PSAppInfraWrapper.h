//
//  PSAppInfraWrapper.h
//  PhilipsProductSelection
//
//  Created by KRISHNA KUMAR on 09/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppInfra/AppInfra.h>

@interface PSAppInfraWrapper : NSObject

@property (nonatomic,strong) id<AIAppTaggingProtocol> productSelectionTagging;
@property (nonatomic,strong) id<AILoggingProtocol> productSelectionLogging;
@property (nonatomic,strong) id<AIAppInfraProtocol> appInfra;

+ (instancetype)sharedInstance;
-(void)log:(AILogLevel)level Event:(NSString *)event Message:(NSString *)message;

@end
