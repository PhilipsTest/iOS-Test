/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


#import "PRXCDLSData.h"
#import "PRXCDLSDetails.h"

static NSString *const kPRXCDLSPhone = @"phone";
static NSString *const kPRXCDLSChat = @"chat";
static NSString *const kPRXCDLSEmail = @"email";
static NSString *const kPRXCDLSSocial = @"social";

@implementation PRXCDLSData

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary: dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.contactPhone = [self parseCDLSDetail:[dict objectForKey:kPRXCDLSPhone]];
        self.contactSocial = [self parseCDLSDetail:[dict objectForKey:kPRXCDLSSocial]];
        self.contactChat = [self parseCDLSDetail:[dict objectForKey:kPRXCDLSChat]];
        self.contactEmail = [self parseCDLSDetail:[dict objectForKey:kPRXCDLSEmail]];
    }
    return self;
}

- (NSArray*)parseCDLSDetail: (NSDictionary *)phoneDetail {
    NSMutableArray *parsedDetail = [NSMutableArray array];
    if ([phoneDetail isKindOfClass:[NSArray class]]) {
        for (NSDictionary *phoneNumberDetail in (NSArray *)phoneDetail) {
            if ([phoneNumberDetail isKindOfClass:[NSDictionary class]]) {
                [parsedDetail addObject:[PRXCDLSDetails modelObjectWithDictionary:phoneNumberDetail]];
            }
        }
    }
    return parsedDetail;
}

@end
