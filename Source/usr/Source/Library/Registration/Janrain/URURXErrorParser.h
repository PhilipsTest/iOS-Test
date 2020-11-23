//
//  URURXErrorParser.h
//  Registration
//
//  Created by Sai Pasumarthy on 10/10/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "URBaseErrorParser.h"

@interface URURXErrorParser : URBaseErrorParser
+ (NSDictionary *)mappedErrorForURXResponseData:(NSData *)response statusCode:(NSInteger)statusCode serverError:(NSError *)serverError error:(NSError **)error;
@end
