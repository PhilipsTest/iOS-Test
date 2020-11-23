/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2013, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <objc/message.h>
#import "JRNativeWeChat.h"
#import "DILogger.h"
#import "JREngageError.h"
#import "DIHTTPUtility.h"
#import "URJanrainErrorParser.h"
#import "JRCapture.h"
#import "JRCaptureError.h"
#import "JREngage.h"
#import "JRCaptureData.h"
#define kWeChatAccessTokenURL @"https://api.weixin.qq.com/sns/oauth2/access_token"


@interface JRNativeWeChat ()
@end

@implementation JRNativeWeChat {
}

-(BOOL)isWeChatAppInstalled {
    
    Class signInClass = NSClassFromString(@"WXApi");
    SEL appInstaller = NSSelectorFromString(@"isWXAppInstalled");
    BOOL (*urlHandler)(id, SEL) = (void *)[signInClass methodForSelector:appInstaller];
    return urlHandler(signInClass, appInstaller);
}
+ (BOOL)canHandleAuthentication {
    
    return NSClassFromString(@"WXApi") ? YES : NO;
}

- (NSString *)provider {
    return @"wechat";
}
- (void)startAuthenticationWithCompletion:(NativeCompletionBlock)completion {
    
    [super startAuthenticationWithCompletion:completion];

    if (![self isWeChatAppInstalled]) {
        NSError * error = [JREngageError errorWithMessage:@"No access to WeChat accounts"
                                andCode:JRAuthenticationNoAccessToWeChatAccountsError];
        self.completion(error);
        return;
    }

    Class signInClass = NSClassFromString(@"WXApi");
    Class sendAuthReqClass = NSClassFromString(@"SendAuthReq");
    
    SEL sendAuthReqSelector = NSSelectorFromString(@"new");
    id (*getSendAuthReqID)(id, SEL) = (void *)[sendAuthReqClass methodForSelector:sendAuthReqSelector];
    id sendAuthReqobj = getSendAuthReqID(sendAuthReqClass, sendAuthReqSelector);
    
    SEL setClientIDSelector = NSSelectorFromString(@"setScope:");
    void (*setClientID)(id(sendAuthReqobj), SEL, NSString *) = (void *)[sendAuthReqobj methodForSelector:setClientIDSelector];
    setClientID(sendAuthReqobj, setClientIDSelector, @"snsapi_userinfo");
    
    SEL setScopesSelector = NSSelectorFromString(@"setState:");
    void (*setScopes)(id, SEL, NSString *) = (void *)[sendAuthReqobj methodForSelector:setScopesSelector];
    setScopes(sendAuthReqobj, setScopesSelector, [self getState]);
    
//    SEL getInstanceSelector = NSSelectorFromString(@"sendReq:");
//    void (*sendInstance)(id, SEL,id) = (void *)[signInClass methodForSelector:getInstanceSelector];
//    sendInstance(signInClass, getInstanceSelector,sendAuthReqobj);
    SEL getInstanceSelector = NSSelectorFromString(@"sendReq:completion:");
    void (^completionHandler)(BOOL success) = ^(BOOL success){
        DIRInfoLog(@"*-*-*-*-*- Completion handler status of wechat %d",success);
    };
    
    void (*sendInstance)(id, SEL,id,id) = (void *)[signInClass methodForSelector:getInstanceSelector];
    sendInstance(signInClass, getInstanceSelector,sendAuthReqobj,completionHandler);
    
}
+ (BOOL)urlHandler:(NSURL *)url {
    [[JREngage instance] nativeProvider].authInfo = url;

    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSArray *queryItems = [components queryItems];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (NSURLQueryItem *item in queryItems)
    {
        [dict setObject:[item value] forKey:[item name]];
    }
    if (dict[@"code"]) {
        [(JRNativeWeChat *)[[JREngage instance] nativeProvider] weChatAuthTokenWith:dict[@"code"]];
        return YES;
    }else{
        [[JREngage instance] nativeProvider].completion([JREngageError errorWithMessage:@"Native Wechat authentication canceled" andCode:JRAuthenticationCanceledError]);
    }
    
    return NO;
}
-(void)weChatAuthTokenWith:(NSString *)code{

    NSString *post = [NSString stringWithFormat:@"&appid=%@&secret=%@&grant_type=authorization_code&state=%@&code=%@",self.weChatAppId,self.weChatAppSecret,[self getState],code];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kWeChatAccessTokenURL]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];

    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    [DIHTTPUtility startURLConnectionWithRequest:request
                               completionHandler:^(id response, NSData *data, NSError *error)
     {
         if ((error && ![error isKindOfClass:[NSNull class]])) {
             self.completion([URJanrainErrorParser mappedErrorForJanrainError:error]);
         }else {
             NSError *jsonError;
             NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
             if (jsonError) {
                 self.completion(jsonError);
             }else{
                 if ([jsonData isKindOfClass:[NSDictionary class]]) {
                     [self startNativeWeChat:jsonData];
                 }else {
                     self.completion([URJanrainErrorParser mappedErrorForJanrainError:[NSError errorWithDomain:@"Invalid Fields" code:JRCaptureApidErrorInvalidArgument userInfo:jsonData]]);
                 }
             }
         }
     }];
    
}
-(void)startNativeWeChat:(NSDictionary *)weChatData{
    
    if([weChatData count] > 0){
        DIRDebugLog(@"WeChat Token Result: %@" , weChatData);
        if(![[weChatData objectForKey:@"access_token"] isEqual:@""]){
            NSString* weChatToken = [weChatData objectForKey:@"access_token"];
            NSString* weChatOpenId = @"WeChat_OpenId_Not_Found";
            if(![[weChatData objectForKey:@"openid"] isEqual:@""]){
                weChatOpenId = [weChatData objectForKey:@"openid"];
            }
            [self getAuthInfoTokenForAccessToken:weChatToken
                                  andTokenSecret:weChatOpenId];
            
            
        }
    }else{
        DIRDebugLog(@"WeChat Token Failed: %@" , weChatData);
        if (self.completion) {
            self.completion([URJanrainErrorParser mappedErrorForJanrainError:[NSError errorWithDomain:@"WeChat Error" code:JRCaptureLocalApidErrorInvalidResultStat userInfo:weChatData]]);
        }
    }
}
-(NSString*)getState {
    return @"123456";
}

@end
