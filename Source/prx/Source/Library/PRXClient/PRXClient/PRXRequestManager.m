//
//  PRXRequestManager.m
//  PRXClient
//
//  Created by sameer sulaiman on 10/22/15.
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXRequestManager.h"
#import "PRXNetworkWrapper.h"
#import "PRXResponseData.h"
#import "PRXRequest.h"

#define kPRXRequestManagerEvent @"PRXRequestManager"
@interface PRXRequestManager(){
    @protected
    PRXNetworkWrapper *networkWrapper;
}

@end

@implementation PRXRequestManager
- (instancetype)initWithDependencies: (PRXDependencies*)prxdependency
{
    if (self = [super init]) {
        _dependencies = prxdependency;
        [self initLogger];
        NSString *message  = [NSString stringWithFormat:@"PRXRequestManager initialized with appinfra : %@",prxdependency.appInfra];
        [self.dependencies.prxLogging log:AILogLevelInfo
                                  eventId:kPRXRequestManagerEvent
                                  message:message];
        networkWrapper = [[PRXNetworkWrapper alloc] initWithDependencies:self.dependencies];
        
    }
    return self;
}

-(void)setDependencies:(PRXDependencies *)dependencies{
    _dependencies = dependencies;
    [self initLogger];
}

-(void)initLogger{
    if (_dependencies) {
        NSString *message = [NSString stringWithFormat:@"PRXClient initialized by %@", _dependencies.parentTLA];
        NSDictionary *infoPlist = [[NSBundle bundleForClass:[PRXNetworkWrapper class]] infoDictionary];
        NSString *appVersion = [infoPlist objectForKey:@"CFBundleShortVersionString"];
        
        NSString *componentName = @"prx";
        if ( _dependencies.parentTLA) {
             componentName = [NSString stringWithFormat:@"%@/prx",self.dependencies.parentTLA];
        }
        self.dependencies.prxLogging = [self.dependencies.appInfra.logging createInstanceForComponent:componentName
                                                                                      componentVersion:appVersion];
        [self.dependencies.prxLogging log:AILogLevelInfo eventId:kPRXRequestManagerEvent message:message];
    }
}

- (void)execute:(PRXRequest*) request completion:(void (^)(PRXResponseData *response))success failure:(void(^)(NSError *error))failure{
    
    if (!self.dependencies.appInfra) {
        
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"You must inject Appinfra to PRX, use  [[PRXRequestManager alloc]initWithDependencies:dependencies]"
                                     userInfo:nil];
    }    
     [networkWrapper sendRequest:request
                         completion:^(id response) {
                             if (response) {
                                 success([request getResponse:response]);
                             }
                             else{
                                 [self.dependencies.prxLogging log:AILogLevelError eventId:kPRXRequestManagerEvent message:@"No content from server"];
                                 NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"No content from server"};
                                 NSError *customError = [[NSError alloc] initWithDomain:@"PRXClient"
                                                                                   code:0
                                                                               userInfo:userInfo];
                                 failure(customError);
                             }

                         } failure:^(NSError *error) {
                             failure(error);
                         }];
}

@end
