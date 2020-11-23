//
//  AIAPISigningViewController.m
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 14/11/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "AIAPISigningViewController.h"
#import <AppInfra/AppInfra.h>

@interface AIAPISigningViewController ()

@end

@implementation AIAPISigningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"API Signing";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnGenerateSignature:(id)sender {
    
    id <AIAPISigningProtocol> APISigning = [[AIClonableClient alloc]initApiSigner:@"cafebabe-1234-dead-dead-1234567890ab" andhexKey:@"e124794bab4949cd4affc267d446ddd95c938a7428d75d7901992e0cb4bc320cd94c28dae1e56d83eaf19010ccc8574d6d83fb687cf5d12ff2afddbaf73801b5"];
    
     NSDictionary *headerDict = [NSDictionary dictionaryWithObjectsAndKeys:@"2016-11-09T13:31:13.492+0000",@"SignedDate", nil];
    
    NSString *authorizationHeader = [APISigning createSignature:@"POST" dhpUrl:@"/authentication/login/social" queryString:@"applicationName=uGrow" headers:headerDict requestBody:nil];
    
    [self showAlertWithMessage:authorizationHeader title:@"Signature Generated"];
    
    NSLog(@"Signature Generated:%@",authorizationHeader);
    
    
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
    [self presentViewController:alert animated:YES completion:nil];}

@end
