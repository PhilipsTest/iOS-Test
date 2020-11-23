//
//  PRXSummaryPRXResponseData.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXResponseData.h"

@class PRXSummaryData;

@interface PRXSummaryResponse : PRXResponseData

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) PRXSummaryData *data;

@end
