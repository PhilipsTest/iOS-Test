//
//  URPhilipsNewsViewController.m
//  Registration
//
//  Created by Sai Pasumarthy on 23/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URPhilipsNewsViewController.h"
#import "URConsentProvider.h"

@interface URPhilipsNewsViewController ()
@property (nonatomic, weak) IBOutlet UITextView *philisNewsTextView;

@end

@implementation URPhilipsNewsViewController

#pragma mark UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LOCALIZE(@"USR_DLS_PhilipsNews_NavigationBar_Title");
    [self.philisNewsTextView setTextColor:[UIDThemeManager sharedInstance].defaultTheme.contentItemPrimaryText];
    [self updateConsent];
    [self updateConsentDescriptionText];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationPhilipsNews paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationPhilipsNews);
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.philisNewsTextView setContentOffset:CGPointMake(0, -24)];
    [self.philisNewsTextView setContentInset:UIEdgeInsetsMake(24, 0, 0, 0)];
}

-(void)updateConsent {
    
    if (self.consent == nil) {
        NSString *locale = [URSettingsWrapper.sharedInstance.dependencies.appInfra.internationalization getUILocaleString];
        self.consent = [URConsentProvider fetchMarketingConsentDefinition: locale];
    }
}

-(void)updateConsentDescriptionText {
    NSString *descriptionString = [NSString stringWithFormat:@"%@\n\n%@   ",LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt"),self.consent.helpText];
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString:descriptionString attributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBook size:16],NSForegroundColorAttributeName:[UIDThemeManager sharedInstance].defaultTheme.contentItemPrimaryText}];
    [attributedDescription setAttributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBold size:20],NSForegroundColorAttributeName:[UIDThemeManager sharedInstance].defaultTheme.contentItemPrimaryText} range:[descriptionString rangeOfString:LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt")]];
    
    [self.philisNewsTextView setAttributedText:attributedDescription];

}
@end
