//
//  DemoTaggingViewController.m
//  DemoAppFramework
//
//  Created by Ravi Kiran HR on 4/26/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoTaggingViewController.h"
#import <AppInfra/AppInfra.h>
//#import "Crittercism/Crittercism.h"
#import "AilShareduAppDependency.h"
@import PhilipsUIKitDLS;


@interface DemoTaggingViewController ()


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentPrivacyStatus;
@property (weak, nonatomic) IBOutlet UIDTextField *tfName;
@property (weak, nonatomic) IBOutlet UIDTextField *tfKey;
@property (weak, nonatomic) IBOutlet UIDTextField *tfValue;
@property (weak, nonatomic) IBOutlet UIDLabel *trackingIdLabel;
@property (weak, nonatomic) IBOutlet UIDLabel *lblDataConsent;


@end

@implementation DemoTaggingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the title
    self.title = @"App Tagging";
    self.tfName.delegate = self;
    self.tfKey.delegate = self;
    self.tfValue.delegate = self;
    
    // set default values
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPrivacyConsentForSensitiveData:YES];
    self.lblDataConsent.text = @"YES";
    
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPreviousPage:@"Registration-testing123"];
    // Tag the page with app tagging
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackPageWithInfo:@"Demo app tagging page" params:nil];
    
    // set the selected consent to the UI
    [self setSelectedIndexOfSegment];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveTaggingData:) name:kAilTaggingNotification object:nil];
}

-(void)receiveTaggingData:(NSNotification *)notification
{
//    NSDictionary *TaggingData = [notification userInfo];
//    [Crittercism leaveBreadcrumb:[TaggingData description]];
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.logging log:AILogLevelInfo eventId:@"" message:[notification userInfo].description];
    
    NSString *strTaggingData = [notification userInfo].description;
    NSLog(@"%lu",(unsigned long)strTaggingData.length);
    
    
}
- (IBAction)MakeACrash:(id)sender {
     // force crash the application
    @throw NSInternalInconsistencyException;
    
}

-(void)setSelectedIndexOfSegment
{
    switch ([[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging getPrivacyConsent]) {
        case AIATPrivacyStatusUnknown:
            self.segmentPrivacyStatus.selectedSegmentIndex=0;
            break;
        case AIATPrivacyStatusOptIn:
            self.segmentPrivacyStatus.selectedSegmentIndex=2;
            break;
        case AIATPrivacyStatusOptOut:
            self.segmentPrivacyStatus.selectedSegmentIndex=1;
            break;
            
        default:
            break;
    }
    
}
// textfield delegate method to return keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// method to check weather multiple keys or values entered or not
-(BOOL)multipleValuesExist:(NSString *)strText
{
    if ([strText rangeOfString:@","].location == NSNotFound)
        return false;
    else
        return true;
}

// method to check weather there are equal number of keys and values entered
-(BOOL)validateForEqualNumberOfKeyValuePair:(NSString *)key withValue:(NSString *)value
{
    if(key.length==0 || value.length==0)
        return false;
    
    else
    {
        if ([key rangeOfString:@","].location != NSNotFound ||
            [value rangeOfString:@","].location != NSNotFound)
        {
            NSArray *arrKeys = [key componentsSeparatedByString:@","];
            NSArray *arrValues = [value componentsSeparatedByString:@","];
            
            if(arrKeys.count == arrValues.count)
                return true;
            else
                return false;
        }
        else
            return true;
    }
}

// Event handler for the button Track action
- (IBAction)btnTrackActionTapped:(id)sender {
    
    if(self.tfName.text.length > 0)
    {
        if((self.tfKey.text.length>0 && self.tfValue.text.length>0) || (self.tfKey.text.length==0 && self.tfValue.text.length==0))
        {
            if(self.tfKey.text.length>0 && self.tfValue.text.length>0)
            {
                if([self validateForEqualNumberOfKeyValuePair:self.tfKey.text withValue:self.tfValue.text])
                {
                    // call trackActionWithInfo:(NSString*)pageName paramKey:(NSString*)key andParamValue:(id)value API when single key value entered
                    if(![self multipleValuesExist:self.tfValue.text])
                    {
                        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackActionWithInfo:self.tfName.text paramKey:self.tfKey.text andParamValue:self.tfValue.text];
                        [self showAlertWithMessage:@"Action tracked successfully"];
                    }
                    // call trackActionWithInfo:(NSString*)pageName params:(NSDictionary*)paramDict API when multiple key values entered
                    else
                    {
                        // prepare the dictionary with the multiple key,values provided
                        NSArray *arrKeys = [self.tfKey.text componentsSeparatedByString:@","];
                        NSArray *arrValues = [self.tfValue.text componentsSeparatedByString:@","];
                        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc]init];
                        for(int intIndex=0;intIndex<arrKeys.count;intIndex++)
                        {
                            [dictParam setObject:arrValues[intIndex] forKey:arrKeys[intIndex]];
                        }
                        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackActionWithInfo:self.tfName.text params:dictParam];
                        // display the alert
                        [self showAlertWithMessage:@"Action tracked successfully"];
                    }
                }
                else
                {
                    // display the alert
                    [self showAlertWithMessage:@"Please enter same numbers of keys and values separated by comma"];
                }
            }
            else
            {
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackActionWithInfo:self.tfName.text params:nil];
                // display the alert
                [self showAlertWithMessage:@"Action tracked successfully"];
            }
        }
        else
        {
            // display the alert
            [self showAlertWithMessage:@"Please enter same numbers of keys and values separated by comma"];
        }
    }
    else
    {
        // show the alert saying Page/action name is required
        
        [self showAlertWithMessage:@"Page/Action name is missing"];
    }
}
// Event handler for the button Track page
- (IBAction)btnTrackPageTapped:(id)sender {
    
    if(self.tfName.text.length > 0)
    {
        if((self.tfKey.text.length>0 && self.tfValue.text.length>0) || (self.tfKey.text.length==0 && self.tfValue.text.length==0))
        {
            if(self.tfKey.text.length>0 && self.tfValue.text.length>0)
            {
                if([self validateForEqualNumberOfKeyValuePair:self.tfKey.text withValue:self.tfValue.text])
                {
                    // call trackPageWithInfo:(NSString*)pageName paramKey:(NSString*)key andParamValue:(id)value API when single key value entered
                    if(![self multipleValuesExist:self.tfValue.text])
                    {
                        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackPageWithInfo:self.tfName.text paramKey:self.tfKey.text andParamValue:self.tfValue.text];
                        [self showAlertWithMessage:@"Page tracked successfully"];
                    }
                    // call trackPageWithInfo:(NSString*)pageName params:(NSDictionary*)paramDict API when multiple key values entered
                    else
                    {
                        // prepare the dictionary with the multiple key,values provided
                        NSArray *arrKeys = [self.tfKey.text componentsSeparatedByString:@","];
                        NSArray *arrValues = [self.tfValue.text componentsSeparatedByString:@","];
                        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc]init];
                        for(int intIndex=0;intIndex<arrKeys.count;intIndex++)
                        {
                            [dictParam setObject:arrValues[intIndex] forKey:arrKeys[intIndex]];
                        }
                        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackPageWithInfo:self.tfName.text params:dictParam];
                        // display the alert
                        [self showAlertWithMessage:@"Page tracked successfully"];
                    }
                }
                else
                {
                    // display the alert
                    [self showAlertWithMessage:@"Please enter same numbers of keys and values separated by comma"];
                }
            }
            else
            {
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackPageWithInfo:self.tfName.text params:nil];
                // display the alert
                [self showAlertWithMessage:@"Page tracked successfully"];
            }
        }
        else
        {
            // display the alert
            [self showAlertWithMessage:@"Please enter same numbers of keys and values separated by comma"];
        }
    }
    else
    {
        // show the alert saying Page/action name is required
        
        [self showAlertWithMessage:@"Page/Action name is missing"];
    }
}

