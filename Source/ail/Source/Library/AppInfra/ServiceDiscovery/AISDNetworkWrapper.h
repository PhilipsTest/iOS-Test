//
//  AISDNetworkWrapper.h
//  AppInfra
//
//  Created by leslie on 23/01/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AISDModel.h"
#import "AIAppInfraProtocol.h"

@interface AISDNetworkWrapper : NSObject

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra;

-(void)serviceDiscoveryDataWithURL:(NSString *)URLString completionHandler: (void (^)( NSDictionary*  responseObject, NSError *  error))completionHandler;

@end
