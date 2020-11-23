//
//  NetworkHelper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 25/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (void)verifyUserWithUUID:(NSString *)userUUID withCompletion:(void(^)(NSError *error))completion {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];//emailVerified
    NSString *payload = [NSString stringWithFormat:@"client_id=dega75jq459kv7gnr8y26a8qw3784cju&client_secret=jgcrr54nsjkth4xxankrj5rfefv2c94x&type_name=user&uuid=%@&attributes={\"emailVerified\": \"%@\"}", userUUID, formattedDate];
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded"};
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://philips.eval.janraincapture.com/entity.update"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    [request setAllHTTPHeaderFields:headers];
    NSURLSession *session = [NSURLSession sharedSession];
    NSLog(@"Payload: %@", payload);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"Server Error: %@", error);
                                                        completion(error);
                                                    } else {
                                                        NSDictionary *lDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                        NSLog(@"Server Response: %@", lDict);
                                                        if ([lDict[@"stat"] isEqualToString:@"ok"]) {
                                                            completion(nil);
                                                        } else {
                                                            completion([NSError errorWithDomain:@"Dummy Domain" code:12234 userInfo:nil]);
                                                        }
                                                    }
                                                    dispatch_semaphore_signal(semaphore);
                                                }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"Returning after result");
}


+ (void)verifyChinaUserWithUUID:(NSString *)userUUID withCompletion:(void(^)(NSError *error))completion {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];//emailVerified
    NSString *payload = [NSString stringWithFormat:@"client_id=td2gm22dfzk9s4fn2hqywk3cut5qe6wm&client_secret=sq6mhpvv6sqr3cs7dfpe69vdsv7b3twp&type_name=user&uuid=%@&attributes={\"emailVerified\": \"%@\"}", userUUID, formattedDate];
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded"};
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://philips-cn-staging.capture.cn.janrain.com/entity.update"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    [request setAllHTTPHeaderFields:headers];
    NSURLSession *session = [NSURLSession sharedSession];
    NSLog(@"Payload: %@", payload);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"Server Error: %@", error);
                                                        completion(error);
                                                    } else {
                                                        NSDictionary *lDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                        NSLog(@"Server Response: %@", lDict);
                                                        if ([lDict[@"stat"] isEqualToString:@"ok"]) {
                                                            completion(nil);
                                                        } else {
                                                            completion([NSError errorWithDomain:@"Dummy Domain" code:12234 userInfo:nil]);
                                                        }
                                                    }
                                                    dispatch_semaphore_signal(semaphore);
                                                }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"Returning after result");
}


+ (void)retrieveAccountVerificationCodeForUser:(NSString *)uuid fromChinaStagingWithCompletion:(void(^)(NSString *code, NSError *error))completion {
    NSString *payload = [NSString stringWithFormat:@"client_id=td2gm22dfzk9s4fn2hqywk3cut5qe6wm&client_secret=sq6mhpvv6sqr3cs7dfpe69vdsv7b3twp&type_name=user&attribute_name=mobileNumberVerified&code_length=6&uuid=%@", uuid];
    NSDictionary *headers = @{@"content-type": @"application/x-www-form-urlencoded"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://philips-cn-staging.capture.cn.janrain.com/access/getVerificationNumber"]];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        } else {
            NSDictionary *lDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"Server Response: %@", lDict);
            if ([lDict[@"stat"] isEqualToString:@"ok"] && lDict[@"verification_code"]) {
                completion(lDict[@"verification_code"], nil);
            } else {
                completion(nil, [NSError errorWithDomain:@"Dummy Domain" code:12234 userInfo:nil]);
            }
            dispatch_semaphore_signal(semaphore);
        }
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


+ (void)deleteChinaUser:(NSString *)uuid fromChinaStagingWithCompletion:(void(^)(NSError *error))completion {
    NSDictionary *headers = @{@"content-type": @"application/x-www-form-urlencoded",
                             @"Authorization":@"Basic NnR6bXhyNjMzZWJ0eHI3YmRocDlwZnZoNHpzN3AzYXo6ZDVoOTZndjg5ZzRxbTY1MmFjcHd5YzduNHE2cHh2dmc="};
    NSString *postDataString = [NSString stringWithFormat:@"type_name=user&uuid=%@", uuid];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://philips-cn-staging.capture.cn.janrain.com/entity.delete"]];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Server Error: %@", error);
            completion(error);
        } else {
            NSDictionary *lDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"Server Response: %@", lDict);
            if ([lDict[@"stat"] isEqualToString:@"ok"]) {
                completion(nil);
            } else {
                completion([NSError errorWithDomain:@"Dummy Domain" code:12235 userInfo:nil]);
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end
