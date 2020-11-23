//
//  URJWTParser.m
//  PhilipsRegistration
//
//  Created by Adarsh Kumar Rai on 16/05/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "URJWTParser.h"
#import "DILogger.h"

@implementation URJWTParser

- (instancetype)initWithJWTToken:(NSString *)jwtToken {
    self = [super init];
    if (self) {
        NSArray *components = [jwtToken componentsSeparatedByString:@"."];
        if (components.count != 3) {
            DIRErrorLog(@"Invalid jwt token: %@", jwtToken);
        } else {
            NSData *headersData = [self base64Decode:components.firstObject];
            if(headersData.length > 0) {
                _headers = [NSJSONSerialization JSONObjectWithData:headersData options:kNilOptions error:nil];
            }
            NSData *payloadData = [self base64Decode:components[1]];
            if (payloadData.length > 0) {
                _payload = [NSJSONSerialization JSONObjectWithData:payloadData options:kNilOptions error:nil];
            }
        }
    }
    return self;
}


- (NSData *)base64Decode:(NSString *)string {
    if (string.length %4 != 0) {
        NSInteger padLength = 4 - (string.length % 4);
        for (int i = 0; i < padLength ; i++) {
            string = [string stringByAppendingString:@"="];
        }
    }
    return [[NSData alloc] initWithBase64EncodedString:string options:0];
}

@end
