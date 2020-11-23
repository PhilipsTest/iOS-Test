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
#import "AppInfraDevTools.h"

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

- (IBAction)valueChanged:(UISwitch *)sender {
    //create app infra instance by injecting the service discovery static implementation as alternative implementation
    if (sender.selected) {
        [AilShareduAppDependency sharedDependency].uAppDependency.appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
        
    }
    else{
        AIDTServiceDiscoveryManagerCSV *SDManagerCSV = [[AIDTServiceDiscoveryManagerCSV alloc]init];
        [AilShareduAppDependency sharedDependency].uAppDependency.appInfra = [AIAppInfra buildAppInfraWithBlock:^(AIAppInfraBuilder *builder) {
            builder.serviceDiscovery = SDManagerCSV;
        }];
   
    }
}


@end
