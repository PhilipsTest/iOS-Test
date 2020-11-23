//
//  URJanRainRequestFormatter.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 19/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URJanRainRequestFormatter : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithJanRainURL:(NSString *)janrainBaseURLString urxBaseURL:(NSString *)urxBaseURLString NS_DESIGNATED_INITIALIZER;

- (NSURLRequest *)resetPasswordRequestForEmail:(NSString *)email;
- (NSURLRequest *)updateMobileNumberRequest:(NSString *)mobileNumber;
- (NSURLRequest *)resendVerificationCodeRequestForMobile:(NSString *)mobileNumber;
- (NSURLRequest *)accountActivationRequestForUUID:(NSString *)uuid verificationCode:(NSString *)verificationCode;
- (NSURLRequest *)resetPasswordRequestForMobileNumber:(NSString *)mobileNumber;

@property (nonatomic, strong) NSString *resetPasswordRedirectURI;

@end
