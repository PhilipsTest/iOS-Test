//
//  MockPRXRequestiManager.m
//  PRXClientTests
//
//  Created by Prasad Devadiga on 21/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "MockPRXRequestManager.h"

@implementation MockPRXRequestManager

- (void)execute:(PRXRequest*) request completion:(void (^)(PRXResponseData *response))success failure:(void(^)(NSError *error))failure{

    if (self.type == requestTypeDisclaimer) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"disclaimer" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        success([request getResponse:json]);
    } else if (self.type == requestTypeError) {
        NSError *customError = [[NSError alloc] initWithDomain:@"PRXClient"
                                                          code:0
                                                      userInfo:nil];
        failure(customError);
    }
}

@end
