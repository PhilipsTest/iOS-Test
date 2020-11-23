//
//  ServiceDiscoveryMocked.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 28/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "ServiceDiscoveryMocked.h"
#import <objc/runtime.h>
#import <AppInfra/AppInfra.h>
//#import "URSettingsWrapper.h"

@implementation ServiceDiscoveryMocked

+ (void)mockServiceDiscoveryMethod {
    Method originalMethod = class_getInstanceMethod(NSClassFromString(@"AIServiceDiscovery"), NSSelectorFromString(@"getServicesWithCountryPreference:withCompletionHandler:replacement:"));
    Method newMthod = class_getClassMethod([self class], @selector(getURLForServiceId:withCompletion:));
    method_exchangeImplementations(originalMethod, newMthod);
}

+ (void)getURLForServiceId:(NSArray*)serviceIds withCompletion:(void(^)(NSDictionary<NSString *,AISDService *> *services, NSError *error))completionHandler {

    
//    [DIRegistrationServiceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error){
//        NSString *countryC = (countryCode == nil) ? @"US":countryCode;
//        NSString *countryKey = ([countryC caseInsensitiveCompare:@"CN"] == NSOrderedSame) ? countryC : @"OT";
//        [ServiceDiscoveryMocked getURLForCountryCode:countryKey forServiceID:serviceIds andCompletionHandler:completionHandler];
//    }];
    
    
}
+(void)getURLForCountryCode:(NSString*)countryKey forServiceID:(NSArray*)serviceIds andCompletionHandler:(void(^)(NSDictionary<NSString *,AISDService *> *services, NSError *error))completionHandler{
    
//    switch ([DIRegistrationJsonConfiguration getInstance].pILConfiguration.registrationEnvironment) {
//        case kRegistrationEnvironmentDev:
//            completionHandler([ServiceDiscoveryMocked getServicesFromCountryCode:[ServiceDiscoveryMocked developmentSettings][countryKey]], nil);
//            break;
//        case kRegistrationEnvironmentEval:
//            completionHandler([ServiceDiscoveryMocked getServicesFromCountryCode:[ServiceDiscoveryMocked evalSettings][countryKey]], nil);
//            break;
//        case kRegistrationEnvironmentTest:
//            completionHandler([ServiceDiscoveryMocked getServicesFromCountryCode:[ServiceDiscoveryMocked testingSettings][countryKey]], nil);
//            break;
//        case kRegistrationEnvironmentStaging:
//            completionHandler([ServiceDiscoveryMocked getServicesFromCountryCode:[ServiceDiscoveryMocked stagingSettings][countryKey]], nil);
//            break;
//        case kRegistrationEnvironmentProd:
//            completionHandler([ServiceDiscoveryMocked getServicesFromCountryCode:[ServiceDiscoveryMocked productionSettings][countryKey]], nil);
//            break;
//    }
}
+(NSDictionary<NSString *,AISDService *>*)getServicesFromCountryCode:(NSDictionary*)serviceIDs {
    
    NSMutableDictionary<NSString *,AISDService *> *serviceDic = [NSMutableDictionary<NSString *,AISDService *> new];
    
    for (NSString *key in serviceIDs) {
        AISDService *aisdService= [[AISDService alloc] initWithUrl:serviceIDs[key] andLocale:nil];
        [serviceDic setObject:aisdService forKey:key];
    }
    return serviceDic;
}
+ (NSDictionary *)developmentSettings
{
    return @{@"OT":@{@"userreg.janrain.api.v2":@"https://philips.dev.janraincapture.com",
                     @"userreg.landing.resetpass":@"http://10.128.41.111:4503/content/B2C/en_GB/myphilips/reset-password.html?cl=mob",
                     @"userreg.landing.emailverif":@"http://10.128.41.111:4503/content/B2C/en_GB/verify-account.html"},
             @"CN":@{@"userreg.janrain.api.v2":@"https://philips-china-eu.eu-dev.janraincapture.com",
                     @"userreg.landing.emailverif":@"http://10.128.41.111:4503/content/B2C/zh_CN/verify-account.html",
                     @"userreg.landing.resetpass":@"http://10.128.41.111:4503/content/B2C/zh_CN/myphilips/reset-password.html?cl=mob",
                     @"userreg.smssupported":@"http://philips.mobile",
                     @"userreg.urx.verificationsmscode":@"http://10.128.30.23:8080/philips-api/api/v1/user/requestVerificationSmsCode",
                     @"userreg.landing.myphilips":@"https://tst.philips.com.cn/c-w/user-registration/apps/login.html",
                     @"userreg.urx":@"http://10.128.30.23:8080/philips-api"}};
}

