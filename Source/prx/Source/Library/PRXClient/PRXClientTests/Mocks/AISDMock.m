//
//  AISDMock.m
//  PRXClientTests
//
//  Created by Hashim MH on 03/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "AISDMock.h"



@interface AISDMock()
@end

@implementation AISDMock
- (void)getServiceUrlWithCountryPreference:(NSString *)serviceId withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler replacement:(NSDictionary *)replacement {
    NSString *url = @"";
    if (self.urls[serviceId]){
        url = self.urls[serviceId];
    }
    else{
        url = @"https://www.philips.com/prx/product/B2C/CONSUMER/products/PR3743/00.assets";
    }
    completionHandler(url,nil);
}

- (void)getServiceUrlWithCountryPreference:(NSString *)serviceId withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler  {
    [self getServiceUrlWithCountryPreference:serviceId withCompletionHandler:completionHandler replacement:nil];
}

- (NSString *)applyURLParameters:(NSString *)URLString parameters:(NSDictionary *)map {
    return @"";
}


- (NSString *)getHomeCountry {
    return @"";
}


- (void)getHomeCountry:(void (^)(NSString *, NSString *, NSError *))completionHandler {
}


- (void)getServiceLocaleWithCountryPreference:(NSString *)serviceId withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler {
    
}


- (void)getServiceLocaleWithLanguagePreference:(NSString *)serviceId withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler {
    
}


- (void)getServiceUrlWithLanguagePreference:(NSString *)serviceId withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler {
    
}


- (void)getServiceUrlWithLanguagePreference:(NSString *)serviceId withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler replacement:(NSDictionary *)replacement {
    
}


- (void)getServicesWithCountryPreference:(NSArray *)serviceIds withCompletionHandler:(void (^)(NSDictionary<NSString *,AISDService *> *, NSError *))completionHandler {
    
}


- (void)getServicesWithCountryPreference:(NSArray *)serviceIds withCompletionHandler:(void (^)(NSDictionary<NSString *,AISDService *> *, NSError *))completionHandler replacement:(NSDictionary *)replacement {
    NSString *url = @"";
    if (self.urls[serviceIds[0]]){
        url = self.urls[serviceIds[0]];
    }
    else{
        url = @"https://www.philips.com/prx/product/B2C/CONSUMER/products/PR3743/00.assets";
    }
    AISDService *service = [[AISDService alloc]initWithUrl:url andLocale:@"en_GB"];
    completionHandler(@{serviceIds[0]:service},nil);
}


- (void)getServicesWithLanguagePreference:(NSArray *)serviceIds withCompletionHandler:(void (^)(NSDictionary<NSString *,AISDService *> *, NSError *))completionHandler {
    
}


- (void)getServicesWithLanguagePreference:(NSArray *)serviceIds withCompletionHandler:(void (^)(NSDictionary<NSString *,AISDService *> *, NSError *))completionHandler replacement:(NSDictionary *)replacement {
    
}


- (void)refresh:(void (^)(NSError *))completionHandler {
    
}


- (void)setHomeCountry:(NSString *)countryCode {
    
}


@end




