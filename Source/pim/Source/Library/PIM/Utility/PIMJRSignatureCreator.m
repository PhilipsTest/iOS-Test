/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

#import "PIMJRSignatureCreator.h"


@implementation NSMutableURLRequest (JRRequestUtils)

+ (NSMutableURLRequest *)JR_requestWithURL:(NSURL *)url params:(NSDictionary *)params {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request JR_setBodyWithParams:params];

    return request;
}

- (void)JR_setBodyWithParams:(NSDictionary *)dictionary
{
    [self setHTTPMethod:@"POST"];
    NSString *paramString = [dictionary asJRURLParamString];
    [self setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

@implementation NSString (JRString_UrlEscaping)

- (NSString *)stringByAddingUrlPercentEscapes
{
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    NSString *encoded = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    return encoded;
}

@end


@implementation NSDictionary (JRQueryParams)

- (NSString *)asJRURLParamString
{
    NSMutableString *retVal = [NSMutableString string];

    for (id key in [self allKeys])
    {
        if ([retVal length] > 0) [retVal appendString:@"&"];
        NSString *value = [self objectForKey:key];
        NSString *urlEncodedValue = [value stringByAddingUrlPercentEscapes];
        [retVal appendFormat:@"%@=%@", key, urlEncodedValue];
    }

    return retVal;
}

@end

@implementation PIMJRRequestParameters

@end


@implementation PIMJRSignatureCreator

+(void)refreshJRAccessTokenWithParameters:(PIMJRRequestParameters *)parameter completionHandler:(void (^)(NSURLResponse *_Nullable response, NSData * _Nullable data, NSError *_Nullable error))completionHandler {
    NSString *refreshUrl = [NSString stringWithFormat:@"%@/oauth/refresh_access_token", parameter.url_string];
    NSString *signature = [self base64SignatureForRefreshWithDate:parameter.date_string refreshSecret:parameter.refresh_secret
                                                      accessToken:parameter.access_token];

    NSDictionary *params = @{
            @"access_token" : parameter.access_token,
            @"signature" : signature,
            @"date" : parameter.date_string,
            @"client_id" : parameter.client_id,
            @"locale" : parameter.locale,
            @"flow" : @"standard",
            @"flow_version" : @"HEAD"
    };
    
    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:refreshUrl] params:params];
    
    NSURLSessionTask *task =  [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"%@ \n response %@ \n Error %@",[[NSString alloc] initWithData:data
//        encoding:NSUTF8StringEncoding] , response,error);
        if (error != nil)
        {
            completionHandler(nil,nil,error);
        } else {
            completionHandler(response,data,nil);
        }
    }];
    [task resume];
}


+ (NSString *)base64SignatureForRefreshWithDate:(NSString *)dateString refreshSecret:(NSString *)refreshSecret
                                    accessToken:(NSString *)accessToken
{
    if (!refreshSecret) return nil;
    NSString *stringToSign = [NSString stringWithFormat:@"refresh_access_token\n%@\n%@\n", dateString, accessToken];

    const char *cKey  = [refreshSecret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [stringToSign cStringUsingEncoding:NSUTF8StringEncoding];

    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    return [[[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)] JRBase64EncodedString];
}

@end


@implementation NSData (JRData)

- (NSString *)JRBase64EncodedString
{
    return [self JRBase64EncodedStringWithWrapWidth:0];
}

- (NSString *)JRBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    unsigned char *lookup = (unsigned char *) "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    NSUInteger inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    NSUInteger maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long i;
    NSUInteger outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                               length:outputLength
                                             encoding:NSASCIIStringEncoding
                                         freeWhenDone:YES];
    }
    else if (outputBytes)
    {
        free(outputBytes);
    }
    return nil;
}

@end
