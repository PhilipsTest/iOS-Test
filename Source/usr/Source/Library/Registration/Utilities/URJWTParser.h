//
//  URJWTParser.h
//  PhilipsRegistration
//
//  Created by Adarsh Kumar Rai on 16/05/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URJWTParser : NSObject

- (instancetype)initWithJWTToken:(NSString *)jwtToken;

@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *payload;

@end
