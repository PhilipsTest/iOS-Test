//
//  DCWebViewModel.h
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 7/19/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCConstants.h"

@interface DCWebViewModel : NSObject

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *navTitle;
@property (nonatomic,strong) NSString *logEvent;
@property (nonatomic,strong) NSString *logMessage;
@property (nonatomic,strong) NSString *logError;
@property (nonatomic,strong) NSString *tagPageKey;
@property (nonatomic,strong) NSString *tagParamValue;

+(DCWebViewModel*)getModelForType:(DCWebViewType)type andUrl:(NSString *)url;

@end
