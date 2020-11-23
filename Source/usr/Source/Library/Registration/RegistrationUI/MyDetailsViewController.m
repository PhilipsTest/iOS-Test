//
//  MyDetailsViewController.m
//  Registration
//
//  Created by Sagarika Barman on 2/6/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "MyDetailsViewController.h"
#import "MyDetailsTableViewCell.h"
#import "DIUser.h"
#import "RegistrationUIConstants.h"
#import "URSettingsWrapper.h"
#import "RegistrationAnalyticsConstants.h"


@interface MyDetailsViewController ()

@property (nonatomic, weak) IBOutlet UIDLabel *profileImageLabel;
@property (nonatomic, weak) IBOutlet UITableView *myDetailsTableView;
@property (nonatomic, strong) NSDictionary *cellTitles;
@property (nonatomic, strong) NSDictionary *sectionData;
@property (nonatomic, strong) NSArray* sectionHeaderTitles;
@property (nonatomic, strong) NSMutableArray* loginDetailsTitles;
@property (nonatomic, strong) NSMutableArray* personalDetailsTitles;

@end


@implementation MyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myDetailsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.title = LOCALIZE(@"USR_MyDetails_TitleTxt");
    self.sectionHeaderTitles = @[LOCALIZE(@"USR_Login_Details_Txt"), LOCALIZE(@"USR_Personal_Details_Txt")];
    [self fillUserDetails];
    [self fillProfileImageLabel];
    NSString *headerFooterReuseIdentifier = NSStringFromClass([UIDTableViewHeaderView class]);
    [self.myDetailsTableView registerClass:[UIDTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:headerFooterReuseIdentifier];
    self.myDetailsTableView.backgroundColor = [[[UIDThemeManager sharedInstance] defaultTheme] contentPrimary];
    BOOL showNavBar = [URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.hideNavigationBar;
    [self.navigationController setNavigationBarHidden:showNavBar animated:true];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationUserProfile params:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationUserProfile);
}

#pragma mark - Methods for fetching and formatting user details

- (void)fillUserDetails {
    DIUser *user = [DIUser getInstance];
    NSString *name = [self provideNameString];
    self.loginDetailsTitles = [[NSMutableArray alloc] init];
    self.personalDetailsTitles = [[NSMutableArray alloc] init];
    NSArray *loginDetails = [self fillLoginDetailsArray:user.email phone:user.mobileNumber];
    NSArray *personalDetails = [self fillPersonalDetailsArray:name gender:user.gender dob:user.birthday];
    
    self.cellTitles = @{self.sectionHeaderTitles[0]:self.loginDetailsTitles, self.sectionHeaderTitles[1]:self.personalDetailsTitles};
    self.sectionData = @{self.sectionHeaderTitles[0]:loginDetails, self.sectionHeaderTitles[1]:personalDetails};
}


- (NSString *)provideNameString {//formatStringForName:(NSString *)firstName secondName:(NSString *)lastName {
    DIUser *user = [DIUser getInstance];
    NSString *lastName;
    NSString *firstName;
    
    if (user != nil) {
        lastName =  user.familyName;
        firstName = user.givenName;
    }
    
    if(firstName && lastName == nil) {
        return firstName;
    } else if(lastName && firstName == nil) {
        return lastName;
    } else if(lastName == nil && firstName == nil) {
        return @"";
    } else  {
        return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    }
}


- (NSString *)genderStringForGender:(UserGender)gender {
    if(gender == UserGenderMale) {
        return @"Male";
    } else {
        return @"Female";
    }
}


- (NSString *)dobStringForDOB:(NSDate *)birthday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [dateFormatter stringFromDate:birthday];
}


- (NSString *)provideNameInitialsString {
    DIUser *user = [DIUser getInstance];
    NSString *nameInitials;
    NSString *lastName = @"";
    NSString *firstName = @"";
    if (user != nil) {
        lastName = (user.familyName != nil) ? user.familyName : lastName;
        firstName = (user.givenName != nil) ? user.givenName : firstName;
    }
    if((lastName.length == 0) && firstName.length >= 2) {
        nameInitials = [firstName substringToIndex:2];
    } else if((firstName.length == 0) && lastName.length >= 2) {
        nameInitials = [lastName substringToIndex:2];
    } else if ((lastName.length >= 1) && (firstName.length >= 1)) {
        nameInitials = [NSString stringWithFormat:@"%@%@", [firstName substringToIndex:1], [lastName substringToIndex:1]];
    } else {
        nameInitials = [NSString stringWithFormat:@"%@%@",[firstName substringToIndex:0], [lastName substringToIndex:0]];
    }

    return [nameInitials uppercaseString];
}


