//
//  RestClientParamsViewController.m
//  DemoAppInfra
//
//  Created by leslie on 25/08/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "RestClientParamsViewController.h"
@import PhilipsUIKitDLS;

@interface RestClientParamsViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDTextField *txtKey2;
@property (weak, nonatomic) IBOutlet UIDTextField *txtValue2;
@property (weak, nonatomic) IBOutlet UIDTextField *txtKey1;
@property (weak, nonatomic) IBOutlet UIDTextField *txtValue1;


@property(strong, nonatomic)void (^completionBlock)(NSDictionary *params);

@end

@implementation RestClientParamsViewController

-(void)setCompletionHandler:(void (^)(NSDictionary *params))completionHandler {
    self.completionBlock = completionHandler;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtKey1) {
        [self.txtValue1 becomeFirstResponder];
    }
    else if (textField == self.txtValue1) {
        [self.txtKey2 becomeFirstResponder];
    }
    else if (textField == self.txtKey2) {
        [self.txtValue2 becomeFirstResponder];
    }
    else {
        [self.view endEditing:YES];
    }
    return YES;
}

- (IBAction)savedButtonTapped:(id)sender {
    NSMutableDictionary * params = [NSMutableDictionary new];
    if (self.txtKey1.text.length > 0 && self.txtValue1.text.length >1) {
        [params setObject:self.txtValue1.text forKey:self.txtKey1.text];
    }
    if (self.txtKey2.text.length > 0 && self.txtValue2.text.length >1) {
        [params setObject:self.txtValue2.text forKey:self.txtKey2.text];
    }
    self.completionBlock(params);
    [self.navigationController popViewControllerAnimated:YES]; 
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
