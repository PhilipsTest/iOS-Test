//
//  DCContactsParser.m
//  DigitalCare
//
//  Created by sameer sulaiman on 18/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "DCContactsParser.h"
#import "DCUtilities.h"
#import "DCConstants.h"
#import "DCAppInfraWrapper.h"

@implementation DCContactsParser


-(id)init
{
    self=[super init];
    if(self == nil)
        return nil;
    return self;
}

- (id)parse :(NSData*)resultData
{
    @try
    {
        if(resultData)
        {
            DCContactsModel *model = [[DCContactsModel alloc] init];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:nil];
            [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"User gets contacts response from URL" Message:[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding]];
            NSDictionary *dataDict = nil;
            NSNumber * isSuccessNumber = (NSNumber *)[dict objectForKey:@"success"];
            model.success = [isSuccessNumber boolValue];
            if ((([isSuccessNumber boolValue] == true)   &&  [[dict objectForKey:@"data"] count]>0))
            {
                if([[dict objectForKey:@"data"] objectForKey:@"phone"]){
                    dataDict = [[[dict objectForKey:@"data"] objectForKey:@"phone"] objectAtIndex:0];
                    model.phoneNumber = [DCUtilities formattedPhoneNumber:[dataDict objectForKey:@"phoneNumber"]];
                    model.openingHoursWeekdays = [DCUtilities objectOrNilForKey:@"openingHoursWeekdays" fromDictionary:dataDict];
                    model.openingHoursSaturday = [DCUtilities objectOrNilForKey:@"openingHoursSaturday" fromDictionary:dataDict];
                    model.openingHoursSunday = [DCUtilities objectOrNilForKey:@"openingHoursSunday" fromDictionary:dataDict];
                    model.optionalData1 = [DCUtilities objectOrNilForKey:@"optionalData1" fromDictionary:dataDict];
                    model.optionalData2 = [DCUtilities objectOrNilForKey:@"optionalData2" fromDictionary:dataDict];
                    model.phoneTariff = [DCUtilities objectOrNilForKey:@"phoneTariff" fromDictionary:dataDict];
                }
                if([[dict objectForKey:@"data"] objectForKey:@"chat"]){
                    dataDict = [[[dict objectForKey:@"data"] objectForKey:@"chat"] objectAtIndex:0];
                    model.chatContent = [dataDict objectForKey:@"content"];
                    model.chatOpeningHoursSaturday = [dataDict objectForKey:@"openingHoursSaturday"];
                    model.chatOpeningHoursWeekdays = [dataDict objectForKey:@"openingHoursWeekdays"];
                }
                if([[dict objectForKey:@"data"] objectForKey:@"email"]){
                    dataDict = [[[dict objectForKey:@"data"] objectForKey:@"email"] objectAtIndex:0];
                    model.emailContentPath = [dataDict objectForKey:@"contentPath"];
                    model.emailLabel = [dataDict objectForKey:@"label"];
                }
            }
            else if([dict objectForKey:@"error"])
            {
                model.exceptionMessage = [[dict objectForKey:@"error"] objectForKey:@"errorMessage"];
                [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kERRORRESPONSE];
            }
            return model;
        }
    }
    @catch (NSException *exception)
    {
        [NSException raise:exception.name format:@"%@",exception.reason];
        return nil;
    }
}

@end