+ (NSDictionary *)testingSettings
{
    return @{@"OT":@{@"userreg.janrain.api.v2":@"https://philips-test.dev.janraincapture.com",
                     @"userreg.landing.emailverif":@"https://tst.philips.com/ps/verify-account",
                     @"userreg.landing.resetpass":@"https://tst.philips.com/ps/reset-password?cl=mob"},
             @"CN":@{@"userreg.janrain.api.v2":@"https://philips-china-test.eu-dev.janraincapture.com",
                     @"userreg.landing.emailverif":@"https://tst.philips.com.cn/c-w/user-registration/apps/activate-account.html",
                     @"userreg.landing.resetpass":@"https://tst.philips.com.cn/c-w/user-registration/apps/reset-password.html?",
                     @"userreg.smssupported":@"http://philips.mobile",
                     @"userreg.urx.verificationsmscode":@"https://tst.philips.com/api/v1/user/requestVerificationSmsCode",
                     @"userreg.landing.myphilips":@"https://tst.philips.com.cn/c-w/user-registration/apps/login.html",
                     @"userreg.urx":@"https://tst.philips.com"}};
}

+ (NSDictionary *)evalSettings
{
    return @{@"OT":@{@"userreg.janrain.api.v2":@"https://philips.eval.janraincapture.com",
                     @"userreg.landing.emailverif":@"https://acc.philips.com/ps/verify-account",
                     @"userreg.landing.resetpass":@"https://acc.philips.com/ps/reset-password?cl=mob"},
             @"CN":@{@"userreg.janrain.api.v2":@"https://philips-cn-staging.capture.cn.janrain.com",
                     @"userreg.landing.emailverif":@"https://acc.philips.com.cn/c-w/user-registration/apps/activate-account.html",
                     @"userreg.landing.resetpass":@"https://acc.philips.com.cn/c-w/user-registration/apps/reset-password.html?",
                     @"userreg.janrain.cdn.v2":@"https://janrain-capture-static.cn.janrain.com",
                     @"userreg.janrain.engage.v2":@"https://philips-staging.login.cn.janrain.com",
                     @"userreg.smssupported":@"http://philips.mobile",
                     @"userreg.urx.verificationsmscode":@"https://acc.philips.com.cn/api/v1/user/requestVerificationSmsCode",
                     @"userreg.landing.myphilips":@"https://acc.philips.com.cn/c-w/user-registration/apps/login.html",
                     @"userreg.urx":@"https://acc.philips.com.cn"}};
}

+ (NSDictionary *)stagingSettings
{
    return @{@"OT":@{@"userreg.janrain.api.v2":@"https://philips.eval.janraincapture.com",
                     @"userreg.landing.emailverif":@"https://dev.philips.com/ps/verify-account",
                     @"userreg.landing.resetpass":@"https://dev.philips.com/ps/reset-password?cl=mob"},
             @"CN":@{@"userreg.janrain.api.v2":@"https://philips-cn-staging.capture.cn.janrain.com",
                     @"userreg.landing.emailverif":@"https://dev.philips.com.cn/c-w/user-registration/apps/activate-account.html",
                     @"userreg.landing.resetpass":@"https://dev.philips.com.cn/c-w/user-registration/apps/reset-password.html?",
                     @"userreg.janrain.cdn.v2":@"https://janrain-capture-static.cn.janrain.com",
                     @"userreg.janrain.engage.v2":@"https://philips-staging.login.cn.janrain.com",
                     @"userreg.smssupported":@"http://philips.mobile",
                     @"userreg.urx.verificationsmscode":@"https://acc.philips.com.cn/api/v1/user/requestVerificationSmsCode",
                     @"userreg.landing.myphilips":@"https://dev.philips.com.cn/c-w/user-registration/apps/login.html",
                     @"userreg.urx":@"https://acc.philips.com.cn"}};
}

+ (NSDictionary *)productionSettings
{
    return @{@"OT":@{@"userreg.janrain.api.v2":@"https://philips.janraincapture.com",
                     @"userreg.landing.emailverif":@"https://www.philips.com/ps/verify-account",
                     @"userreg.landing.resetpass":@"https://www.philips.com/ps/reset-password?cl=mob"},
             @"CN":@{@"userreg.janrain.api.v2":@"https://philips-cn.capture.cn.janrain.com",
                     @"userreg.landing.emailverif":@"https://www.philips.com.cn/c-w/user-registration/apps/activate-account.html",
                     @"userreg.landing.resetpass":@"https://www.philips.com.cn/c-w/user-registration/apps/reset-password.html?",
                     @"userreg.janrain.cdn.v2":@"https://janrain-capture-static.cn.janrain.com",
                     @"userreg.janrain.engage.v2":@"https://philips-prod.login.cn.janrain.com",
                     @"userreg.smssupported":@"http://philips.mobile",
                     @"userreg.urx.verificationsmscode":@"https://www.philips.com.cn/api/v1/user/requestVerificationSmsCode",
                     @"userreg.landing.myphilips":@"https://www.philips.com.cn/c-w/user-registration/apps/login.html",
                     @"userreg.urx":@"https://www.philips.com.cn"}};
}

@end
