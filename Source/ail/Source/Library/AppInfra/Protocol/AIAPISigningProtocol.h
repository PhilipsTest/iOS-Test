//
//  AIAPISigningProtocol.h
//  AppInfra
//
//  Created by Abhishek on 27/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

#define createSignature clonableClient

/**
 protocol for defining api signing methods
 */
@protocol AIAPISigningProtocol <NSObject>

/**
 Creates an API signer instance according to HSDP specification

 @param requestMethod Type of method(POST, GET)
 @param url Request URL
 @param requestUrlQuery Request URL query. applicationName=uGrow
 @param allHttpHeaderFields Request http header fields. Current date is passed as http header value.
 @param httpBody Request body
 @return returns a signature
 @since 1.1.0
 */
- (NSString *)createSignature:(NSString *)requestMethod dhpUrl:(NSString *)url queryString:(NSString *)requestUrlQuery headers:(NSDictionary *)allHttpHeaderFields requestBody:(NSData *)httpBody;

@end
