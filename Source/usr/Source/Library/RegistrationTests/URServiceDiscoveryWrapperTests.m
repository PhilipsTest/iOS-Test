//
//  URServiceDiscoveryWrapperTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 26/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URServiceDiscoveryWrapper.h"
#import "Kiwi.h"


SPEC_BEGIN(URServiceDiscoveryWrapperSpec)

describe(@"URServiceDiscoveryWrapper", ^{
    
    context(@"method getHomeCountryWithCompletion:", ^{
        
        __block id mockedServiceDiscovery;
        
        beforeEach(^{
            mockedServiceDiscovery = [KWMock mockForProtocol:@protocol(AIServiceDiscoveryProtocol)];
        });
        
        
        it(@"should return error if ServiceDiscovery fails to return country", ^{
            [[mockedServiceDiscovery should] receive:@selector(getHomeCountry:)];
            KWCaptureSpy *serviceDiscoverySpy = [mockedServiceDiscovery captureArgument:@selector(getHomeCountry:) atIndex:0];
            
            __block NSError *receivedError = nil;
            URServiceDiscoveryWrapper *serviceDiscoveryWrapper = [[URServiceDiscoveryWrapper alloc] initWithServiceDiscovery:mockedServiceDiscovery];
            [serviceDiscoveryWrapper getHomeCountryWithCompletion:^(NSString *countryCode, NSString *locale, NSDictionary *serviceURLs, NSError *error) {
                [[countryCode should] beNil];
                [[locale should] beNil];
                [[serviceURLs should] beNil];
                receivedError = error;
            }];
            
            void(^handler)(NSString *countryCode, NSString *sourceType, NSError *error);
            handler = serviceDiscoverySpy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"ServiceDiscovery Domain" code:1002 userInfo:nil]);
            [[expectFutureValue(receivedError) shouldNotEventuallyBeforeTimingOutAfter(1.0)] shouldNotBeNil];
        });
        
        
        it(@"should return error if ServiceDiscovery fails to return URLs for the country", ^{
            [[mockedServiceDiscovery should] receive:@selector(getHomeCountry:)];
            KWCaptureSpy *getCountrySpy = [mockedServiceDiscovery captureArgument:@selector(getHomeCountry:) atIndex:0];
            [[mockedServiceDiscovery should] receive:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:)];
            KWCaptureSpy *getServicesSpy = [mockedServiceDiscovery captureArgument:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:) atIndex:1];
            
            __block NSError *receivedError = nil;
            URServiceDiscoveryWrapper *serviceDiscoveryWrapper = [[URServiceDiscoveryWrapper alloc] initWithServiceDiscovery:mockedServiceDiscovery];
            [serviceDiscoveryWrapper getHomeCountryWithCompletion:^(NSString *countryCode, NSString *locale, NSDictionary *serviceURLs, NSError *error) {
                [[countryCode should] beNil];
                [[locale should] beNil];
                [[serviceURLs should] beNil];
                receivedError = error;
            }];
            void(^getCountryHandler)(NSString *countryCode, NSString *sourceType, NSError *error);
            getCountryHandler = getCountrySpy.argument;
            getCountryHandler(@"IN", @"WiFi", nil);
            void(^getServicesHandler)(NSDictionary<NSString *,AISDService *> *services, NSError *error);
            getServicesHandler = getServicesSpy.argument;
            getServicesHandler(nil, [NSError errorWithDomain:@"ServiceDiscovery Domain" code:1003 userInfo:nil]);
            [[expectFutureValue(receivedError) shouldNotEventuallyBeforeTimingOutAfter(1.0)] beNil];
        });
        
        
        it(@"should return countryCode, URLs and locale if ServiceDiscovery returns correct results", ^{
            [[mockedServiceDiscovery should] receive:@selector(getHomeCountry:)];
            KWCaptureSpy *getCountrySpy = [mockedServiceDiscovery captureArgument:@selector(getHomeCountry:) atIndex:0];
            [[mockedServiceDiscovery should] receive:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:)];
            KWCaptureSpy *getServicesSpy = [mockedServiceDiscovery captureArgument:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:) atIndex:1];

            __block NSString *receivedCountryCode = nil;
            URServiceDiscoveryWrapper *serviceDicveryWrapper = [[URServiceDiscoveryWrapper alloc] initWithServiceDiscovery:mockedServiceDiscovery];
            [serviceDicveryWrapper getHomeCountryWithCompletion:^(NSString *countryCode, NSString *locale, NSDictionary *serviceURLs, NSError *error) {
                [[locale shouldNot] beNil];
                [[serviceURLs shouldNot] beNil];
                [[error should] beNil];
                receivedCountryCode = countryCode;
            }];
            void(^getCountryHandler)(NSString *countryCode, NSString *sourceType, NSError *error);
            getCountryHandler = getCountrySpy.argument;
            getCountryHandler(@"IN", @"WiFi", nil);
            
            AISDService *sdService = [[AISDService alloc] initWithUrl:@"some.dummy.url" andLocale:@"en_IN"];
            NSDictionary *servicesDictionary = @{@"userreg.janrain.api.v2": sdService};
            void(^getServicesHandler)(NSDictionary<NSString *,AISDService *> *services, NSError *error);
            getServicesHandler = getServicesSpy.argument;
            getServicesHandler(servicesDictionary, nil);
            
            [[expectFutureValue(receivedCountryCode) shouldNotEventuallyBeforeTimingOutAfter(3.0)] beNil];
        });
        
        it(@"should set fallback country to SD and use it if SD returns unsupported country", ^{
            [[mockedServiceDiscovery should] receive:@selector(getHomeCountry:)];
            [mockedServiceDiscovery stub:@selector(getHomeCountry:) withBlock:^id(NSArray *params) {
                void(^handler)(NSString *countryCode, NSString *sourceType, NSError *error);
                handler = params[0];
                handler(@"XL", @"WiFi", nil);
                return nil;
            }];
            
            [[mockedServiceDiscovery should] receive:@selector(setHomeCountry:)];
            [mockedServiceDiscovery stub:@selector(setHomeCountry:) withBlock:^id(NSArray *params) {
                NSString *fallbackCountry = params[0];
                [[fallbackCountry should] equal:@"US"];
                return nil;
            }];
            
            [[mockedServiceDiscovery should] receive:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:)];
            [mockedServiceDiscovery stub:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:) withBlock:^id(NSArray *params) {
                void(^getServicesHandler)(NSDictionary<NSString *,AISDService *> *services, NSError *error);
                getServicesHandler = params[1];
                AISDService *sdService = [[AISDService alloc] initWithUrl:@"some.dummy.url" andLocale:@"en_IN"];
                NSDictionary *servicesDictionary = @{@"userreg.janrain.api.v2": sdService};
                getServicesHandler(servicesDictionary, nil);
                return nil;
            }];
            //This is taken out as of now due to new requirement.
