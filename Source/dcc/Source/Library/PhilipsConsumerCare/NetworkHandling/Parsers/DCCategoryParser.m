//
//  DCCategoryParser.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 16/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//
#import "DCCategoryParser.h"
#import "DCUtilities.h"
#import "DCConstants.h"
#import "DCAppInfraWrapper.h"

@implementation DCCategoryParser

-(id)init{
    self=[super init];
    if(self == nil)
        return nil;
    return self;
}

- (id)parse :(NSData*)resultData{
    @try{
        if(resultData){
            DCCategoryModel *model = [[DCCategoryModel alloc] init];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:nil];
            [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"The response to find category is" Message:[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding]];
            NSNumber * isSuccessNumber = (NSNumber *)[dict objectForKey:@"success"];
            model.success = [isSuccessNumber boolValue];
            if ((([isSuccessNumber boolValue] == true)   &&  [[dict objectForKey:@"data"] count]>0)){
                if([[dict objectForKey:@"data"] objectForKey:@"parentCode"])
                    model.productCategory = [[dict objectForKey:@"data"] objectForKey:@"parentCode"];
            }
            else if([dict objectForKey:@"ERROR"]){
                model.exceptionMessage = [[dict objectForKey:@"ERROR"] objectForKey:@"errorMessage"];
                [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kERRORRESPONSE];
            }
            return model;
        }
    }
    @catch (NSException *exception){
        [NSException raise:exception.name format:@"%@",exception.reason];
        return nil;
    }
}

@end
