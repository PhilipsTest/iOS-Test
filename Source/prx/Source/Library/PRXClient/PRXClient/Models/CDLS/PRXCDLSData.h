/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PRXCDLSDetails;

@interface PRXCDLSData : NSObject

@property (nonatomic, nullable, strong) NSArray<PRXCDLSDetails *> *contactPhone;
@property (nonatomic, nullable, strong) NSArray<PRXCDLSDetails *> *contactChat;
@property (nonatomic, nullable, strong) NSArray<PRXCDLSDetails *> *contactEmail;
@property (nonatomic, nullable, strong) NSArray<PRXCDLSDetails *> *contactSocial;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
