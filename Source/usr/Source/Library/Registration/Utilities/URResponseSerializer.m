//
//  URResponseSerializer.m
//  PhilipsRegistration
//
//  Created by Sagarika Barman on 2/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "URResponseSerializer.h"


@implementation URResponseSerializer


+ (BOOL)supportsSecureCoding {
    return false;
}


- (nullable id)responseObjectForResponse:(NSURLResponse *)response
                                    data:(NSData *)data
                                   error:(NSError *__autoreleasing *)error {
    return data;
}


- (void)encodeWithCoder:(nonnull NSCoder *)aCoder { 
}


- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder { 
    return self;
}


- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    return self;
}

@end
