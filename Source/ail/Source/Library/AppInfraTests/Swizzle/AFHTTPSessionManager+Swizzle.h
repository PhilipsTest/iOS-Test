//
//  AFHTTPSessionManager+Swizzle.h
//  AppInfra
//
//  Created by leslie on 25/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (Swizzle)
/**
 * swizzling AFHTTPSessionManager methods for Unit testing purpose.
 */
+(void)loadSwizzler;

@end