//            [[mockedServiceDiscovery should] receive:@selector(getServicesWithLanguagePreference:withCompletionHandler:replacement:)];
            [mockedServiceDiscovery stub:@selector(getServicesWithLanguagePreference:withCompletionHandler:replacement:) withBlock:^id(NSArray *params) {
                void(^getLocaleHandler)(NSDictionary<NSString *,AISDService *> *services, NSError *error);
                AISDService *service = [[AISDService alloc] initWithUrl:@"some.dummy.url" andLocale:@"en_US"];
                NSDictionary *serviceDictionary = @{@"userreg.janrain.api.v2": service};
                getLocaleHandler = params[1];
                getLocaleHandler(serviceDictionary, nil);
                return nil;
            }];
            
            URServiceDiscoveryWrapper *serviceDicveryWrapper = [[URServiceDiscoveryWrapper alloc] initWithServiceDiscovery:mockedServiceDiscovery];
            [serviceDicveryWrapper getHomeCountryWithCompletion:^(NSString *countryCode, NSString *locale, NSDictionary *serviceURLs, NSError *error) {
                [[locale shouldNot] beNil];
                [[locale should] equal:@"en-IN"];
                [[serviceURLs shouldNot] beNil];
                [[error should] beNil];
            }];
        });
    });
    
    context(@"method setHomeCountry:withCompletion:", ^{
        
        __block id mockedServiceDiscovery;
        
        beforeEach(^{
            mockedServiceDiscovery = [KWMock mockForProtocol:@protocol(AIServiceDiscoveryProtocol)];
        });
        
        
        it(@"should return error if ServiceDiscovery fails to return URLs for selected country", ^{
            [[mockedServiceDiscovery should] receive:@selector(setHomeCountry:)];
            [[mockedServiceDiscovery should] receive:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:)];
            KWCaptureSpy *getServicesSpy = [mockedServiceDiscovery captureArgument:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:) atIndex:1];
            
            __block NSError *receivedError = nil;
            URServiceDiscoveryWrapper *serviceDiscoveryWrapper = [[URServiceDiscoveryWrapper alloc] initWithServiceDiscovery:mockedServiceDiscovery];
            [serviceDiscoveryWrapper setHomeCountry:@"IN" withCompletion:^(NSString *locale, NSDictionary *serviceURLs, NSError *error) {
                [[locale should] beNil];
                [[serviceURLs should] beNil];
                receivedError = error;
            }];
            
            void(^getServicesHandler)(NSDictionary<NSString *,AISDService *> *services, NSError *error);
            getServicesHandler = getServicesSpy.argument;
            getServicesHandler(nil, [NSError errorWithDomain:@"ServiceDiscovery Domain" code:1004 userInfo:nil]);
            [[expectFutureValue(receivedError) shouldNotEventuallyBeforeTimingOutAfter(1.0)] beNil];
        });
        
        
        it(@"should return locale and URLs for provided countryCode if ServiceDiscovery returns correct results", ^{
            [[mockedServiceDiscovery should] receive:@selector(setHomeCountry:)];
            [[mockedServiceDiscovery should] receive:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:)];
            //This will be called as per the new requirement.
//            [[mockedServiceDiscovery should] receive:@selector(getServicesWithLanguagePreference:withCompletionHandler:replacement:)];
            [mockedServiceDiscovery stub:@selector(getServicesWithLanguagePreference:withCompletionHandler:replacement:) withBlock:^id(NSArray *params) {
                void(^getLocaleHandler)(NSDictionary<NSString *,AISDService *> *services, NSError *error);
                AISDService *service = [[AISDService alloc] initWithUrl:@"some.dummy.url" andLocale:@"en_IN"];
                NSDictionary *serviceDictionary = @{@"userreg.janrain.api.v2": service};
                getLocaleHandler = params[1];
                getLocaleHandler(serviceDictionary, nil);
                return nil;
            }];
            KWCaptureSpy *getServicesSpy = [mockedServiceDiscovery captureArgument:@selector(getServicesWithCountryPreference:withCompletionHandler:replacement:) atIndex:1];
            
            __block NSString *receivedLocale = nil;
            URServiceDiscoveryWrapper *serviceDiscoveryWrapper = [[URServiceDiscoveryWrapper alloc] initWithServiceDiscovery:mockedServiceDiscovery];
            [serviceDiscoveryWrapper setHomeCountry:@"IN" withCompletion:^(NSString *locale, NSDictionary *serviceURLs, NSError *error) {
                [[error should] beNil];
                [[serviceURLs shouldNot] beNil];
                receivedLocale = locale;
            }];
            
            AISDService *sdService = [[AISDService alloc] initWithUrl:@"some.dummy.url" andLocale:@"en_IN"];
            NSDictionary *servicesDictionary = @{@"userreg.janrain.api.v2": sdService};
            void(^getServicesHandler)(NSDictionary<NSString *,AISDService *> *services, NSError *error);
            getServicesHandler = getServicesSpy.argument;
            getServicesHandler(servicesDictionary, nil);
        });
    });
});


SPEC_END
