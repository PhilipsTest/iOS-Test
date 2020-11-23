/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "DemoErrorTaggingViewController.h"
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"
@import PhilipsUIKitDLS;


@interface DemoErrorTaggingViewController ()
@property (weak, nonatomic) IBOutlet UIDTextField *errorCategoryTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *serverNameTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *errorMessageTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *errorCodeTextField;

@end

@implementation DemoErrorTaggingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)trackTechnicalError:(id)sender {
    if(_errorMessageTextField.text.length > 0) {
        AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:_errorCategoryTextField.text
                                                                      serverName:_serverNameTextField.text
                                                                       errorCode:_errorCodeTextField.text
                                                                    errorMessage:_errorMessageTextField.text];
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackErrorAction:AITaggingTechnicalError taggingError:taggingError];
    }
}

- (IBAction)trackInformationError:(id)sender {
    if(_errorMessageTextField.text.length > 0) {
        AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:_errorCategoryTextField.text
                                                                      serverName:_serverNameTextField.text
                                                                       errorCode:_errorCodeTextField.text
                                                                    errorMessage:_errorMessageTextField.text];
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackErrorAction:AITaggingInformationalError taggingError:taggingError];
    }
}

- (IBAction)trackUserError:(id)sender {
    if(_errorMessageTextField.text.length > 0) {
        AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:_errorCategoryTextField.text
                                                                      serverName:_serverNameTextField.text
                                                                       errorCode:_errorCodeTextField.text
                                                                    errorMessage:_errorMessageTextField.text];
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackErrorAction:AITaggingUserError taggingError:taggingError];
    }
}

@end
