//
//  PRXResponseData.m
//  PRXClient
//
//  Created by KRISHNA KUMAR on 28/10/15.
//  Copyright © 2015 philips. All rights reserved.
//

#import "PRXResponseData.h"


@implementation PRXResponseData

-(PRXResponseData *)parseResponse:(id)data
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass of PRXResponseData", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    return nil;
}

@end

