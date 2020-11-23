//
//  DemoHomeViewController.m
//  DemoAppFramework
//
//  Created by Senthil on 07/04/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoHomeViewController.h"
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"
@import PhilipsUIKitDLS;

@interface DemoHomeViewController ()
@property (weak, nonatomic) IBOutlet UIDLabel *lblVersion;


@end

@implementation DemoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set the title
//    [self setupCloseButton];
    self.title = @"Home";
    
    #if !(TARGET_OS_SIMULATOR)
    
    NSString * status = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider getDeviceCapability];
    if ([status isEqualToString:@"false"]) {
                [self setUpDemo];
    }
    else {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"App is in insecure state. Do you want to continue?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
//                                                                 [AppDelegate sharedAppDelegate].window.rootViewController = nil;
                                                                 
                                                             }];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                             [self setUpDemo];
                                                         }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
    #else
    [self setUpDemo];
    #endif
}

-(void)setUpDemo {
    self.lblVersion.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra getVersion];
    
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.logging log:AILogLevelInfo eventId:@"" message:[NSString stringWithFormat:@"Component Version: %@",[[AilShareduAppDependency sharedDependency].uAppDependency.appInfra getVersion]]];
    
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.logging log:AILogLevelInfo eventId:@"" message:[NSString stringWithFormat:@"Component ID: %@",[[AilShareduAppDependency sharedDependency].uAppDependency.appInfra getComponentId]]];
    
    // get home country
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        NSLog(@"sourceType:countryCode%@:%@",sourceType,countryCode);
    }];
    
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        NSLog(@"sourceType:countryCode%@:%@",sourceType,countryCode);
    }];
    
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        NSLog(@"sourceType:countryCode%@:%@",sourceType,countryCode);
    }];
    
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        NSLog(@"sourceType:countryCode%@:%@",sourceType,countryCode);
    }];
}

//-(IBAction)switchToCSV:(UISwitch*)sender{
//    sender.on = [[AppDelegate sharedAppDelegate] switchToCSV];
//    
//
//}

-(void)setupCloseButton{
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(closeClicked)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

-(void)closeClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
