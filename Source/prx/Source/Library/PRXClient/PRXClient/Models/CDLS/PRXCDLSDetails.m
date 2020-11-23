/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXCDLSDetails.h"

static NSString *const kPRXDetailPhoneNumber            = @"phoneNumber";
static NSString *const kPRXDetailPhoneNumberType        = @"phoneNumberType";
static NSString *const kPRXDetailPhoneTariff            = @"phoneTariff";
static NSString *const kPRXDetailPhoneNumberLabel       = @"phoneNumberLabel";
static NSString *const kPRXDetailOpeningHoursWeekdays   = @"openingHoursWeekdays";
static NSString *const kPRXDetailOpeningHoursSaturday   = @"openingHoursSaturday";
static NSString *const kPRXDetailRank                   = @"rank";
static NSString *const kPRXDetailOpeningHoursSunday     = @"openingHoursSunday";
static NSString *const kPRXDetailOptionalData1          = @"optionalData1";
static NSString *const kPRXDetailOptionalData2          = @"optionalData2";
static NSString *const kPRXDetailContent                = @"content";
static NSString *const kPRXDetailLabel                  = @"label";
static NSString *const kPRXDetailContentPath            = @"contentPath";
static NSString *const kPRXDetailMedia                  = @"media";

@interface PRXCDLSDetails ()
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
@end

@implementation PRXCDLSDetails

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary: dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.phoneNumber            = [self objectOrNilForKey:kPRXDetailPhoneNumber fromDictionary:dict];
        self.phoneNumberType        = [self objectOrNilForKey:kPRXDetailPhoneNumberType fromDictionary:dict];
        self.phoneNumberLabel       = [self objectOrNilForKey:kPRXDetailPhoneNumberLabel fromDictionary:dict];
        self.phoneTariff            = [self objectOrNilForKey:kPRXDetailPhoneTariff fromDictionary:dict];
        
        self.media                  = [self objectOrNilForKey:kPRXDetailMedia fromDictionary:dict];
        self.label                  = [self objectOrNilForKey:kPRXDetailLabel fromDictionary:dict];
        self.contentPath            = [self objectOrNilForKey:kPRXDetailContentPath fromDictionary:dict];
        self.content                = [self objectOrNilForKey:kPRXDetailContent fromDictionary:dict];
        self.rank                   = [self objectOrNilForKey:kPRXDetailRank fromDictionary:dict];
        
        self.openingHoursWeekdays   = [self objectOrNilForKey:kPRXDetailOpeningHoursWeekdays fromDictionary:dict];
        self.openingHoursSaturday   = [self objectOrNilForKey:kPRXDetailOpeningHoursSaturday fromDictionary:dict];
        self.openingHoursSunday     = [self objectOrNilForKey:kPRXDetailOpeningHoursSunday fromDictionary:dict];
        
        self.optionalData1          = [self objectOrNilForKey:kPRXDetailOptionalData1 fromDictionary:dict];
        self.optionalData2          = [self objectOrNilForKey:kPRXDetailOptionalData2 fromDictionary:dict];
    }
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
