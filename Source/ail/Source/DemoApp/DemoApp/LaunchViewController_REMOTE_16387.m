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
@property(nonatomic,strong)UIButton* networkStatusButton;
@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aireachabilityChanged:) name:kAILReachabilityChangedNotification object:nil];
    [self addButton];
    
}

-(void)aireachabilityChanged:(NSNotification*)notification{
   
    id<AIRESTClientProtocol> restClient = [notification object];
    [self displayStatus:[restClient getNetworkReachabilityStatus]];
    
}


- (IBAction)launchAppInfraClicked:(id)sender {
    
    
    UAPPLaunchInput *objLaunch = [[UAPPLaunchInput alloc]init];
    UIViewController *objVC = [[AppDelegate sharedAppDelegate].objAppInfraMicroAppInterface instantiateViewController:objLaunch withErrorHandler:nil];
    
    [self presentViewController:objVC animated:YES completion:nil];
    
    //[self.navigationController hidesBottomBarWhenPushed];
    //[self.navigationController pushViewController:objVC animated:YES];
    
}

-(void)addButton{
    _networkStatusButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 30)];
    [_networkStatusButton addTarget:self action:@selector(getStatusPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_networkStatusButton];
    [_networkStatusButton setTitle:@"Notavailable" forState:UIControlStateNormal];
  
    [self getStatusPressed:nil];
}

- (void)displayStatus:(AIRESTClientReachabilityStatus)status {
    NSString *statusMessage = @"not available";
    UIColor *color = [UIColor orangeColor];
    switch (status) {
        case AIRESTClientReachabilityStatusNotReachable:
            statusMessage = @"NotReachable";
            color = [UIColor redColor];
            break;
        case AIRESTClientReachabilityStatusReachableViaWiFi:
            statusMessage = @"ReachableViaWiFi";
            color = [UIColor greenColor];
            break;
        case AIRESTClientReachabilityStatusReachableViaWWAN:
            statusMessage = @"ReachableViaWWAN";
           color = [UIColor greenColor];
            break;
        default:
            break;
    }
    NSString *connected = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient isInternetReachable] ? @"connected":@"not connected" ;
    statusMessage = [NSString stringWithFormat:@"%@ - %@",statusMessage,connected];
               __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.networkStatusButton setTitle:statusMessage forState:UIControlStateNormal];
        [weakSelf.networkStatusButton setTitleColor:color forState:UIControlStateNormal];
    });

}

- (IBAction)getStatusPressed:(id)sender {
    
  AIRESTClientReachabilityStatus status =   [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient getNetworkReachabilityStatus];
    [self displayStatus:status];
    
    
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
