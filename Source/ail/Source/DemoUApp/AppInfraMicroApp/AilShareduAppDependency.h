//
//  AilShareduAppDependency.h
//  AppInfraMicroApp
//
//  Created by Ravi Kiran HR on 16/03/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UAPPFramework/UAPPFramework.h>

@interface AilShareduAppDependency : NSObject
+(instancetype)sharedDependency;
@property(nonatomic,strong)UAPPDependencies *uAppDependency;

-(void)initialize;
@end
