//
//  ViewController.m
//  AppInfraTest
//
//  Created by Susmit on 3/21/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "LaunchViewController.h"
#import "AppInfraMicroAppInterface.h"
#import "AppDelegate.h"
//#import "AppInfraDevTools.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)launchAppInfraClicked:(id)sender {
    
    
    UAPPLaunchInput *objLaunch = [[UAPPLaunchInput alloc]init];
    UIViewController *objVC = [[AppDelegate sharedAppDelegate].objAppInfraMicroAppInterface instantiateViewController:objLaunch withErrorHandler:nil];
    
    [self presentViewController:objVC animated:YES completion:nil];
    
    //[self.navigationController hidesBottomBarWhenPushed];
    //[self.navigationController pushViewController:objVC animated:YES];
    
}

- (IBAction)valueChanged:(id)sender {
    [AilShareduAppDependency sharedDependency].uAppDependency.appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
}



@end
