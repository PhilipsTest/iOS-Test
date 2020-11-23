//
//  TestAppViewController.m
//  Registration
//
//  Created by Abhinav Jha on 4/1/15.
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "TestAppViewController.h"
#import <PhilipsRegistration/PhilipsRegistration.h>
#import <PhilipsUIKit/PhilipsUIKit.h>
#import <AppInfra/AppInfra.h>
#import <UAPPFramework/UAPPFramework.h>

@interface TestAppViewController ()<DIRegistrationConfigurationDelegate>
@property (strong, nonatomic) URDependencies *urDependencies;
@property (strong, nonatomic) URInterface *urInterface;
@end

@implementation TestAppViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[PUIThemeManager sharedInstance] setDefaultTheme:[PUITheme blueDark] applyNavigationBarStyling:YES];
    
    self.urDependencies = [[URDependencies alloc] init];
    self.urDependencies.appInfra = [[AIAppInfra alloc]initWithBuilder:nil];
    [self.urDependencies.appInfra.tagging trackPageWithInfo:@"demoapp:home" paramKey:nil andParamValue:nil];
    
    self.urInterface = [[URInterface alloc]initWithDependencies:self.urDependencies andSettings:nil];


}

- (IBAction)initiateRegistration:(id)sender
{

    
    URLaunchInput *launchInput = [self configurRegistrationInitialisation];
    launchInput.registrationFlowConfiguration.endPointScreen = URFlowEndPointSignedIn;
    
    UIViewController *viewController = [self.urInterface instantiateViewController:launchInput withErrorHandler:^(NSError * _Nullable error) {
        DIUser *user = [DIUser getInstance];
        if (user.email) {
            NSLog(@"name :%@ email:%@ isOptinForMarketing mails : %d",user.givenName,user.email,user.isOlderThanAgeLimit);
        }
        
    }];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

- (URLaunchInput*)configurRegistrationInitialisation
{
    URLaunchInput *launchInput = [[URLaunchInput alloc] init];
    launchInput.delegate = self;
    return launchInput;
}


-(void)launchTermsAndConditions{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DEMO" message:@"show terms and conditions" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

-(void)launchPrivacyPolicy{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DEMO" message:@"show PrivacyPolicy" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