- (void)fillProfileImageLabel {
    self.profileImageLabel.backgroundColor = [UIColor colorWithHexString:@"DAA7E4"];
    self.profileImageLabel.layer.cornerRadius = 42.0;
    self.profileImageLabel.layer.masksToBounds = true;
    self.profileImageLabel.text = [self provideNameInitialsString];
    self.profileImageLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Methods for dynamically filling up title arrays & user details arrays

- (NSArray *)fillLoginDetailsArray:(NSString *)email phone:(NSString *)mobile {
    NSMutableArray *loginDetailsArray = [[NSMutableArray alloc] init];
    if(email) {
        [loginDetailsArray addObject:email];
        [self.loginDetailsTitles addObject:LOCALIZE(@"USR_Email_address_TitleTxt")];
    }
    
    if(mobile) {
        [loginDetailsArray addObject:mobile];
        [self.loginDetailsTitles addObject:LOCALIZE(@"USR_Mobile_number_TitleTxt")];
    }
    
    return loginDetailsArray;
}


- (NSArray *)fillPersonalDetailsArray:(NSString *)name gender:(UserGender)gender dob:(NSDate *)dob {
    NSMutableArray *personalDetailsArray = [[NSMutableArray alloc] init];

    [personalDetailsArray addObject:name];
    [self.personalDetailsTitles addObject:LOCALIZE(@"USR_Name_TitleTxt")];
    
    if(gender != UserGenderNone) {
        [personalDetailsArray addObject:[self genderStringForGender:gender]];
        [self.personalDetailsTitles addObject:LOCALIZE(@"USR_Gender_TitleTxt")];
    }
    
    if(dob != nil) {
        [personalDetailsArray addObject:[self dobStringForDOB:dob]];
        [self.personalDetailsTitles addObject:LOCALIZE(@"USR_DateOfBirth_TitleTxt")];
    }
    
    return personalDetailsArray;
}

#pragma mark - Methods to fetch cell titles and contents

- (NSArray *)titleForSection:(NSInteger)section {
    return [self.cellTitles valueForKey: self.sectionHeaderTitles[section]];
}


- (NSArray *)dataForSection:(NSInteger)section {
    return [self.sectionData valueForKey:self.sectionHeaderTitles[section]];
}

#pragma mark - TableView data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionHeaderTitles.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataForSection:section].count;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDetailsCell" forIndexPath:indexPath];
    NSArray *cellTitle = [self titleForSection:indexPath.section];
    NSArray *cellData = [self dataForSection:indexPath.section];
    cell.myDetailsContentLabel.textColor = [UIDThemeManager.sharedInstance.defaultTheme hyperlinkDefaultText];
    cell.myDetailsTitlelabel.accessibilityIdentifier = [NSString stringWithFormat:@"usr_myDetailsScreen_title_label_%ld%ld", (long)indexPath.section, (long)indexPath.row];
    cell.myDetailsContentLabel.accessibilityIdentifier = [NSString stringWithFormat:@"usr_myDetailsScreen_content_label_%ld%ld", (long)indexPath.section, (long)indexPath.row];
    cell.myDetailsTitlelabel.text = cellTitle[indexPath.row];
    cell.myDetailsContentLabel.text = cellData[indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *headerFooterReuseIdentifier = NSStringFromClass([UIDTableViewHeaderView class]);
    UIDTableViewHeaderView *reusableHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier: headerFooterReuseIdentifier];
    reusableHeaderView.accessibilityIdentifier = [NSString stringWithFormat:@"usr_myDetailsScreen_header_title_%ld", (long)section];
    reusableHeaderView.title = self.sectionHeaderTitles[section];
    return reusableHeaderView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(MyDetailsTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        cell.topConstraintForCell.constant = 16.0;
    } else {
        cell.topConstraintForCell.constant = 4.0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.myDetailsTableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
