//
//  PRXSummaryBrand.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PRXSummaryBrand : NSObject

@property (nonatomic, strong) NSString *brandLogo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
