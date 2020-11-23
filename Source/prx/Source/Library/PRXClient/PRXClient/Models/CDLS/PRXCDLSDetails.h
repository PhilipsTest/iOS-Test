/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRXCDLSDetails : NSObject

@property (nonatomic, nullable, strong) NSString *phoneNumber;
@property (nonatomic, nullable, strong) NSString *phoneNumberType;
@property (nonatomic, nullable, strong) NSString* phoneTariff;
@property (nonatomic, nullable, strong) NSString *phoneNumberLabel;

@property (nonatomic, nullable, strong) NSString *optionalData1;
@property (nonatomic, nullable, strong) NSString *optionalData2;
@property (nonatomic, nullable, strong) NSString *content;

@property (nonatomic, nullable, strong) NSString *openingHoursWeekdays;
@property (nonatomic, nullable, strong) NSString *openingHoursSaturday;
@property (nonatomic, nullable, strong) NSString *openingHoursSunday;

@property (nonatomic, nullable, strong) NSString *rank;

@property (nonatomic, nullable, strong) NSString *label;
@property (nonatomic, nullable, strong) NSString *contentPath;

@property (nonatomic, nullable, strong) NSString *media;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
