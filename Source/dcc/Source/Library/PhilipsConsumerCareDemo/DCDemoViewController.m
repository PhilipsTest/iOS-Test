//
//  ViewController.m
//  DigitalCareLibraryDemo
//
//  Created by KRISHNA KUMAR on 25/05/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "DCDemoViewController.h"
#import "DCLaunchInput.h"
#import "DCDependencies.h"
#import "DCInterface.h"
#import "DCCountrySelectionViewController.h"
#import "DCContentConfiguration.h"
@import PhilipsUIKitDLS;

@interface DCDemoViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,DCMenuDelegates,CountryDataProtocol>
{
    NSUInteger selectedIndex;
    UITextField *currentTextField;
    UITapGestureRecognizer *outsideTap;
}

- (IBAction)removeCTN:(id)sender;
- (IBAction)addingCTN:(id)sender;
@property(nonatomic,weak) IBOutlet UIDTextField*ctnField;
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSDictionary *productDetails;
@property (strong, nonatomic) DCInterface *dcInterface;
@property (strong, nonatomic) DCDependencies *dcDependencies;
@property (weak, nonatomic) IBOutlet UIDButton *btnLaunchDigitalCare;
@property (weak, nonatomic) IBOutlet UIDButton *btnChangeTheme;
@property (weak, nonatomic) IBOutlet UIDLabel *lblProductInfo;
@property (weak, nonatomic) IBOutlet UIDLabel *lblCTN;
@property (weak, nonatomic) IBOutlet UIDButton *btnAddCtn;
@property (weak, nonatomic) IBOutlet UIDButton *btnRemoveCtn;
@property (weak, nonatomic) IBOutlet UIDButton *btnLaunchCCMultipleCtn;
@property (weak, nonatomic) IBOutlet UIDLabel *lblServiceDiscoveryCountry;
@property (weak, nonatomic) IBOutlet UIDButton *btnCountySelection;
@property(nonatomic,strong) NSString *strCountry;
@property (weak, nonatomic) IBOutlet UIDLabel *lblCountryName;
@property (weak, nonatomic) IBOutlet UIDLabel *lblCountryPreference;
@property (nonatomic, strong) UIView  *progressTransparentView;
@property (nonatomic, weak)IBOutlet UIDProgressIndicator *progressIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(IBAction)onPickerSelect:(id)sender;
- (IBAction)changeTheme:(id)sender;
- (IBAction)CountrySelection:(id)sender;
@end

@implementation DCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Sample Library Integration";
    NSString *configFilePath = [[NSBundle bundleForClass:self.class]pathForResource:@"ProductDetails" ofType:@"plist"];
    if(configFilePath)
    {
        self.productDetails = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
    }
    _dataArray=[[NSMutableArray alloc] initWithArray:[self.productDetails objectForKey:@"CTN"]];
    selectedIndex = 0;
    self.ctnField.text = [_dataArray objectAtIndex:0];
    outsideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViews)];
    outsideTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:outsideTap];
    outsideTap.enabled = YES;
    self.lblCountryPreference.text = @"Country Preference  :\n1.SIM card\n2.geo-IP\n3.User Selection";
    self.dcDependencies = [[DCDependencies alloc] init];
    if(self.appInfra)
        self.dcDependencies.appInfra = self.appInfra;
    else
        self.dcDependencies.appInfra = [[AIAppInfra alloc]initWithBuilder:nil];
    
    self.dcInterface = [[DCInterface alloc]initWithDependencies:self.dcDependencies andSettings:nil];
    [self.dcDependencies.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lblCountryName.text = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
        });
    }];
    
    self.progressTransparentView = [[UIView alloc]init];
    self.progressTransparentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.progressTransparentView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressTransparentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"progressTransparentView":self.progressTransparentView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[progressTransparentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"progressTransparentView":self.progressTransparentView}]];
    self.progressTransparentView.backgroundColor = [UIColor clearColor];
    self.progressTransparentView.hidden = YES;
}

- (void)startProgressIndicator {
    [self.progressIndicatorView startAnimating];
    [self.view bringSubviewToFront:self.progressTransparentView];
    [self.view bringSubviewToFront:self.progressIndicatorView];
    [UIView animateWithDuration:0.5 animations:^{
        self.progressTransparentView.hidden = NO;
    }];
}

