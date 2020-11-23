//
//  AISDURLs.h
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
#import "AppInfra.h"

@interface AISDURLs : NSObject <AISDModelProtocol>

@property(nonatomic, strong)AISDModel * platformURLs;

@property(nonatomic, strong)AISDModel * propositionURLs;

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra;

-(NSString *)getCountryCode;

@end
