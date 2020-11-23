//
//  RestClientParamsViewController.h
//  DemoAppInfra
//
//  Created by leslie on 25/08/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestClientParamsViewController : UIViewController

-(void)setCompletionHandler:(void (^)(NSDictionary *params))completionHandler;

@end
