//
//  DemoSecurityViewController.m
//  DemoAppFramework
//
//  Created by Senthil on 07/04/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoSecurityViewController.h"
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"

@interface DemoSecurityViewController (){
    NSData *encryptedData;
    UIActivityIndicatorView * activityIndicator;

}

@end

@implementation DemoSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the title
    self.title = @"Secure Storage";
    // initialize the text fields to empty string
    self.tfValue.text =
    self.tfKey.text =
    self.tvDecryptedText.text =
    self.tvEncryptedText.text = @"";
    
    // set delegates for the textfields to self
    self.tfKey.delegate = self;
    self.tfValue.delegate = self;
    [self createActivityIndicator];
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
-(void)dismissKeyPad
{
    // dismiss the keyboard
    [self.tfKey resignFirstResponder];
    [self.tfValue resignFirstResponder];
}

// Store button event handler
- (IBAction)btnStoreOnClick:(id)sender {
    // dismiss the keyboard
    [self dismissKeyPad];
//    NSError *error;
    if(self.tfKey.text.length!= 0 && [self.tfKey.text stringByReplacingOccurrencesOfString:@" " withString:@""].length !=0)
    {
        if(self.tfValue.text.length!=0)
        {
            // call secure storage API to encrypt and store data

            [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider storeValueForKey:self.tfKey.text value: self.tfValue.text error:nil];

            
            NSData *dataRaw = [[NSUserDefaults standardUserDefaults]objectForKey:self.tfKey.text];
            NSString *strEncryptedData = [[NSString alloc]initWithData:dataRaw encoding:NSASCIIStringEncoding];
            
            // display the encrypted data
            self.tvEncryptedText.text = strEncryptedData;
            
            // alert to show the empty value
            [self showAlertWithMessage:@"Data has been stored"];
        }
        else
        {
            // alert to show the empty value
            [self showAlertWithMessage:@"Enter some value to be stored"];
        }
    }
    else
    {
        // alert to show the empty value
        [self showAlertWithMessage:@"Key cannot be empty"];
    }
}

-(void)showAlertWithMessage:(NSString *)strMessage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });

    
}

// Fetch button event handler
- (IBAction)btnFetchOnClick:(id)sender {
//    NSError *error;
    // dismiss the keyboard
    [self dismissKeyPad];
    // fetch the data and display in text field
    if(self.tfKey.text.length!= 0 && [self.tfKey.text stringByReplacingOccurrencesOfString:@" " withString:@""].length !=0)
    {

        NSString *strDataFetched = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider fetchValueForKey:self.tfKey.text error:nil];

        if(strDataFetched.length==0)
        {
            self.tfValue.text =
            self.tvDecryptedText.text =
            self.tvEncryptedText.text = @"";
            [self showAlertWithMessage:@"No data found for the key entered"];
        }
        else
        {
            self.tvDecryptedText.text = strDataFetched;
            // alert the result
            [self showAlertWithMessage:[NSString stringWithFormat:@"Data fetched: \n %@",strDataFetched]];
        }
    }
    else
    {
        // alert to show the empty value
        [self showAlertWithMessage:@"Key cannot be empty"];
    }
}

// Delete button event handler
- (IBAction)btnDeleteOnClick:(id)sender {
    // dismiss the keyboard
    [self dismissKeyPad];
    if(self.tfKey.text.length!= 0 && [self.tfKey.text stringByReplacingOccurrencesOfString:@" " withString:@""].length !=0)
    {
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider removeValueForKey:self.tfKey.text];
        self.tfValue.text =
        self.tfKey.text =
        self.tvDecryptedText.text =
        self.tvEncryptedText.text = @"";
        // alert to show the empty value
        [self showAlertWithMessage:@"Data has been deleted"];
    }
    else
    {
        // alert to show the empty value
        [self showAlertWithMessage:@"Key cannot be empty"];
    }
    
}


