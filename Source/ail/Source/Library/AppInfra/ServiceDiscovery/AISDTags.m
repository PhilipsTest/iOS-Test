//
//  Tags.m
//
//  Created by Ravi Kiran HR on 6/14/16
 /* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/ 

#import "AISDTags.h"
#import "AIUtility.h"

NSString *const kTagsId = @"id";
NSString *const kTagsName = @"name";
NSString *const kTagsKey = @"key";



@implementation AISDTags

@synthesize tagsIdentifier = _tagsIdentifier;
@synthesize name = _name;
@synthesize key = _key;


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
        self.tagsIdentifier = [AIUtility objectOrNilForKey:kTagsId fromDictionary:dict];
        self.name = [AIUtility objectOrNilForKey:kTagsName fromDictionary:dict];
        self.key = [AIUtility objectOrNilForKey:kTagsKey fromDictionary:dict];
    }
    
    return self;
    
}

@end
