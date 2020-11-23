//
//  AIClientComponent.m
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import "AIClientComponent.h"

@implementation AIClientComponent

- (instancetype)initWithIdentifier:(NSString *)identifier version:(NSString *)version
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.version = version;
    }
    return self;
}

@end