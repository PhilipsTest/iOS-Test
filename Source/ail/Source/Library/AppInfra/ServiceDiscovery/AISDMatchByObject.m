//
//  MatchByObject.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/16/16.
//  /*Copyright (c) Koninklijke Philips N.V., 2016 All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import "AISDMatchByObject.h"
#import "AISDResults.h"


@implementation AISDMatchByObject
+ (NSArray *)getMatchingObjects:(NSObject *)obj
{
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    NSObject *receivedResults = obj;
    NSMutableArray *parsedResults = [NSMutableArray array];
    if ([receivedResults isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedResults) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedResults addObject:[AISDResults modelObjectWithDictionary:item]];
            }
        }
    } else if ([receivedResults isKindOfClass:[NSDictionary class]]) {
        [parsedResults addObject:[AISDResults modelObjectWithDictionary:(NSDictionary *)receivedResults]];
    }
    
    return  [NSArray arrayWithArray:parsedResults];
    
    
}



@end
