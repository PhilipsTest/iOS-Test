//
//  PRXDataBuilder.h
//  PRXClient
//
//  Created by sameer sulaiman on 10/27/15.
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRXRequestManager.h"
#import "PRXResponseData.h"


@interface PRXDataBuilder : NSObject

@property (nonatomic, strong) NSString *sector;
@property (nonatomic, strong) NSString *locale;

-(PRXResponseData *)getResponse:(id)data;
-(NSString *)getRequestURL;

@end
