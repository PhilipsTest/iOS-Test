//
//  DemoGenderDOBViewController.m
//  Registration
//
//  Created by Harsh on 05/10/2016.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "DemoGenderDOBViewController.h"
#import "DIUser.h"
#import "DILogger.h"

#define MAX_AGE     116


@interface DemoGenderDOBViewController ()<UIPickerViewDelegate,UserDetailsDelegate>
@property (nonatomic, assign) IBOutlet UIPickerView *genderPicker;
@property (nonatomic, strong) IBOutlet UIDatePicker *dateOfBirthPicker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *genderActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *genderUpdateStatusLabel;
@property (nonatomic, assign) IBOutlet UILabel *genderLabel,*dateOfBirthLabel;
@property (nonatomic, retain) NSMutableArray *gendersArray;

@end

@implementation DemoGenderDOBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadArrays];
    DIUser *user = [DIUser getInstance];
    
    
    [self updatebirthdayLabel:user.birthday];
    self.dateOfBirthPicker.date = (user.birthday!= nil)?user.birthday:[NSDate date];
    self.dateOfBirthPicker.maximumDate = [NSDate date];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DIUser *user = [DIUser getInstance];
    
    switch (user.gender) {
        case UserGenderMale:
            self.genderLabel.text = @"Male";
            [self.genderPicker selectRow:1 inComponent:0 animated:NO];
            break;
        case UserGenderFemale:
            self.genderLabel.text = @"Female";
            [self.genderPicker selectRow:2 inComponent:0 animated:NO];
            break;
            
        default:
            self.genderLabel.text= @"Select One";
            [self.genderPicker selectRow:0 inComponent:0 animated:NO];
            break;
    }
}

- (void)loadArrays {
    self.gendersArray = [[NSMutableArray alloc] initWithObjects:@"Select One",@"Male",@"Female",nil];
}

-(IBAction)updateProfile:(id)sender{

    [self.genderActivityIndicator startAnimating];
    [self.genderUpdateStatusLabel setHidden:YES];
    DIUser *user = [DIUser getInstance];
    [user addUserDetailsListener:self];
    UserGender gender;
    if ([self.genderLabel.text isEqualToString:@"Male"]) {
        gender = UserGenderMale;
    }else if ([self.genderLabel.text isEqualToString:@"Female"]) {
        gender = UserGenderFemale;
    }else{
        gender = UserGenderNone;
    }
    [user updateGender:gender withBirthday:[self dateFromISO8601DateString:self.dateOfBirthLabel.text]];
}

- (NSDate *)dateFromISO8601DateString:(NSString *)dateString
{
    if (!dateString) return nil;
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setLenient:NO];
    }
    
    NSDate *date = nil;
    NSString *ISO8601String = [[NSString stringWithString:dateString] uppercaseString];
    /* Try e.g. 1983-03-12 */
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    date = [dateFormatter dateFromString:ISO8601String];
    
    if (!date) NSLog(@"Could not parse ISO8601 date: \"%@\" Possibly invalid format.", dateString);
    return date;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker{
    [self updatebirthdayLabel:datePicker.date];
}

-(void)updatebirthdayLabel:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    self.dateOfBirthLabel.text = strDate;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.gendersArray count];
}

#pragma mark - UIPickerViewDelegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.gendersArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        self.genderLabel.text = self.gendersArray[row];
}

-(IBAction)dateOfBirthUpdate:(UIDatePicker *)sender{
    [self updatebirthdayLabel:sender.date];

}

-(void)didUpdateSuccess{
    [self.genderActivityIndicator stopAnimating];
    [self.genderUpdateStatusLabel setHidden:NO];
    [self.genderUpdateStatusLabel setText:@"Updated Successfully"];
    
}
-(void)didUpdateFailedWithError:(nonnull NSError *)error{
    [self.genderActivityIndicator stopAnimating];
    [self.genderUpdateStatusLabel setHidden:NO];
    [self.genderUpdateStatusLabel setText:@"Updated failure"];
    DIRDebugLog(@"******* Gender status error %@",error);

}


@end
