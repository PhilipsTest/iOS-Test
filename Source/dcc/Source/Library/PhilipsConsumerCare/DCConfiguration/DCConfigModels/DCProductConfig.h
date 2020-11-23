//
//  DCProductConfig.h
//  DigitalCare
//
//  Created by KRISHNA KUMAR on 06/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface DCProductConfig : NSObject

@property (nonatomic, strong) NSArray *productConfigArray;

-(id)initWithArrayData:(NSArray*)array;

@end
