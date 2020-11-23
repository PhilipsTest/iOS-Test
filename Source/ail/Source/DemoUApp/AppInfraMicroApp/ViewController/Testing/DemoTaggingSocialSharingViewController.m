//
//  DemoTaggingSocialSharingViewController.m
//  DemoAppInfra
//
//  Created by Murali on 9/17/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoTaggingSocialSharingViewController.h"
#import <AppInfra/AppInfra.h>
#import <MessageUI/MessageUI.h>
#import "AilShareduAppDependency.h"


@interface DemoTaggingSocialSharingViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation DemoTaggingSocialSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"App Tagging Social Sharing"];
}

-(IBAction)ShareItemThroughFacebook:(id)sender
{
    [self socialSharing:AIATSocialMediaFacebook WithItem:@"#PhilipsFacebook"];
    [self showAlertWithMessage:@"Tagging done for facebook" title:@"Done"];
}


-(IBAction)ShareItemThroughTwitter:(id)sender
{
    [self socialSharing:AIATSocialMediaTwitter WithItem:@"#PhilipsTwitter"];
    [self showAlertWithMessage:@"Tagging done for twitter" title:@"Done"];
}


-(IBAction)ShareItemThrougMail:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"Test Subject!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"test@test.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    if (mc){
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else{
             [self showAlertWithMessage:@"You are not logged in to your Mail account." title:@"Error"];
    }
}


-(IBAction)ShareItemThroughAirDrop:(id)sender
{
    [self socialSharing:AIATSocialMediaAirDrop WithItem:@"#PhilipsAirdop"];
}

-(void)socialSharing:(AIATSocialMedia)socialMedia WithItem:(NSString*)sharedItem
{
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackSocialSharing:socialMedia withItem:sharedItem];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            [self socialSharing:AIATSocialMediaMail WithItem:@"#PhilipsMail"];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
