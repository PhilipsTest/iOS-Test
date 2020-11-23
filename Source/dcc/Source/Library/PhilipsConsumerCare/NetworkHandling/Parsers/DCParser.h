//
//  DCParser.h
//  DigitalCare
//
//  Created by sameer sulaiman on 17/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <Foundation/Foundation.h>
#import "DCConstants.h"

@interface DCParser : NSObject

@property(nonatomic,assign)DCParserType parserType;

- (id) parse : (NSData*)resultData;
- (void) clearCachedData;

@end
