//
//  PRXResponseData.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "PRXResponseData.h"

@class PRXAssetData;

/**
 Maps the Response data to Assets
 @since 1.0.0
 */
@interface PRXAssetResponse : PRXResponseData

 /**
  True if NSDictionary object passed into the model class doesn't break the parsing.
  @since 1.0.0
 */
@property (nonatomic, assign) BOOL success;
 /**
  Holds the Response Data in data
  @since 1.0.0
  */
@property (nonatomic, strong) PRXAssetData *data;

@end
