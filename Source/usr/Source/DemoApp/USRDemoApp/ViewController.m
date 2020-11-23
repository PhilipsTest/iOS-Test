//
//  ViewController.m
//  DemoApp
//
//  Created by Sai Pasumarthy on 19/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <PhilipsUIKitDLS/PhilipsUIKitDLS-Swift.h>

#import "ViewController.h"
#import "DemoUAppDependencies.h"
#import "DemoUAppInterface.h"
#import "DemoUAppLaunchInput.h"

@import MessageUI;

@interface ViewController () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) DemoUAppDependencies *urDemoDependencies;
@property (strong, nonatomic) DemoUAppInterface *urDemoInterface;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (NSClassFromString(@"URExceptionHandler")) {
        [NSClassFromString(@"URExceptionHandler") performSelector:NSSelectorFromString(@"installExceptionHandlers") withObject:nil afterDelay:0];
    }
    
    self.urDemoDependencies = [[DemoUAppDependencies alloc] init];
    self.urDemoDependencies.appInfra = [[AIAppInfra alloc]initWithBuilder:nil];
    
    self.urDemoInterface = [[DemoUAppInterface alloc]initWithDependencies:self.urDemoDependencies andSettings:nil];

    UIDTheme *theme = [[UIDThemeManager sharedInstance] defaultTheme];
    [[UIDThemeManager sharedInstance] setDefaultThemeWithTheme:theme applyNavigationBarStyling:YES];
}

-(IBAction)launchUserRegistrationDemo:(id)sender {
    
    DemoUAppLaunchInput *launchInput = [[DemoUAppLaunchInput alloc] init];
    UIViewController *viewController = [self.urDemoInterface instantiateViewController:launchInput withErrorHandler:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)crashReport:(UIDButton *)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (NSClassFromString(@"URExceptionHandler")) {
        NSString *exceptionDetails = [NSClassFromString(@"URExceptionHandler") performSelector:NSSelectorFromString(@"lastExceptionDetails")];
        if (exceptionDetails.length > 0) {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                [controller setSubject:@"Exception found in UR"];
                [controller setMessageBody:exceptionDetails isHTML:NO];
                [controller setToRecipients:@[@"adarsh.rai@philips.com", @"rakesh.dontha@philips.com"]];
                [self presentViewController:controller animated:YES completion:nil];
            } else {
                NSString *message = [NSString stringWithFormat:@"Exception found but mail not configured to send it. \n\n %@", exceptionDetails];
                UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"Exception Found" icon:nil message:message];
                UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
                    [alertVC dismissViewControllerAnimated:YES completion:^{}];
                }];
                [alertVC addAction:alertCancelAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        } else {
            UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"No Exception Found" icon:nil message:@"We could not find any logged exception."];
            UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:^{}];
            }];
            [alertVC addAction:alertCancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
#pragma clang diagnostic pop
}

#pragma mark - MFMailComposeViewControllerDelegate -

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
