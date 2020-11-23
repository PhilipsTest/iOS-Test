//
//  AILogMetaData.h
//  AppInfra
//
//  Created by Hashim MH on 26/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AILogMetaData : NSObject
@property(nonatomic,strong) NSString *eventId;
@property(nonatomic,strong) NSString *component;
@property(nonatomic,strong) NSDictionary *params;
@property(nonatomic,strong) NSString *originatingUser;
@property(nonatomic,strong) NSDate *networkDate;

@end