// encrypt button event handler
- (IBAction)btnEncryptOnClick:(id)sender {
    self.tvDecryptedText.text = @"";
    encryptedData = nil;
    // dismiss the keyboard
    [self dismissKeyPad];
    

    if(self.tfValue.text.length!=0)
    {
        NSData *data = [self.tfValue.text dataUsingEncoding:NSUTF8StringEncoding];
        [self startActivityIndicator];

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            // call secure storage API to encrypt and return data
            NSError *error;
            self->encryptedData = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider loadData:data error:&error];
            NSString *strEncryptedData = [[NSString alloc]initWithData:self->encryptedData encoding:NSASCIIStringEncoding];
            

            NSString * sizeMessage = [NSString stringWithFormat:@"Plain=%lu,Encrypted=%lu",(unsigned long)data.length,(unsigned long)self->encryptedData.length];
            [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.logging log:AILogLevelDebug eventId:@"Encryption Memory" message:sizeMessage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // display the encrypted data
                self.tvEncryptedText.text = strEncryptedData;
                
                // alert to show the empty value
                if (error) {
                    [self showAlertWithMessage:[error localizedDescription]];
                }
                else{
                    [self showAlertWithMessage:@"Data has been encrypted"];
                }
                
                [self stopActivityIndicator];

            });
            
            
        });
        
    }
    else
    {
        NSError *error;
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider loadData:nil error:&error];
        // alert to show the empty value
        if (error) {
            [self showAlertWithMessage:[error localizedDescription]];
        }
        else{
            [self showAlertWithMessage:@"Data has been encrypted"];
        }
    }
}


// encrypt button event handler
- (IBAction)btnDecryptOnClick:(id)sender {
    // dismiss the keyboard
    [self dismissKeyPad];
    if(encryptedData)
    {
        // call secure storage API to encrypt and return data
    
    [self startActivityIndicator];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSError *error;
        NSData  *decryptedData = (NSData *)[[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider parseData:self->encryptedData error:&error];
        NSString *strdecryptedData = [[NSString alloc]initWithData:decryptedData encoding:NSASCIIStringEncoding];
        

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // display the encrypted data
            self.tvDecryptedText.text = strdecryptedData;
            
            // alert to show the empty value
            if (error) {
                [self showAlertWithMessage:[error localizedDescription]];
            }
            else{
                [self showAlertWithMessage:@"Data has been decrypted"];
            }
            
            [self stopActivityIndicator];
            
        });
        
        
    });


        
    }
    else
    {
            [self showAlertWithMessage:@"Please Encrypt The Data first"];
        
    }
}

- (IBAction)passcodeCheckButtonTapped:(id)sender {
    NSString * passcode = @"Passcode OFF";
    BOOL hasPasscode = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider deviceHasPasscode];
    if (hasPasscode) {
        passcode = @"Passcode ON";
    }
    [self showAlertWithMessage:passcode];
}

- (IBAction)storeFile:(id)sender {
    [self dismissKeyPad];

    NSError *error;
    if(self.filePath.text.length == 0 || self.extension.text.length == 0 || self.tfKey.text.length == 0){
        [self showAlertWithMessage:@"Please fill Data, file Path, extension"];
        return;
    }
    [self startActivityIndicator];

    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider storeDataToFile:self.filePath.text type:self.extension.text data:self.tfKey.text error:&error];
    if (error) {
        [self showAlertWithMessage:[error localizedDescription]];
    }else{
        [self showAlertWithMessage:@"Success"];
    }
    [self stopActivityIndicator];
}

- (IBAction)fetchFile:(id)sender {
    [self dismissKeyPad];

    NSError *error;
    if(self.filePath.text.length == 0 || self.extension.text.length == 0){
        [self showAlertWithMessage:@"Please fill file Path, extension"];
        return;
    }
    [self startActivityIndicator];
    NSString *str = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider fetchDataFromFile:self.filePath.text type:self.extension.text error:&error];
    
    if (error) {
        [self showAlertWithMessage:[error localizedDescription]];
    }else{
        [self showAlertWithMessage:str];
    }
    [self stopActivityIndicator];
}

- (IBAction)deleteFile:(id)sender {
    [self dismissKeyPad];

    NSError *error;
    if(self.filePath.text.length == 0 || self.extension.text.length == 0){
        [self showAlertWithMessage:@"Please fill file Path, extension"];
        return;
    }
    [self startActivityIndicator];
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.storageProvider removeFileFromPath:self.filePath.text type:self.extension.text error:&error];
    
    if (error) {
        [self showAlertWithMessage:[error localizedDescription]];
    }else{
        [self showAlertWithMessage:@"Success"];
    }
    [self stopActivityIndicator];
}

-(void)startActivityIndicator
{
    activityIndicator.hidden = false;
    [activityIndicator startAnimating];
    self.view.alpha = .5;
    [self.view bringSubviewToFront:activityIndicator];
}
-(void)stopActivityIndicator
{
    activityIndicator.hidden = true;
    [activityIndicator stopAnimating];
    self.view.alpha = 1;
}
-(void)createActivityIndicator
{
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.hidden = true;
    activityIndicator.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 20, 20);
    [self.view addSubview:activityIndicator];
}
@end
