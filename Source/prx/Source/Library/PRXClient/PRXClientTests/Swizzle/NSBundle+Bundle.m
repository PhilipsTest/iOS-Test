//
//  NSBundle+Bundle.m
//  AppInfra
//
//  Created by leslie on 05/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import "NSBundle+Bundle.h"
#import <objc/runtime.h>

@implementation NSBundle (Bundle)

+(void)loadSwizzler {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        Method originalMethod = class_getClassMethod(self, @selector(mainBundle));
        Method extendedMethod = class_getClassMethod(self, @selector(bundleForTestTarget));
        //swizzling mainBundle method with our own custom method
        method_exchangeImplementations(originalMethod, extendedMethod);
    });
}

//method for returning app Test target
+(NSBundle *)bundleForTestTarget {
    NSBundle * bundle = [NSBundle bundleWithIdentifier:@"philips.PRXClientTests"];
    
    return bundle;
}

@end
