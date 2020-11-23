//
//  DemoServiceDiscoveryViewController.m
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 6/2/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoServiceDiscoveryViewController.h"
#import "AilShareduAppDependency.h"

#import <AppInfra/AppInfra.h>

@interface DemoServiceDiscoveryViewController()
{
    UIActivityIndicatorView * activityIndicator;
}

@end

@implementation DemoServiceDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Service Discovery";
    self.tfServiceID.delegate = self;
    // Do any additional setup after loading the view.
    [self createActivityIndicator];
    [self logInternetReachability];
}

-(void)startActivityIndicator
{
    activityIndicator.hidden = false;
    [activityIndicator startAnimating];
    self.view.alpha = .5;
}
-(void)stopActivityIndicator
{
    activityIndicator.hidden = true;
    [activityIndicator stopAnimating];
    self.view.alpha = 1;
}
-(void)createActivityIndicator
{
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.hidden = true;
    activityIndicator.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 20, 20);
    [self.view addSubview:activityIndicator];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) getCountryCodeButtonPressed:(UIButton *)sender {
        [self startActivityIndicator];
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription title:@"Error"];
        }else {
            NSString *strMessage = [NSString stringWithFormat:@"Country Code:%@, Source Type: %@",countryCode,sourceType];
            [self showAlertWithMessage:strMessage title:@"Country Code"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopActivityIndicator];
        });
        
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [textField resignFirstResponder];
    });
    
    
    return true;
}
-(IBAction) setCountryCodeButtonPressed:(UIButton *)sender {
    
    NSLocale *countryLocale = [NSLocale currentLocale];
    NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.serviceDiscovery setHomeCountry:countryCode];
    [self showAlertWithMessage:countryCode title:@"Set Country Code"];
}

-(void)logInternetReachability
{
    AIRESTClientReachabilityStatus reachability = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient getNetworkReachabilityStatus];
    switch (reachability) {
       
        case AIRESTClientReachabilityStatusNotReachable:
            NSLog(@"AIRESTClientReachabilityStatusNotReachable");
            break;
        case AIRESTClientReachabilityStatusReachableViaWWAN:
            NSLog(@"AIRESTClientReachabilityStatusReachableViaWWAN");
            break;
        case AIRESTClientReachabilityStatusReachableViaWiFi:
            NSLog(@"AIRESTClientReachabilityStatusReachableViaWiFi");
            break;
            
        default:
            break;
    }
}

// method to display alert with message
-(void)showAlertWithMessage:(NSString *)strMessage title:(NSString *)strTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}


@end
