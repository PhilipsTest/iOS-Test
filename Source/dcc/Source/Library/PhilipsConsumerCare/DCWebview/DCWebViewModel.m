//
//  DCWebViewModel.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 7/19/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DCWebViewModel.h"

@implementation DCWebViewModel

+(DCWebViewModel*)getModelForType:(DCWebViewType)type andUrl:(NSString *)url{
    DCWebViewModel *modelData = [[DCWebViewModel alloc] init];
    modelData.url = url;
    switch (type) {
        case DCEMAIL:
            modelData.navTitle = LOCALIZE(kSENDEMAILKEY);
            modelData.tagParamValue = kEmail;
            modelData.tagPageKey = kContactEmailPage;
            break;
        case DCFACEBOOK:
            modelData.navTitle = LOCALIZE(KContactUs);
            modelData.tagParamValue = kFACEBOOK;
            modelData.tagPageKey = kContactFacebookPage;
            break;
        case DCTWITTER:
            modelData.navTitle = LOCALIZE(KContactUs);
            modelData.tagParamValue = kTWITTER;
            modelData.tagPageKey = kContactTwitterPage;
            break;
        case DCLIVECHAT:
            modelData.navTitle = LOCALIZE(KChatnow);
            modelData.tagParamValue = kCHATANALYTICS;
            modelData.tagPageKey = kContactLiveChatNowPage;
            break;
        case DCPRODUCTINFO:
            modelData.navTitle = LOCALIZE(KViewProductInformation);
            modelData.tagPageKey = kProductManual;
            modelData.tagParamValue = @"Product Info";
            break;
        case DCPRODUCTMANUAL:
            modelData.navTitle = LOCALIZE(KViewProductInformation);
            modelData.tagPageKey = kProductWebsite;
            modelData.tagParamValue = @"Product Manual";
            break;
        case DCPRODUCTREVIEW:
            modelData.navTitle = LOCALIZE(KProductReview);
            modelData.tagPageKey = kReviewPage;
            modelData.tagParamValue = @"Product Review";
            break;
        case DCFAQDETAILS:
            modelData.navTitle = LOCALIZE(kQuestionAndAnswerTitle);
            modelData.tagPageKey = kFAQAnswerPage;
            modelData.tagParamValue = @"FAQ question and answer";
            break;
        default:
            break;
    }
        return modelData;
}
@end