- (void)stopProgressIndicator {
    [self.progressIndicatorView stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.progressTransparentView.hidden = YES;
    }];
}


- (void)dismissViews
{
    self.pickerView?[self.pickerView setHidden:YES]:nil;
    [currentTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    //to get the previous page name for analytics
    [super viewWillAppear:YES];
}


-(BOOL)socialMenuItemSelected:(NSString*)item
{
    return NO;
}

-(BOOL)mainMenuItemSelected:(NSString*)item withIndex:(NSInteger)index
{
    // Intergrating app have to propagate their views here
    if([item isEqualToString:@"sign_into_my_philips"] || [item isEqualToString:@"RA_Product_Registration_Text"])
    {
        NSLog(@"Registration Component Call!..");
        return YES;
    }
    return NO;
}

- (IBAction)InvokeLibrary:(id)sender
{
    [self startProgressIndicator];
    [self.dcDependencies.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        self.strCountry = countryCode;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopProgressIndicator];
            self->outsideTap.enabled = NO;
            self.pickerView?[self.pickerView setHidden:YES]:nil;
            [self->currentTextField resignFirstResponder];
            [self invokeConsumerCare];
        });
        
    }];
}

-(IBAction)onPickerSelect:(id)sender
{
    if(!self.pickerView)
    {
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height - (self.view.frame.size.height*0.3)), self.view.frame.size.width, self.view.frame.size.height*0.3)];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        [self.view addSubview:self.pickerView];
    }
    self.pickerView.hidden = NO;
    self.pickerView.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height - (self.view.frame.size.height*0.3)), self.view.frame.size.width, self.view.frame.size.height*0.3);
    [self setPickerArray:_dataArray];
    [self.pickerView reloadAllComponents];
}

- (IBAction)changeTheme:(id)sender {
  
     UINavigationController *themeSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThemeSettingNavigationViewController"];
     [self.navigationController presentViewController:themeSettingViewController animated:YES completion:^{}];
    }

- (IBAction)CountrySelection:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    DCCountrySelectionViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CountrySelection"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    [self selectedDataWithIndex:row];
    return [self.dataArray objectAtIndex:row];
}

#pragma mark -
#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self selectedDataWithIndex:row];
}

-(void)selectedDataWithIndex:(NSUInteger)index
{
    NSString *resultString = self.dataArray[index];
    self.ctnField.text = resultString;
}

-(void)setHomeCountry:(NSString *)strCountryCode
{
  [self.dcDependencies.appInfra.serviceDiscovery setHomeCountry:strCountryCode];
}
- (void)setPickerArray:(NSMutableArray*)array
{
    self.dataArray = array;
}

- (NSArray*)getPickerArray
{
    return self.dataArray;
}

#pragma  mark - Orientation Handlers

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+50);
    if(self.pickerView)
        self.pickerView.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height - (self.view.frame.size.height*0.3f)), self.view.frame.size.width, self.view.frame.size.height*0.3f);
    [self.view layoutSubviews];
}

- (BOOL)isPortraitMode
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

- (IBAction)removeCTN:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Remove CTN" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler: ^(UITextField *textField) {
        textField.placeholder = @"CTN";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleCancel handler: ^(UIAlertAction *action) {
        [self.dataArray removeObject:[alertController textFields].firstObject.text];
        [self.pickerView reloadAllComponents];
    }];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:true completion:nil];
    
}

- (IBAction)addingCTN:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add CTN" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler: ^(UITextField *textField) {
        textField.placeholder = @"CTN";
    }];
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleCancel handler: ^(UIAlertAction *action) {
        [self.dataArray addObject:[alertController textFields].firstObject.text];
        [self.pickerView reloadAllComponents];
    }];
    [alertController addAction:add];
    [self presentViewController:alertController animated:true completion:nil];

}


