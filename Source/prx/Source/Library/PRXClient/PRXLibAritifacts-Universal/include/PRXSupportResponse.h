//
//  PRXFaqPRXResponseData.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXResponseData.h"

@class PRXFaqData;

@interface PRXSupportResponse : PRXResponseData

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) PRXFaqData *data;

@end
