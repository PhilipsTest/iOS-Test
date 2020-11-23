//
//  PRXResponseData.h
//  PRXClient
//
//  Created by KRISHNA KUMAR on 28/10/15.
//  Copyright © 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 An abstract base class for all response model classes.
 @since 1.0.0
 */
@interface PRXResponseData : NSObject

 /**
  Response data is parsed
  @since 1.0.0
 */
-(PRXResponseData *)parseResponse:(id)data;

@end


