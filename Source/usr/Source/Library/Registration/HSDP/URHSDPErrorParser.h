//
//  URHSDPErrorParser.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 16/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URBaseErrorParser.h"

@interface URHSDPErrorParser : URBaseErrorParser

+ (NSError *)mappedErrorForError:(NSError *)error response:(NSDictionary *)response;

@end
