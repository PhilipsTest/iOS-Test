//
//  URJanRainRequestFormatter.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 19/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URJanRainRequestFormatter.h"
#import "JRCaptureData.h"
#import "DIConstants.h"
#import "URSettingsWrapper.h"

#define joinParams(...)             [@[__VA_ARGS__] componentsJoinedByString:@"&"]
#define joinKeyValue(key, value)    [NSString stringWithFormat:@"%@=%@", key, value]

@interface URJanRainRequestFormatter()

@property (nonatomic, strong) NSString *janrainBaseURL;
@property (nonatomic, strong) NSString *urxBaseURL;

@end

@implementation URJanRainRequestFormatter

- (instancetype)initWithJanRainURL:(NSString *)janrainBaseURLString urxBaseURL:(NSString *)urxBaseURLString {
    self = [super init];
    if (self) {
        _janrainBaseURL = janrainBaseURLString;
        NSURL *hostURL = [[NSURL URLWithString:@"/" relativeToURL:[NSURL URLWithString:urxBaseURLString]] absoluteURL];
        _urxBaseURL =  hostURL.absoluteString;
    }
    return self;
}


- (NSURLRequest *)resetPasswordRequestForEmail:(NSString *)email {
    NSString *requestParams = joinParams(joinKeyValue(@"client_id",                     [JRCaptureData sharedCaptureData].clientId),
                                         joinKeyValue(@"locale",                        [JRCaptureData sharedCaptureData].captureLocale),
                                         joinKeyValue(@"response_type",                 @"code"),
                                         joinKeyValue(@"form",                          CAPTURE_FORGOTTEN_PASSWORD_FORMNAME),
                                         joinKeyValue(@"traditionalSignIn_emailAddress",[self stringByAddingUrlPercentEscapesToString:email]),
                                         joinKeyValue(@"flow",                          [JRCaptureData sharedCaptureData].captureFlowName),
                                         joinKeyValue(@"flow_version",                  [JRCaptureData sharedCaptureData].downloadedFlowVersion),
                                         joinKeyValue(@"redirect_uri",                  [self stringByAddingUrlPercentEscapesToString:self.resetPasswordRedirectURI]));
    return [self requestWithURL:[NSString stringWithFormat:@"%@/oauth/forgot_password_native/",self.janrainBaseURL] parameters:requestParams];
}


- (NSURLRequest *)updateMobileNumberRequest:(NSString *)mobileNumber {
    NSString *requestParams = joinParams(joinKeyValue(@"client_id",           [JRCaptureData sharedCaptureData].clientId),
                                         joinKeyValue(@"locale",              [JRCaptureData sharedCaptureData].captureLocale),
                                         joinKeyValue(@"response_type",       @"token"),
                                         joinKeyValue(@"form",                CAPTURE_TRADITIONAL_MOBILE_UPDATEFORMNAME),
                                         joinKeyValue(@"flow",                [JRCaptureData sharedCaptureData].captureFlowName),
                                         joinKeyValue(@"flow_version",        [JRCaptureData sharedCaptureData].downloadedFlowVersion),
                                         joinKeyValue(@"token",               [JRCaptureData sharedCaptureData].accessToken),
                                         joinKeyValue(@"mobileNumber",        mobileNumber),
                                         joinKeyValue(@"mobileNumberConfirm", mobileNumber));
    return [self requestWithURL:[NSString stringWithFormat:@"%@/oauth/update_profile_native/",self.janrainBaseURL] parameters:requestParams];
}


- (NSURLRequest *)resendVerificationCodeRequestForMobile:(NSString *)mobileNumber {
    NSString *redirectURIParams = [NSString stringWithFormat:@"%@/api/v1/user/requestVerificationSmsCode?provider=%@&locale=%@&phonenumber=%@",self.urxBaseURL,@"JANRAIN-CN",@"zh_CN",mobileNumber];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectURIParams]];
    [request setHTTPMethod:@"POST"];
    return request;
}


- (NSURLRequest *)accountActivationRequestForUUID:(NSString *)uuid verificationCode:(NSString *)verificationCode {
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-ilo01"];
    uuid = [[uuid componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];
    NSMutableString *updatedVerificationCode = [[NSMutableString alloc] initWithString:verificationCode];
    while (updatedVerificationCode.length <= 32) {
        [updatedVerificationCode appendString:uuid];
    }
    NSString *requestParams=joinParams(joinKeyValue(@"verification_code",[updatedVerificationCode substringToIndex:32]));
    return [self requestWithURL:[NSString stringWithFormat:@"%@/access/useVerificationCode",self.janrainBaseURL] parameters:requestParams];
}


- (NSURLRequest *)resetPasswordRequestForMobileNumber:(NSString *)mobileNumber {
    NSString *redirectURI = [self.resetPasswordRedirectURI stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSString *requestParams = joinParams(joinKeyValue(@"clientId",      [self resetPasswordClientId]),
                                         joinKeyValue(@"locale",        @"zh_CN"),
                                         joinKeyValue(@"code_type",     @"short"),
                                         joinKeyValue(@"phonenumber",   mobileNumber),
                                         joinKeyValue(@"provider",      @"JANRAIN-CN"),
                                         joinKeyValue(@"redirectUri",   redirectURI));
    return [self requestWithURL:[NSString stringWithFormat:@"%@api/v1/user/requestPasswordResetSmsCode",self.urxBaseURL] parameters:requestParams];
}

#pragma mark - Helper Methods
#pragma mark -

- (NSURLRequest *)requestWithURL:(NSString *)urlString parameters:(NSString *)queryParameters {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *bodyData=[queryParameters dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

- (NSString *)stringByAddingUrlPercentEscapesToString:(NSString *)sourceString {
    NSString *encodedString = [sourceString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet]];
    return encodedString;
}


- (NSString *)resetPasswordClientId {
    
    AIAIAppState state = [DIRegistrationAppIdentity getAppState];
    NSString *country = [[URSettingsWrapper sharedInstance].dependencies.appInfra.serviceDiscovery getHomeCountry];
    NSArray *stateStrings = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
    NSString *stateString;
    if ([country isEqualToString:@"CN"] == true) {
        NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"65dzkyh48ux4vcguhvwsgvtk4bzyh2va", nil] forKeys:stateStrings];
        stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
    } else {
       NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr", nil] forKeys:stateStrings];
        stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
    }
    return stateString;
}

@end
