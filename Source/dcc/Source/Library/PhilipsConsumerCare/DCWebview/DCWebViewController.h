//
//  DCWebViewController.h
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 7/14/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCBaseViewController.h"
#import "DCWebViewModel.h"


@interface DCWebViewController : DCBaseViewController

@property (strong, nonatomic) DCWebViewModel *webViewModel;

+ (instancetype)createWebViewForUrl:(NSString*)url andType:(DCWebViewType)type;

@end
