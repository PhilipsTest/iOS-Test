//
//  ObjectiveCTestViewController.m
//  AppInfraMicroApp
//
//  Created by philips on 5/19/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "ObjectiveCTestViewController.h"
#import <AppInfra/AppInfra-Swift.h>
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"

@interface ObjectiveCTestViewController ()

@property (strong, nonatomic) AIAppUpdate *appUpdate;

@end

@implementation ObjectiveCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appUpdate = [AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appUpdate;
    (void)[self executeAppUpdate];
}

-(void)executeAppUpdate {
    BOOL isDeprecated = [self.appUpdate isDeprecated];
    BOOL isToBeDeprecated =[self.appUpdate isToBeDeprecated];
    BOOL isUpdateAvailable =[self.appUpdate isUpdateAvailable];
    NSString* getDeprecateMessage =[self.appUpdate getDeprecateMessage];
    NSString* getToBeDeprecatedMessage =[self.appUpdate getToBeDeprecatedMessage];
    NSDate* getToBeDeprecatedDate =[self.appUpdate getToBeDeprecatedDate];
    NSString* getUpdateMessage =[self.appUpdate getUpdateMessage];
    NSString* getMinimumVersion = [self.appUpdate getMinimumVersion];
    NSString* getMinimumOsVersion = [self.appUpdate getMinimumOsVersion];
    [self.appUpdate refresh:nil];
    NSLog(@"isDeprecated : %d\n",isDeprecated);
    NSLog(@"isToBeDeprecated : %d\n",isToBeDeprecated);
    NSLog(@"isUpdateAvailable : %d\n",isUpdateAvailable);
    NSLog(@"getDeprecateMessage : %@\n",getDeprecateMessage);
    NSLog(@"getToBeDeprecatedMessage : %@\n",getToBeDeprecatedMessage);
    NSLog(@"getToBeDeprecatedDate : %@\n",getToBeDeprecatedDate);
    NSLog(@"getMinimumVersion : %@\n",getMinimumVersion);
    NSLog(@"getUpdateMessage : %@\n",getMinimumOsVersion);
    NSLog(@"getUpdateMessage : %@\n",getUpdateMessage);
}

@end
