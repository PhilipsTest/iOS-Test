//
//  ViewController.h
//  DigitalCareLibraryDemo
//
//  Created by KRISHNA KUMAR on 25/05/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppInfra/AppInfra.h>

@interface DCDemoViewController : UIViewController
@property (nonatomic, strong)AIAppInfra * appInfra;
- (IBAction)InvokeLibrary:(id)sender;


@end

