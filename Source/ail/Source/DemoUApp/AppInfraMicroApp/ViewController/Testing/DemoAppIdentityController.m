//
//  DemoAppIdentityController.m
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 6/14/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoAppIdentityController.h"
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"

#define kStateTest @"TEST"
#define kStateDevelopment @"DEVELOPMENT"
#define kStateStaging @"STAGING"
#define kStateAccepteance @"ACCEPTANCE"
#define kStateProduction @"PRODUCTION"

@interface DemoAppIdentityController ()

@end

@implementation DemoAppIdentityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"App Identity";
    
    @try {
        // get coresponding State in the string format
        NSString *appState;
        switch ([[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appIdentity getAppState]) {
            case AIAIAppStateTEST:
                appState = kStateTest;
                break;
            case AIAIAppStateDEVELOPMENT:
                appState = kStateDevelopment;
                break;
            case AIAIAppStateSTAGING:
                appState = kStateStaging;
                break;
            case AIAIAppStateACCEPTANCE:
                appState = kStateAccepteance;
                break;
            case AIAIAppStatePRODUCTION:
                appState = kStateProduction;
                break;
            default:
                break;
        }
        // populate UI
        
        self.appName.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appIdentity getAppName];
        self.localizedAppName.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appIdentity getLocalizedAppName];
        self.appVersion.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appIdentity getAppVersion];
        self.appState.text = appState;
        self.micrositeId.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appIdentity getMicrositeId];
        self.sector.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appIdentity getSector];
        self.lblServiceDiscEnv.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appIdentity getServiceDiscoveryEnvironment];
    }
    @catch (NSException *exception) {
        [self showAlertWithMessage:exception.reason title:@"Exception"];
    }
}

// method to display alert with message
-(void)showAlertWithMessage:(NSString *)strMessage title:(NSString *)strTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
