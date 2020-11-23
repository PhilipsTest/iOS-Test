//
//  DCDataHandler.m
//  DigitalCare
//
//  Created by sameer sulaiman on 16/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
#import "DCServiceTaskHandler.h"
#import "DCAppInfraWrapper.h"

@implementation DCServiceTaskHandler

-(id)init{
    self=[super init];
    if(self == nil)
        return nil;
    self.requestUrl = nil;
    return self;
}

- (void)initializeTaskHandler{
    DCParser* parser =[self getParserInstance];
    if (parser){
        parser.parserType=self.parserType;
        [parser clearCachedData];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self downloadData];
    });
}

- (void)downloadData{
    // Instantiate a session configuration object.
    @try
    {
        id<AIRESTClientProtocol> restClient = [[DCAppInfraWrapper sharedInstance].appInfra.RESTClient createInstanceWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        restClient.responseSerializer = [AIRESTClientHTTPResponseSerializer serializer];
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wunused-parameter"
        [restClient GET:self.requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // If no error occurs, check the HTTP status code.
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSData * data = (NSData *)responseObject;
                NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)task.response statusCode];
                // If it's other than 200, then show it on the console.
                if (HTTPStatusCode != 200) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSString *errorMsg = dict?[[dict objectForKey:@"ERROR"] objectForKey:@"errorMessage"]:kERRORRESPONSE;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.exceptionBlock([NSString stringWithFormat:@"%@",errorMsg]);
                    });
                }
                if([data length] >0)
                    [self processParsing:data];
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.exceptionBlock(LOCALIZE(kNODATAKEY));
                    });
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            #pragma clang diagnostic pop
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kERRORRESPONSE];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.exceptionBlock(error);
            });
        }];
    }
    @catch (NSException *exception)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.exceptionBlock(exception);
        });
    }
}

- (void)processParsing:(NSData*)data{
    dcParser = [self getParserInstance];
    dcParser.parserType = self.parserType;
    if (dcParser != nil){
        @try
        {
            id parsedData =  [dcParser parse:data ];
            if (parsedData != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self->_completionBlock != NULL)
                        self.completionBlock(parsedData);
                });
            }
        }
        @catch (NSException *exception)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.exceptionBlock(exception);
            });
        }
    }
}

- (DCParser *)getParserInstance{
    return [[self.parserClass alloc] init];
}
@end
