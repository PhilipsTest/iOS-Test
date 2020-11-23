//
//  DemoMicroAppConfiguration.m
//  DemoAppInfra
//
//  Created by Hashim MH on 02/08/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoMicroAppConfiguration.h"
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"
@import PhilipsUIKitDLS;

@interface DemoMicroAppConfiguration (){
    NSMutableDictionary *configDictionary;
}

@property (weak, nonatomic) IBOutlet UIDTextField *setComponentTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *setKeyTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *setValueTextField;

@property (weak, nonatomic) IBOutlet UIDTextField *getComponentTextField;
@property (weak, nonatomic) IBOutlet UIDTextView *getValueTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *getKeyTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;



@end

@implementation DemoMicroAppConfiguration

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"App Configuration";
}

- (IBAction)setConfiguration:(UIButton *)sender {
    
    NSString *component = self.setComponentTextField.text;
    NSString *key = self.setKeyTextField.text;
    
    id value;
    
    switch (self.typeSegment.selectedSegmentIndex) {
        case 0:
        {
            value = self.setValueTextField.text ;
        }
            break;
        case 1:
        {
            value = [NSNumber numberWithDouble:[self.setValueTextField.text doubleValue]];
        }
            break;
        case 2:
        {
            value = [self.setValueTextField.text componentsSeparatedByString:@","];
            
        }
            break;
        case 3:
        {
            NSArray *stringArray = [self.setValueTextField.text componentsSeparatedByString:@","];
            NSMutableArray *tempIntArray = [[NSMutableArray alloc]initWithCapacity:stringArray.count];
            
            for (NSString* intString in stringArray) {
                [tempIntArray addObject:[NSNumber numberWithInt:[intString intValue]]];
            }
            
            value = tempIntArray;
        }
            break;
        case 4:
        {
            NSData * data = [self.setValueTextField.text dataUsingEncoding:NSUTF8StringEncoding];
            BOOL isDataValid = NO;
            if (data) {
                NSError *error;
                          value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (!error) {
                    isDataValid = YES;
                }
            }
            
            if (!isDataValid) {
                                      [self showAlertWithMessage:@"please give value as valid json string" title:@"Error!"];
            }

            

        }
            break;

            
        default:
            break;
    }
    
    NSError *error;
    
    @try {
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appConfig setPropertyForKey:key group:component value:value error:&error];
    }
    @catch (NSException *exception) {
        [self showAlertWithMessage:exception.reason title:@"Exception"];
    }
    
    if (error) {
        [self showAlertWithMessage:error.localizedDescription title:@"Error!"];
    }
    else{
        [self showAlertWithMessage:@"Value Saved" title:@"Success!"];
    }
    
    
    NSDictionary*configDict = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider fetchValueForKey:@"ail.app_dynamic_config" error:nil];
    NSLog(@"Config Dictionary:\n%@",[configDict description]);
    

    
}
- (IBAction)resetConfig:(id)sender {
     NSError * error;
    BOOL success = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appConfig resetConfig:&error];
    
    if(success)
        [self showAlertWithMessage:@"App config has been reset to static configuration" title:@"Success"];
    else
        [self showAlertWithMessage:error.localizedDescription title:@"Error!"];
}

- (IBAction)getConfiguration:(UIButton *)sender {
  
 
    self.getValueTextField.text = @"";
    NSString *component = self.getComponentTextField.text;
    NSString *key = self.getKeyTextField.text;
    id value = nil;
    NSError * error;
    
    @try {
        value = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appConfig getPropertyForKey:key group:component error:&error];
    }
    @catch (NSException *exception) {
        [self showAlertWithMessage:exception.reason title:@"Exception"];
    }
    
    if (error) {
        [self showAlertWithMessage:error.localizedDescription title:@"Error in getting value"];
    }
    
    NSString *message =@"";
    if ([value isKindOfClass:[NSString class]]) {
        message = [NSString stringWithFormat:@"Type:String\n%@",value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        
                 message = [NSString stringWithFormat:@"Type:Int\n%@",[value stringValue]];
    }
    if ([value isKindOfClass:[NSArray class]]) {
    
        if ([value count] > 0 && [value[0] isKindOfClass:[NSNumber class]]) {
            
            message = [NSString stringWithFormat:@"Type:Int Array\n%@",[value description]];
        }
        else{
            message = [NSString stringWithFormat:@"Type:Array\n%@",[value description]];
        }
        
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        
            message = [NSString stringWithFormat:@"Type:Dictionary\n%@",[value description]];
    }
    
    self.getValueTextField.text = message;
    
    NSDictionary*configDict = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider fetchValueForKey:@"ail.app_dynamic_config" error:nil];
    NSLog(@"Config Dictionary:\n%@",[configDict description]);
}

- (IBAction)getDefaultConfiguration:(UIButton *)sender {
    
    
    self.getValueTextField.text = @"";
    NSString *component = self.getComponentTextField.text;
    NSString *key = self.getKeyTextField.text;
    id value = nil;
    NSError * error;
    
    @try {
        value = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appConfig getDefaultPropertyForKey:key group:component error:&error];
    }
    @catch (NSException *exception) {
        [self showAlertWithMessage:exception.reason title:@"Exception"];
    }
    
    if (error) {
        [self showAlertWithMessage:error.localizedDescription title:@"Error in getting value"];
    }
    
    NSString *message =@"";
    if ([value isKindOfClass:[NSString class]]) {
        message = [NSString stringWithFormat:@"Type:String\n%@",value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        
        message = [NSString stringWithFormat:@"Type:Int\n%@",[value stringValue]];
    }
    if ([value isKindOfClass:[NSArray class]]) {
        
        if ([value count] > 0 && [value[0] isKindOfClass:[NSNumber class]]) {
            
            message = [NSString stringWithFormat:@"Type:Int Array\n%@",[value description]];
        }
        else{
            message = [NSString stringWithFormat:@"Type:Array\n%@",[value description]];
        }
        
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        
        message = [NSString stringWithFormat:@"Type:Dictionary\n%@",[value description]];
    }
    
    self.getValueTextField.text = message;
    
    NSDictionary*configDict = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider fetchValueForKey:@"ail.app_config" error:nil];
    NSLog(@"Config Dictionary:\n%@",[configDict description]);
}

- (IBAction)saveConfig:(UISegmentedControl *)sender {
    

}

- (IBAction)refreshCloudTapped:(id)sender {
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appConfig refreshCloudConfig:^(AIACRefreshResult refreshResult, NSError *error) {
        
        NSString * message;
        switch (refreshResult) {
                case AIACRefreshResultRefreshFailed:
                    message = @"Refresh failed";
                    break;
                
                case AIACRefreshResultNoRefreshRequired:
                    message = @"Refresh not required";
                    break;
                
                case AIACRefreshResultRefreshedFromServer:
                    message = @"Refreshed from server";
                    break;
        }
        
        if (error) {
            message = error.localizedDescription;
        }
        
        [self showAlertWithMessage:message title:@""];
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)deleteConfiguration:(UIButton *)sender {
    NSError *error;
    NSString *component = self.getComponentTextField.text;
    NSString *key = self.getKeyTextField.text;
    

    @try {
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.appConfig setPropertyForKey:key group:component value:nil error:&error];
    }
    @catch (NSException *exception) {
        [self showAlertWithMessage:exception.reason title:@"Exception"];
    }
    
    if (error) {
        [self showAlertWithMessage:error.localizedDescription title:@"Error!"];
    }
    else{
        [self showAlertWithMessage:@"Value Deleted" title:@"Success!"];
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
    [self presentViewController:alert animated:YES completion:nil];}

@end
