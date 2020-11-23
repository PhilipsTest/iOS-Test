//
//  URJanrainErrorParser.h
//  Registration
//
//  Created by Sai Pasumarthy on 12/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URBaseErrorParser.h"

@interface URJanrainErrorParser : URBaseErrorParser
+ (NSError *)mappedErrorForJanrainError:(NSError *)error;
@end
