//
//  DemoABTestViewController.m
//  DemoAppInfra
//
//  Created by Hashim MH on 07/10/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoABTestViewController.h"
#import <AppInfra/AppInfra.h>
#import "ADBMobile.h"
#import "AilShareduAppDependency.h"
@import PhilipsUIKitDLS;

@interface DemoABTestViewController ()<UITextFieldDelegate, UIDRadioGroupDataSource, UIDRadioGroupDelegate>

@property (weak, nonatomic) IBOutlet UIDTextField *keyTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *defaultValue;
@property (weak, nonatomic) IBOutlet UIDLabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIDLabel *cacheStatus;
@property (weak, nonatomic) IBOutlet UIDRadioGroup *typeRadioGroup;

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@end

@implementation DemoABTestViewController
NSArray *dataRadioGroup;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataRadioGroup = @[@"AppRestart",@"AppUpdate"];
    self.typeRadioGroup.selectedIndex = 0;
    self.typeRadioGroup.delegate = self;
    self.typeRadioGroup.dataSource = self ;
    self.typeRadioGroup.refreshRadioGroup ;
}

-(NSInteger)numberOfRadioButtonsFor:(UIDRadioGroup *)radioGroup {
    return dataRadioGroup.count;
}

-(NSString *)radioGroup:(UIDRadioGroup *)radioGroup titleAtIndex:(NSInteger)titleAtIndex {
    return dataRadioGroup[titleAtIndex];
}

- (IBAction)updateCachePressed:(UIButton *)sender {
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.abtest updateCacheWithSuccess:^{
        
        [self showAlertWithMessage:@"cache Updated" title:@"Success!"];
        
    } error:^(NSError * _Nullable error) {
        NSString *message=@"Error in updating cache";
        if (error) {
            message = [error localizedDescription];
        }
        [self showAlertWithMessage:message title:@"Error!"];
    }];
}

- (IBAction)getTestValuePressed:(UIButton *)sender {
    NSString *key = self.keyTextField.text;
    self.valueLabel.text=@"";
    NSUInteger type = self.typeRadioGroup.selectedIndex + 1;
    
    if (!key || key.length <1) {
        [self showAlertWithMessage:@"Invalid Test Name" title:@"Error!"];
        return;
    }
    
    NSLog(@"time start");
    NSString* experience =  [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.abtest getTestValue:key
                                                                                                     defaultContent:self.defaultValue.text
                                                                                                         updateType:type];
    self.valueLabel.text = experience;
    
    NSLog(@"time end :%@",experience);
    
}
- (IBAction)getCacheStatus:(UIButton *)sender{
    NSUInteger cache = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.abtest getCacheStatus];
    NSArray* cacheStatusMapping = @[ @"NoTestsDefined",
                                     @"NoCachedExperiences",
                                     @"ExperiencesNotUpdated",
                                     @"ExperiencesPartiallyUpdated",
                                     @"ExperiencesUpdated",
                                     ];
    self.cacheStatus.text = cacheStatusMapping[cache];
}


-(void)showAlertWithMessage:(NSString *)message title:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

@end
