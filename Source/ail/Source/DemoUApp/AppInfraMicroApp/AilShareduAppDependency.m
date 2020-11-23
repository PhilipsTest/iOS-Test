//
//  AilShareduAppDependency.m
//  AppInfraMicroApp
//
//  Created by Ravi Kiran HR on 16/03/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "AilShareduAppDependency.h"

@implementation AilShareduAppDependency

+(instancetype)sharedDependency
{
    static dispatch_once_t token;
    static AilShareduAppDependency *obj;
    dispatch_once(&token, ^{
        
        obj = [[AilShareduAppDependency alloc]init];
    });
    return obj;
    
}

-(void)initialize
{
 //   [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPrivacyConsent:AIATPrivacyStatusUnknown];

}

@end
