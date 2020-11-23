//
//  PRXDisclaimerResponse.h
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXResponseData.h"

@class PRXDisclaimerData;

/**
 Maps the Response data to Disclaimer
 */
@interface PRXDisclaimerResponse : PRXResponseData

/**
 True if NSDictionary object passed into the model class doesn't break the parsing.
 */
@property (nonatomic, assign) BOOL success;
/**
 Holds the Response Data in data
 */
@property (nonatomic, strong) PRXDisclaimerData *data;

@end
