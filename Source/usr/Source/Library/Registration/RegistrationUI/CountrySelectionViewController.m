//
//  CountrySelectionViewController.m
//  Registration
//
//  Created by Sai Pasumarthy on 06/01/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "CountrySelectionViewController.h"
@import PhilipsIconFontDLS;

@interface CountrySelectionViewController ()

@property (nonatomic, weak) IBOutlet UIView      *tableHeaderView;
@property (nonatomic, weak) IBOutlet UIDLabel    *tableHeaderLabel;
@property (nonatomic, weak) IBOutlet UITableView *countrySelectionTableView;

@property (nonatomic, strong) NSMutableArray      *reorderedContriesArray;
@property (nonatomic, strong) NSIndexPath         *checkedIndexPath;
@property (nonatomic, strong) NSMutableDictionary *countriesDictionary;
@property  (nonatomic,strong) NSString            *selectedCountry;

@end

@implementation CountrySelectionViewController

#pragma mark UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = LOCALIZE(@"USR_DLS_Country_Selection_Nav_Title_Text");
    UIDTheme *theme = [[UIDThemeManager sharedInstance] defaultTheme];
    self.tableHeaderLabel.textColor = [theme contentItemTertiaryText];
    self.tableHeaderView.backgroundColor = [theme contentTertiaryBackground];
    [self loadCountries];
    [self reorderCountriesArray];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationCountrySelection paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationCountrySelection);
}


#pragma mark - Custom Methods

- (void)loadCountries {
    NSMutableArray *countryArray = [[RegistrationUtility getSupportedCountries] mutableCopy];
    if (![[URSettingsWrapper sharedInstance].countryCode isEqualToString:@"TW"] && [countryArray containsObject:@"TW"]) {
        [countryArray replaceObjectAtIndex:[countryArray indexOfObject:@"TW"] withObject:@"TWGC"];
    }
    self.countriesDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *countryCode in countryArray) {
        NSString *countryCodeKey = [NSString stringWithFormat:@"USR_Country_%@", countryCode];
        NSString *localizedCountry = [[URSettingsWrapper sharedInstance].dependencies.appInfra.languagePack localizedStringForKey:countryCodeKey];
        if (localizedCountry.length <= 0 || [localizedCountry isEqualToString:countryCodeKey]) {
            localizedCountry = LOCALIZE(countryCodeKey);
            if (localizedCountry.length <= 0 || [localizedCountry isEqualToString:countryCodeKey]) {
                localizedCountry = [[NSLocale localeWithLocaleIdentifier:[NSBundle mainBundle].preferredLocalizations.firstObject] displayNameForKey:NSLocaleCountryCode value:countryCode];
            }
        }
        self.countriesDictionary[localizedCountry] = countryCode;
    }
    self.selectedCountry = [self.countriesDictionary allKeysForObject:[URSettingsWrapper sharedInstance].countryCode].firstObject;
}


- (void)reorderCountriesArray {
    NSMutableArray *sortedCountries = [NSMutableArray arrayWithArray:[self.countriesDictionary allKeys]];
    [sortedCountries sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.reorderedContriesArray = [[NSMutableArray alloc] initWithArray:sortedCountries];
    NSUInteger index = [sortedCountries indexOfObject:self.selectedCountry];
    [self.reorderedContriesArray removeObjectAtIndex:index];
    [self.reorderedContriesArray insertObject:self.selectedCountry atIndex:0];
}


-(void)updateHomeCountry {
    __weak typeof(self) weakObj = self;
    [self startActivityIndicator];
    NSString *selectedCountryCode = [self.countriesDictionary objectForKey:self.selectedCountry];
    if ([selectedCountryCode isEqualToString:@"TWGC"]) {
        selectedCountryCode = @"TW";
    }
    [self.userRegistrationHandler updateCountry:selectedCountryCode withCompletion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakObj stopActivityIndicator];
            if (error) {
                [weakObj showNotificationBarErrorViewWithTitle:error.localizedDescription];
            } else {
                [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kCountrySelectedKey andParamValue:selectedCountryCode];
                [weakObj.navigationController popViewControllerAnimated:YES];
            }
        });
        
    }];
}


- (UIDLabel *)accessoryViewTickMark {
    UIDLabel *accessoryLabel = [[UIDLabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [accessoryLabel setFont:[UIFont iconFontWithSize:16]];
    accessoryLabel.text = [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeCheckMarkXBold24];
    [accessoryLabel setTextColor:[UIDThemeManager sharedInstance].defaultTheme.contentItemPrimaryText];
    return accessoryLabel;
}

#pragma mark IBActions


- (IBAction)selectTheCountry:(id)sender {
    DIRInfoLog(@"%@.selectTheCountry clicked", kRegistrationCountrySelection);
    NSString *countryCode = [URSettingsWrapper sharedInstance].countryCode;
    NSArray *countries = [self.countriesDictionary allKeysForObject:countryCode];
    if ([countries count] > 0 && [self.selectedCountry isEqualToString:[countries firstObject]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self updateHomeCountry];
    }
}


- (IBAction)cancelTheCountryViewController:(id)sender {
    DIRInfoLog(@"%@.cancelTheCountryViewController clicked", kRegistrationCountrySelection);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [self.reorderedContriesArray objectAtIndex:(NSUInteger)indexPath.row];
    if([[self.reorderedContriesArray objectAtIndex:(NSUInteger)indexPath.row] isEqualToString:self.selectedCountry]) {
        cell.accessoryView = [self accessoryViewTickMark];
        self.checkedIndexPath = indexPath;
    } else {
        cell.accessoryView = nil;
    }
    cell.textLabel.textColor = [UIDThemeManager sharedInstance].defaultTheme.contentItemPrimaryText;
    [cell.textLabel setFont:[UIFont fontWithName:@"CentraleSansBook" size:16]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.reorderedContriesArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.checkedIndexPath) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryView = nil;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIDThemeManager sharedInstance].defaultTheme.listItemDefaultPressedBackground];
    cell.accessoryView = [self accessoryViewTickMark];
    self.checkedIndexPath = indexPath;
    self.selectedCountry = [self.reorderedContriesArray objectAtIndex:(NSUInteger)indexPath.row];
    [self updateHomeCountry];
}
@end
