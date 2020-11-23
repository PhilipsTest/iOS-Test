//
//  PRXResponseData.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "PRXResponseData.h"

@class PRXAssetData;

@interface PRXAssetResponse : PRXResponseData

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) PRXAssetData *data;

@end
