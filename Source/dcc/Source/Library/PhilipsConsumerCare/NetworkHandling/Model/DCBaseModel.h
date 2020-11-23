//
//  DCBaseModel.h
//  DigitalCare
//
//  Created by sameer sulaiman on 25/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <Foundation/Foundation.h>

@interface DCBaseModel : NSObject

@property (assign) BOOL success;
@property (nonatomic, retain) NSString *displayMessage;
@property (nonatomic, retain) NSString *exceptionMessage;
@property (assign) NSInteger responseCode;

@end
