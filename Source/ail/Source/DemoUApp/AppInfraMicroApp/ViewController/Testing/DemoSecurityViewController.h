//
//  DemoSecurityViewController.h
//  DemoAppFramework
//
//  Created by Senthil on 07/04/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DemoSecurityViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIDTextField *tfKey;
@property (weak, nonatomic) IBOutlet UIDTextField *tfValue;
@property (weak, nonatomic) IBOutlet UIDTextView *tvEncryptedText;
@property (weak, nonatomic) IBOutlet UIDTextView *tvDecryptedText;
@property (weak, nonatomic) IBOutlet UIDTextField *filePath;
@property (weak, nonatomic) IBOutlet UIDTextField *extension;

@end
