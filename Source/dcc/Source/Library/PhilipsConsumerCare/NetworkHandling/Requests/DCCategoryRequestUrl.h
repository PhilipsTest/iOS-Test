//
//  DCCategoryRequest.h
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 16/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRequestBaseUrl.h"
#import "DCCategoryParser.h"


@interface DCCategoryRequestUrl : DCRequestBaseUrl

@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *subUrl;

@end
