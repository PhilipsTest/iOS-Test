/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSMutableURLRequest (JRRequestUtils)

+ (NSMutableURLRequest *)JR_requestWithURL:(NSURL *)url params:(NSDictionary *)dictionary;
- (void)JR_setBodyWithParams:(NSDictionary *)dictionary;

@end

@interface NSString (JRString_UrlEscaping)

- (NSString *)stringByAddingUrlPercentEscapes;

@end

@interface NSDictionary (JRQueryParams)

- (NSString *)asJRURLParamString;

@end

@interface PIMJRRequestParameters : NSObject

@property (nonatomic,nonnull,strong) NSString *access_token;
@property (nonatomic,nonnull,strong) NSString *refresh_secret;
@property (nonatomic,nonnull,strong) NSString *date_string;
@property (nonatomic,nonnull,strong) NSString *client_id;
@property (nonatomic,nonnull,strong) NSString *url_string;
@property (nonatomic,nonnull,strong) NSString *locale;

@end

@interface PIMJRSignatureCreator : NSObject


+(void)refreshJRAccessTokenWithParameters:(PIMJRRequestParameters *)parameter completionHandler:(void (^)(NSURLResponse *_Nullable response, NSData * _Nullable data, NSError *_Nullable error))completionHandler;

+ (NSString *)base64SignatureForRefreshWithDate:(NSString *)dateString refreshSecret:(NSString *)refreshSecret
                                    accessToken:(NSString *)accessToken;

@end

@interface NSData (JRData)

- (NSString *)JRBase64EncodedString;

@end

NS_ASSUME_NONNULL_END