- (IBAction)launchCCwithMultipleCTN:(id)sender {
    
    [self startProgressIndicator];
    [self.dcDependencies.appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopProgressIndicator];
            self.strCountry = countryCode;
            self->outsideTap.enabled = NO;
            self.pickerView?[self.pickerView setHidden:YES]:nil;
            [self->currentTextField resignFirstResponder];
            
            // Invoking CC with uApp API's for Mutiproduct from sample app
            
            DCLaunchInput *launchInput = [[DCLaunchInput alloc] init];
            launchInput.dCMenuDelegates = self;
            PSHardcodedProductList *hardcodedList = [[PSHardcodedProductList alloc] init];
            hardcodedList.catalog= CARE;
            hardcodedList.sector= B2C;
            [hardcodedList setHardcodedProductListArray:self.dataArray];
            launchInput.productModelSelectionType = hardcodedList;
            [self setupContentConfiguration:self->_strCountry withLaunchInput:launchInput];
            if([self.strCountry isEqualToString:@"CN"])
            {
                launchInput.chatURL = @"https://ph-china.livecom.cn/webapp/index.html?app_openid=ph_6idvd4fj&token=PhilipsTest";
                // Country Specific configurations can be handled via passing the plist path using below api with specific naming
                launchInput.appSpecificConfigFilePath = [[NSBundle bundleForClass:self.class]pathForResource:@"DigitalCareConfiguration_china" ofType:@"plist"];
                
            } else  {
                launchInput.appSpecificConfigFilePath = [[NSBundle bundleForClass: self.class]
                                                         pathForResource: @"DigitalCareConfiguration"
                                                         ofType: @"plist"];
            }
            UIViewController *childViewController = [self.dcInterface instantiateViewController:launchInput withErrorHandler:^(NSError *error) {
                NSLog(@"error happened");
            }];
            
            [self.navigationController pushViewController:childViewController animated:NO];
            
        });
    }];
}

-(void) invokeConsumerCare
{
    // Invoking CC with uApp API's
    
    PSHardcodedProductList *hardcodedList = [[PSHardcodedProductList alloc] init];
    hardcodedList.catalog= CARE;
    hardcodedList.sector= B2C;
    [hardcodedList setHardcodedProductListArray:[NSArray arrayWithObject:[NSString stringWithFormat:@"%@",self.ctnField.text]]];
    
    DCLaunchInput *launchInput = [[DCLaunchInput alloc] init];
    launchInput.dCMenuDelegates = self;
    launchInput.productModelSelectionType = hardcodedList;
    [self setupContentConfiguration:_strCountry withLaunchInput:launchInput];
    if([_strCountry isEqualToString:@"CN"])
    {
        //launchInput.chatURL = @"http://ph-china.livecom.cn/webapp/index.html?app_openid=ph_6idvd4fj&token=PhilipsTest";
        // Country Specific configurations can be handled via passing the plist path using below api with specific naming
        launchInput.appSpecificConfigFilePath = [[NSBundle bundleForClass: self.class]
                                                 pathForResource: @"DigitalCareConfiguration_china"
                                                 ofType: @"plist"];
    } else  {
        launchInput.appSpecificConfigFilePath = [[NSBundle bundleForClass: self.class]
                                                 pathForResource: @"DigitalCareConfiguration"
                                                 ofType: @"plist"];
    }
    
    
    UIViewController *childViewController = [self.dcInterface instantiateViewController:launchInput
                                                                       withErrorHandler:^(NSError *error) {
        NSLog(@"error happened");
    }];
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma  mark - CountryDataProtocol Method
-(void)getCountry:(NSString *)country countryCode:(NSString *)code
{
    if(![code isEqualToString:@"NoCountry"]){
       // self.lblCountry.text = country;
        self.lblCountryName.text = country;
        [self setHomeCountry:code];
    }
}

#pragma mark - Private Methods
-(void)setupContentConfiguration:(NSString *)countryCode withLaunchInput:(DCLaunchInput *)launchInput {
    if ([countryCode isEqualToString:@"NL"]) {
        DCContentConfiguration *contentConfig = [[DCContentConfiguration alloc] init];
        contentConfig.livechatDescText = @"Chat live met onze productspecialisten. Kijk voor onze actuele openingstijden op www.philips.nl/contact.";
        launchInput.contentConfiguration = contentConfig;
    }
}

@end
