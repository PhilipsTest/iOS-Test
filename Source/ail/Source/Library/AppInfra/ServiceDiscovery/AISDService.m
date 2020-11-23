//
//  AISDService.m
//  AppInfra
//
//  Created by Hashim MH on 08/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import "AISDService.h"

@implementation AISDService

- (instancetype)initWithUrl:(NSString *)url andLocale:(NSString*)locale{
    self = [super init];
    if (self) {
        self.url = url;
        self.locale = locale;
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"url:%@\n error:%@\n locale:%@\n",self.url,self.error, self.locale];
}

@end
