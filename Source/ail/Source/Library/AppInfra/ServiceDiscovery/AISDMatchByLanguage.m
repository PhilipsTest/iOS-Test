//
//  MatchByLanguage.m
//
//  Created by Ravi Kiran HR on 6/14/16
 /* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/ 

#import "AISDMatchByLanguage.h"
#import "AISDResults.h"
#import "AISDMatchByObject.h"
#import "AIUtility.h"

NSString *const kMatchByLanguageResults = @"results";
NSString *const kMatchByLanguageAvailable = @"available";


@implementation AISDMatchByLanguage

@synthesize results = _results;
@synthesize available = _available;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedResults = dict[kMatchByLanguageResults];
        
        self.results = [NSArray arrayWithArray:[AISDMatchByObject getMatchingObjects:receivedResults]];
        self.available = [[AIUtility objectOrNilForKey:kMatchByLanguageAvailable
                                        fromDictionary:dict] boolValue];
        
    }
    return self;
}

@end