// method to display alert with message
-(void)showAlertWithMessage:(NSString *)strMessage
{
    UIDAlertController *alertView = [UIDAlertController alloc];
    alertView.message = strMessage;
    alertView.title = @"Ok";
    [alertView loadView];
}
// set the privacy
- (IBAction)PrivacyStatus:(UISegmentedControl *)sender {
    NSInteger intSelectedSegment = sender.selectedSegmentIndex;
    
    switch (intSelectedSegment) {
        case 0:
            [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPrivacyConsent:AIATPrivacyStatusUnknown];
            break;
        case 1:
            [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
            break;
        case 2:
            [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
            break;
            
        default:
            break;
    }
    
}

- (IBAction)trackTimedActionStart:(id)sender {
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackTimedActionStart:@"trackTimedAction" data:nil];
}
- (IBAction)trackTimedActionEnd:(id)sender {
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackTimedActionEnd:@"trackTimedAction" logic:^BOOL(NSTimeInterval inAppDuration, NSTimeInterval totalDuration, NSMutableDictionary * _Nullable data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlertWithMessage:[NSString stringWithFormat:@"Action duration: %f seconds",totalDuration]];
        });
        
        return true;
    }];
}

- (IBAction)trackUrlExternal:(id)sender {
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackLinkExternal:@"http://www.appinfra.com"];

}

- (IBAction)trackFileDownload:(id)sender {
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackFileDownload:@"appinfra_demo1_3_0.mp4"];
}
- (IBAction)setSensitiveDataConsent:(UISwitch *)sender {
    
    if(sender.on)
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPrivacyConsentForSensitiveData:YES];
    else
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging setPrivacyConsentForSensitiveData:NO];
}

- (IBAction)GetSensitiveDataConsent:(id)sender {
    
    if([[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging getPrivacyConsentForSensitiveData])
        self.lblDataConsent.text =  @"YES";
    else
        self.lblDataConsent.text =  @"NO";
}
- (IBAction)trackingIdPressed:(id)sender {
    self.trackingIdLabel.text =  [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging getTrackingIdentifier];
}

@end
