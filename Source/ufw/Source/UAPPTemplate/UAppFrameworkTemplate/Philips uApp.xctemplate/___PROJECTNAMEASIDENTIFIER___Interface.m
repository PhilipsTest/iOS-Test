//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___PROJECTNAMEASIDENTIFIER___Interface.h"
#import <UIKit/UIKit.h>

@implementation ___PROJECTNAMEASIDENTIFIER___Interface

- (instancetype)initWithDependencies:(UAPPDependencies * _Nonnull) dependencies andSettings : (UAPPSettings * _Nullable) settings {
    <#Initialise your uApp here#>
}

- (UIViewController * _Nullable)instantiateViewController:(UAPPLaunchInput * _Nonnull) launchInput withErrorHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"___PROJECTNAMEASIDENTIFIER___ViewController"];
   
    return viewController;
}

@end
