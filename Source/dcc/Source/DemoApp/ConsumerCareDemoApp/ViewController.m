//
//  ViewController.m
//  ConsumerCareDemoApp
//
//  Created by Niharika Bundela on 3/22/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//

#import "ViewController.h"
#import "ConsumerCareMicroAppDependencies.h"
#import "ConsumerCareMicroAppInterface.h"
#import "ConsumerCareMicroAppLaunchInput.h"
#import <AppInfra/AppInfra.h>

@interface ViewController ()
@property (strong, nonatomic) ConsumerCareMicroAppInterface *dcInterface;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LaunchApplication:(id)sender {
    ConsumerCareMicroAppDependencies *dcDependencies = [[ConsumerCareMicroAppDependencies alloc] init];
    dcDependencies.appInfra = [[AIAppInfra alloc]initWithBuilder:nil];;
    self.dcInterface = [[ConsumerCareMicroAppInterface alloc]initWithDependencies:dcDependencies andSettings:nil];
    ConsumerCareMicroAppLaunchInput *launchInput = [[ConsumerCareMicroAppLaunchInput alloc] init];
    UIViewController *childViewController = [self.dcInterface instantiateViewController:launchInput withErrorHandler:^(NSError *error) {
        NSLog(@"error happened");
    }];
    [self.navigationController pushViewController:childViewController animated:YES];
}

@end
