//
//  DCContactsModel.h
//  DigitalCare
//
//  Created by sameer sulaiman on 18/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <Foundation/Foundation.h>
#import "DCBaseModel.h"
@interface DCContactsModel : DCBaseModel

@property(nonatomic,strong)NSString* phoneNumber;
@property(nonatomic,strong)NSString* phoneTariff;
@property(nonatomic,strong)NSString* openingHoursWeekdays;
@property(nonatomic,strong)NSString* openingHoursSaturday;
@property(nonatomic,strong)NSString* openingHoursSunday;
@property(nonatomic,strong)NSString* optionalData1;
@property(nonatomic,strong)NSString* optionalData2;
@property(nonatomic,strong)NSString* chatOpeningHoursWeekdays;
@property(nonatomic,strong)NSString* chatOpeningHoursSaturday;
@property(nonatomic,strong)NSString* chatContent;
@property(nonatomic,strong)NSString* emailLabel;
@property(nonatomic,strong)NSString* emailContentPath;

@end
