//
//  URExceptionHandler.h
//  RegistrationiOS
//
//  Created by Adarsh Kumar Rai on 21/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URExceptionHandler : NSObject

+ (NSString *)lastExceptionDetails;
+ (void)installExceptionHandlers;

@end
