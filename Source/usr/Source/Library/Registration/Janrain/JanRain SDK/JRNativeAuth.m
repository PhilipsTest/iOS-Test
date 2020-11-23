/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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

#import "JRNativeAuth.h"
#import "debug_log.h"
#import "JRConnectionManager.h"
#import "JRNativeAuthConfig.h"
#import "JRNativeWeChat.h"

@interface JRNativeAuth ()
@property (nonatomic) JRNativeProvider *nativeProvider;
@end

@implementation JRNativeAuth

+ (BOOL)canHandleProvider:(NSString *)provider
{
    if ([provider isEqualToString:@"wechat"] && [JRNativeWeChat canHandleAuthentication]) return YES;

    return NO;
}

+ (JRNativeProvider *)nativeProviderNamed:(NSString *)provider withConfiguration:(id <JRNativeAuthConfig>)config {
    JRNativeProvider *nativeProvider = nil;

    if ([provider isEqualToString:@"wechat"]) {
        nativeProvider = [[JRNativeWeChat alloc] init];
        [(JRNativeWeChat *)nativeProvider setWeChatAppId:config.weChatAppId];
        [(JRNativeWeChat *)nativeProvider setWeChatAppSecret:config.weChatAppSecret];
    } else {
        [NSException raiseJRDebugException:@"unexpected native auth provider" format:provider];
    }

    return nativeProvider;
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options provider:(JRNativeProvider *)provider
{
    Boolean isWechatAppIDInURL = (([url.absoluteString containsString:[(JRNativeWeChat *)provider weChatAppId]]) || ([url.scheme isEqual:[(JRNativeWeChat *)provider weChatAppId]]));
    if ( (true == isWechatAppIDInURL)  && [JRNativeWeChat urlHandler:url]) {
        return YES;
    }
    return NO;
}


@end
